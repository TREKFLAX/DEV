local activeInteractions = {}

function SendReactMessage(action, data)
	SendNUIMessage({
		action = action,
		data = data,
	})
end

function ToggleNuiFrame(shouldShow)
	DisableIdleCamera(shouldShow)
	SetNuiFocus(shouldShow, shouldShow)
	SendReactMessage("setVisible", shouldShow)

	if not shouldShow then
		DestroyBlackMarketCamera()
	end
end

function NotifyPlayer(text, notifyType)
	Notify(text, notifyType, L("black_market"))
end

function GetPlayerCoordsWithHeading()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)

	return {
		x = coords.x,
		y = coords.y,
		z = coords.z,
		w = GetEntityHeading(ped),
	}
end

local function getNpcPropConfig()
	local prop = Config.NpcProp or {}

	if prop.Enabled == false then
		return nil
	end

	return prop
end

local function getNpcPropPlacement(coords)
	local prop = getNpcPropConfig()
	if not prop or not coords then
		return nil
	end

	local offset = prop.Offset or vector3(0.0, -1.05, 0.0)
	local heading = coords.w or coords.heading or 0.0
	local position = GetOffsetFromCoordAndHeadingInWorldCoords(
		coords.x,
		coords.y,
		coords.z,
		heading,
		offset.x or 0.0,
		offset.y or -1.05,
		offset.z or 0.0
	)

	return position, (heading + (prop.HeadingOffset or 0.0)) % 360.0
end

function CreateBlackMarketNpcProp(coords, options)
	local prop = getNpcPropConfig()
	if not prop or not coords then
		return nil
	end

	options = options or {}

	local model = LoadModel(prop.Model)
	if not model then
		return nil
	end

	local position, heading = getNpcPropPlacement(coords)
	if not position then
		SetModelAsNoLongerNeeded(model)
		return nil
	end

	local object = CreateObject(model, position.x, position.y, position.z, false, true, false)
	SetEntityAsMissionEntity(object, true, true)
	SetEntityHeading(object, heading)
	FreezeEntityPosition(object, true)
	SetEntityCollision(object, options.collision ~= false, options.collision ~= false)
	PlaceObjectOnGroundProperly(object)

	if options.alpha then
		SetEntityAlpha(object, options.alpha, false)
	end

	SetModelAsNoLongerNeeded(model)
	return object
end

function UpdateBlackMarketNpcProp(propEntity, coords, options)
	if not propEntity or not DoesEntityExist(propEntity) then
		return
	end

	options = options or {}

	local position, heading = getNpcPropPlacement(coords)
	if not position then
		return
	end

	SetEntityCoordsNoOffset(propEntity, position.x, position.y, position.z, false, false, false)
	SetEntityHeading(propEntity, heading)
	PlaceObjectOnGroundProperly(propEntity)

	if options.alpha then
		SetEntityAlpha(propEntity, options.alpha, false)
	end
end

function CreateBlackMarketPed(market)
	local npc = market.npc

	if not npc or not npc.coords then
		return
	end

	local model = LoadModel(npc.model or Config.DefaultPed.Model)
	if not model then
		return
	end

	local coords = npc.coords
	local ped = CreatePed(4, model, coords.x, coords.y, coords.z, coords.w or 0.0, false, true)

	SetEntityAsMissionEntity(ped, true, true)
	SetEntityHeading(ped, coords.w or 0.0)
	FreezeEntityPosition(ped, true)
	SetBlockingOfNonTemporaryEvents(ped, true)

	if npc.invincible ~= false then
		SetEntityInvincible(ped, true)
	end

	if npc.scenario and npc.scenario ~= "" then
		TaskStartScenarioInPlace(ped, npc.scenario, 0, true)
	end

	local prop = CreateBlackMarketNpcProp(coords)

	SetModelAsNoLongerNeeded(model)
	return ped, prop
end

function DeleteBlackMarketPed(ped)
	if ped and DoesEntityExist(ped) then
		DeleteEntity(ped)
	end
end

function AddBlackMarketInteraction(marketId, ped, onOpen)
	activeInteractions[marketId] = AddEntityInteractPoint({
		entity = ped,
		name = "electus_black_market:" .. marketId,
		options = {
			{
				label = L("interact"),
				icon = "fa-solid fa-user-secret",
				action = function()
					onOpen(marketId)
				end,
			},
		},
	})
end

function RemoveBlackMarketInteraction(marketId)
	local interaction = activeInteractions[marketId]

	if interaction and interaction.remove then
		interaction:remove()
	end

	activeInteractions[marketId] = nil
end

function RemoveBlackMarketInteractions()
	for _, interaction in pairs(activeInteractions) do
		if interaction and interaction.remove then
			interaction:remove()
		end
	end

	activeInteractions = {}
end
