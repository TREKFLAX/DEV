local Markets = {}
local Peds = {}
local Props = {}
local Blips = {}
local ActiveCam
local ActiveMarketId
local gangZoneIntegrationRegistered = false
local isMarketAvailableNow

local function resourceStarted(resource)
	return resource and (GetResourceState(resource) == "started" or GetResourceState(resource) == "starting")
end

local function rotationToDirection(rotation)
	local z = math.rad(rotation.z)
	local x = math.rad(rotation.x)
	local cosX = math.abs(math.cos(x))

	return vector3(-math.sin(z) * cosX, math.cos(z) * cosX, math.sin(x))
end

local function getCameraRaycastCoords(ignoreEntity)
	local camCoords = GetGameplayCamCoord()
	local direction = rotationToDirection(GetGameplayCamRot(2))
	local destination = camCoords + direction * 80.0
	local ray = StartShapeTestRay(
		camCoords.x,
		camCoords.y,
		camCoords.z,
		destination.x,
		destination.y,
		destination.z,
		1,
		ignoreEntity or PlayerPedId(),
		0
	)
	local _, hit, endCoords = GetShapeTestResult(ray)

	if hit == 1 then
		return endCoords
	end

	return nil
end

local function getGroundPlacementCoords(coords)
	if not coords then
		return nil
	end

	local foundGround, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z + 2.0, false)

	if foundGround then
		return vector3(coords.x, coords.y, groundZ)
	end

	return coords
end

local function createPlacementPreviewPed()
	local defaultZoneMarket = Config.ElectusGangs.DefaultZoneMarket or {}
	local npc = defaultZoneMarket.npc or {}
	local model = LoadModel(npc.model or Config.DefaultPed.Model)
	if not model then
		return nil
	end

	local playerCoords = GetEntityCoords(PlayerPedId())
	local ped = CreatePed(
		4,
		model,
		playerCoords.x,
		playerCoords.y,
		playerCoords.z,
		GetEntityHeading(PlayerPedId()),
		false,
		true
	)

	SetEntityAsMissionEntity(ped, true, true)
	FreezeEntityPosition(ped, true)
	SetEntityCollision(ped, false, false)
	SetEntityAlpha(ped, 170, false)
	SetBlockingOfNonTemporaryEvents(ped, true)
	SetEntityInvincible(ped, true)
	SetModelAsNoLongerNeeded(model)

	return ped
end

local function selectBlackMarketPedPlacement()
	DrawHelpText({
		{ "Place black market ped", 38, "~INPUT_CONTEXT~" },
		{ "Rotate left", 174, "~INPUT_CELLPHONE_LEFT~" },
		{ "Rotate right", 175, "~INPUT_CELLPHONE_RIGHT~" },
		{ "Cancel", 177, "~INPUT_CELLPHONE_CANCEL~" },
	})

	local previewPed = createPlacementPreviewPed()
	local previewProp = CreateBlackMarketNpcProp(GetPlayerCoordsWithHeading(), {
		alpha = 170,
		collision = false,
	})
	local selectedCoords
	local heading = GetEntityHeading(PlayerPedId())

	while true do
		Wait(0)

		DisableControlAction(0, 24, true)
		DisableControlAction(0, 25, true)
		DisableControlAction(0, 174, true)
		DisableControlAction(0, 175, true)

		local coords = getCameraRaycastCoords(previewPed)
		if coords then
			if IsControlPressed(0, 174) or IsDisabledControlPressed(0, 174) then
				heading = heading - 1.5
			end

			if IsControlPressed(0, 175) or IsDisabledControlPressed(0, 175) then
				heading = heading + 1.5
			end

			heading = heading % 360.0
			coords = getGroundPlacementCoords(coords)

			if previewPed and DoesEntityExist(previewPed) then
				SetEntityCoordsNoOffset(previewPed, coords.x, coords.y, coords.z + 1.0, false, false, false)
				SetEntityHeading(previewPed, heading)

				SetEntityAlpha(previewPed, 185, false)
			end

			UpdateBlackMarketNpcProp(previewProp, {
				x = coords.x,
				y = coords.y,
				z = coords.z,
				w = heading,
			}, {
				alpha = 185,
			})

			if IsControlJustPressed(0, 38) then
				selectedCoords = coords
				break
			end
		end

		if IsControlJustPressed(0, 177) or IsControlJustPressed(0, 200) then
			break
		end
	end

	ClearHelpText()

	if previewPed and DoesEntityExist(previewPed) then
		DeleteEntity(previewPed)
	end

	if previewProp and DoesEntityExist(previewProp) then
		DeleteEntity(previewProp)
	end

	if not selectedCoords then
		return nil
	end

	return {
		x = math.round(selectedCoords.x, 2),
		y = math.round(selectedCoords.y, 2),
		z = math.round(selectedCoords.z, 2),
		w = heading,
	}
end

local function setGangZoneBlackMarketMarker(zone)
	local zoneId = zone and zone.id
	debugprint("Black Market zone action handler called.")

	local marker = selectBlackMarketPedPlacement()

	if marker then
		debugprint(
			("Selected marker for zone %s at %.2f, %.2f, %.2f."):format(
				zoneId or "nil",
				marker.x or 0.0,
				marker.y or 0.0,
				marker.z or 0.0
			)
		)
		TriggerServerEvent("electus_black_market:server:setGangZoneMarker", {
			zoneId = zoneId,
			coords = marker,
		})
		return marker
	end

	debugprint("Marker selection cancelled.")
	return nil
end

local function registerGangZoneIntegration(force)
	if not Config.ElectusGangs.Enabled or not Config.ElectusGangs.ZoneType then
		return
	end

	if gangZoneIntegrationRegistered and not force then
		return
	end

	if not resourceStarted("electus_gangs") then
		debugprint(("Cannot register gang zone integration; %s is not started."):format("electus_gangs"))
		return
	end

	local zoneType = Config.ElectusGangs.ZoneType

	local ok, errorMessage = pcall(function()
		exports["electus_gangs"]:InitZoneType(zoneType.Name, zoneType.Label, zoneType.Description)
		exports["electus_gangs"]:RegisterZoneTypeAction(zoneType.Name, {
			name = zoneType.ActionName,
			label = zoneType.ActionLabel,
			closeManageZones = zoneType.CloseManageZones ~= false,
			buttonLabel = zoneType.ActionButtonLabel,
			resource = "electus_black_market",
			export = "SetGangZoneBlackMarketMarker",
		})
	end)

	if ok then
		gangZoneIntegrationRegistered = true
		debugprint(("Registered electus_gangs zone type '%s' action '%s'."):format(zoneType.Name, zoneType.ActionName))
	else
		debugprint(
			("[%s] Failed to register electus_gangs zone integration: %s"):format("electus_black_market", errorMessage)
		)
	end
end

function DestroyBlackMarketCamera()
	if ActiveCam then
		RenderScriptCams(false, true, Config.Camera.TransitionMs, true, true)
		DestroyCam(ActiveCam, false)
		ActiveCam = nil
	end
end

local function isGangBlackMarket(market)
	return market and market.source == "electus_gangs"
end

local function shouldShowGangMarketBlip(market)
	local blipConfig = Config.ElectusGangs.Blip or {}

	if not blipConfig.Enabled or not isGangBlackMarket(market) or not market.npc or not market.npc.coords then
		return false
	end

	if blipConfig.OnlyWhenAvailable ~= false and not isMarketAvailableNow(market) then
		return false
	end

	return true
end

local function removeGangMarketBlip(marketId)
	local blip = Blips[marketId]

	if blip and DoesBlipExist(blip) then
		RemoveBlip(blip)
	end

	Blips[marketId] = nil
end

local function syncGangMarketBlip(market)
	local marketId = market and market.id

	if not marketId then
		return
	end

	if not shouldShowGangMarketBlip(market) then
		removeGangMarketBlip(marketId)
		return
	end

	if Blips[marketId] and DoesBlipExist(Blips[marketId]) then
		return
	end

	local blipConfig = Config.ElectusGangs.Blip or {}
	local coords = market.npc.coords
	local blip = AddBlipForCoord(coords.x, coords.y, coords.z)

	SetBlipSprite(blip, blipConfig.Sprite or 500)
	SetBlipDisplay(blip, blipConfig.Display or 4)
	SetBlipScale(blip, blipConfig.Scale or 0.75)
	SetBlipColour(blip, blipConfig.Color or 1)
	SetBlipAsShortRange(blip, blipConfig.ShortRange ~= false)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(blipConfig.Label or market.label or "Gang Black Market")
	EndTextCommandSetBlipName(blip)

	Blips[marketId] = blip
end

local function createCameraForPed(ped)
	if not Config.Camera.Enabled or not ped or not DoesEntityExist(ped) then
		return
	end

	DestroyBlackMarketCamera()

	local offset = Config.Camera.Offset
	local pointOffset = Config.Camera.PointOffset
	local camCoords = GetOffsetFromEntityInWorldCoords(ped, offset.x, offset.y, offset.z)
	local target = GetOffsetFromEntityInWorldCoords(ped, pointOffset.x, pointOffset.y, pointOffset.z)

	ActiveCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
	SetCamCoord(ActiveCam, camCoords.x, camCoords.y, camCoords.z)
	PointCamAtCoord(ActiveCam, target.x, target.y, target.z)
	SetCamFov(ActiveCam, Config.Camera.Fov)
	RenderScriptCams(true, true, Config.Camera.TransitionMs, true, true)
end

local function clearPeds()
	RemoveBlackMarketInteractions()

	for _, ped in pairs(Peds) do
		DeleteBlackMarketPed(ped)
	end

	for _, prop in pairs(Props) do
		DeleteBlackMarketPed(prop)
	end

	for marketId in pairs(Blips) do
		removeGangMarketBlip(marketId)
	end

	Peds = {}
	Props = {}
	Blips = {}
end

isMarketAvailableNow = function(market)
	local schedule = market and market.schedule

	if not schedule or schedule.enabled == false then
		return true
	end

	local startHour = math.floor(tonumber(schedule.startHour) or 0)
	local endHour = math.floor(tonumber(schedule.endHour) or 0)
	local currentHour = GetClockHours()

	if startHour == endHour then
		return true
	end

	if startHour < endHour then
		return currentHour >= startHour and currentHour < endHour
	end

	return currentHour >= startHour or currentHour < endHour
end

local function despawnMarket(marketId)
	RemoveBlackMarketInteraction(marketId)
	DeleteBlackMarketPed(Peds[marketId])
	DeleteBlackMarketPed(Props[marketId])

	Peds[marketId] = nil
	Props[marketId] = nil

	if ActiveMarketId == marketId then
		CloseBlackMarket()
		NotifyPlayer(L("market_closed_for_time"), "error")
	end
end

local function syncSpawnedMarkets()
	for marketId, market in pairs(Markets) do
		syncGangMarketBlip(market)

		if isMarketAvailableNow(market) then
			if not Peds[marketId] then
				local ped, prop = CreateBlackMarketPed(market)

				if ped then
					Peds[marketId] = ped
					Props[marketId] = prop
					AddBlackMarketInteraction(marketId, ped, OpenBlackMarket)
				end
			end
		elseif Peds[marketId] then
			despawnMarket(marketId)
		end
	end
end

local function spawnMarkets(markets)
	clearPeds()
	Markets = {}

	for _, market in ipairs(markets or {}) do
		Markets[market.id] = market
	end

	syncSpawnedMarkets()
end

function CloseBlackMarket()
	ActiveMarketId = nil
	ToggleNuiFrame(false)
	SendReactMessage("updateComponent", {
		component = "",
	})
end

function OpenBlackMarket(marketId)
	if not Peds[marketId] or not isMarketAvailableNow(Markets[marketId]) then
		return NotifyPlayer(L("market_closed_for_time"), "error")
	end

	local response = AwaitServerCallback("electus_black_market:getMarket", marketId)

	if not response or not response.ok then
		return NotifyPlayer(response and response.message or L("no_market"), "error")
	end

	ActiveMarketId = marketId
	createCameraForPed(Peds[marketId])
	SendReactMessage("updateComponent", {
		component = "shop",
		market = response.market,
	})
	ToggleNuiFrame(true)
end

function OpenBlackMarketManager()
	local response = AwaitServerCallback("electus_black_market:getManageData")

	if not response or not response.ok then
		return NotifyPlayer(response and response.message or L("not_admin"), "error")
	end

	DestroyBlackMarketCamera()
	SendReactMessage("updateComponent", {
		component = "manager",
		markets = response.markets,
	})
	ToggleNuiFrame(true)
end

local function refreshMarkets()
	local response = AwaitServerCallback("electus_black_market:getClientMarkets")

	if response and response.ok then
		spawnMarkets(response.markets)
	end
end

RegisterNetEvent("electus_black_market:client:syncMarkets", spawnMarkets)
RegisterNetEvent("electus_black_market:client:openManager", OpenBlackMarketManager)

RegisterNetEvent("electus_black_market:client:notify", function(message, notifyType)
	NotifyPlayer(message, notifyType)
end)

RegisterNUICallback("hideFrame", function(_, cb)
	CloseBlackMarket()
	cb({})
end)

RegisterNUICallback("get_locale", function(_, cb)
	cb(GetAllLocales())
end)

RegisterNUICallback("buy_item", function(data, cb)
	local response = AwaitServerCallback("electus_black_market:buyItem", data)
	response = response or { ok = false, message = L("no_response") }
	if response.message then
		NotifyPlayer(response.message, response.ok and "success" or "error")
	end
	cb(response)
end)

RegisterNUICallback("save_market", function(data, cb)
	local response = AwaitServerCallback("electus_black_market:saveMarket", data)
	response = response or { ok = false, message = L("no_response") }
	if response.message then
		NotifyPlayer(response.message, response.ok and "success" or "error")
	end
	cb(response)
end)

RegisterNUICallback("delete_market", function(data, cb)
	local response = AwaitServerCallback("electus_black_market:deleteMarket", data and data.id)
	response = response or { ok = false, message = L("no_response") }
	if response.message then
		NotifyPlayer(response.message, response.ok and "success" or "error")
	end
	cb(response)
end)

RegisterNUICallback("refresh_manage", function(_, cb)
	local response = AwaitServerCallback("electus_black_market:getManageData")
	cb(response or { ok = false, message = L("no_response") })
end)

CreateThread(function()
	Wait(1000)
	registerGangZoneIntegration()
	refreshMarkets()
end)

CreateThread(function()
	local lastHour

	while true do
		Wait(30000)

		local currentHour = GetClockHours()
		if currentHour ~= lastHour then
			lastHour = currentHour
			syncSpawnedMarkets()
		end
	end
end)

AddEventHandler("onClientResourceStart", function(resource)
	if resource == "electus_gangs" then
		Wait(1000)
		registerGangZoneIntegration(true)
	end
end)

AddEventHandler("onResourceStop", function(resource)
	if resource ~= "electus_black_market" then
		return
	end

	CloseBlackMarket()
	clearPeds()
end)

exports("OpenBlackMarket", OpenBlackMarket)
exports("OpenBlackMarketManager", OpenBlackMarketManager)
exports("SetGangZoneBlackMarketMarker", setGangZoneBlackMarketMarker)
