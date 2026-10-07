BlackMarket = {
	Markets = {},
	Loaded = false,
}

local saveAndSync

local function removePayment(src, amount)
	return RemoveMoney(src, amount, "black_money")
end

local function refundPayment(src, amount)
	return AddMoney(src, amount, "black_money")
end

local function addPurchasedItem(src, item, amount)
	return AddItem(src, item, amount)
end

local function electusGangsStarted()
	local resource = "electus_gangs"

	return Config.ElectusGangs.Enabled
		and resource
		and (GetResourceState(resource) == "started" or GetResourceState(resource) == "starting")
end

local function coordsToTable(coords)
	if not coords then
		return nil
	end

	if type(coords) == "vector3" or type(coords) == "vector4" then
		return {
			x = coords.x,
			y = coords.y,
			z = coords.z,
			w = coords.w or 0.0,
		}
	end

	if type(coords) == "table" then
		return {
			x = tonumber(coords.x or coords[1]) or 0.0,
			y = tonumber(coords.y or coords[2]) or 0.0,
			z = tonumber(coords.z or coords[3]) or 0.0,
			w = tonumber(coords.w or coords.heading or coords.h or coords[4]) or 0.0,
		}
	end

	return nil
end

local function normalizeNpc(npc)
	npc = npc or {}

	return {
		model = npc.model or Config.DefaultPed.Model,
		coords = coordsToTable(npc.coords),
		scenario = npc.scenario or Config.DefaultPed.Scenario,
		invincible = npc.invincible ~= false,
	}
end

local function normalizeHour(value, fallback)
	local hour = math.floor(tonumber(value) or fallback or 0)

	if hour < 0 then
		return 0
	end

	if hour > 23 then
		return 23
	end

	return hour
end

local function normalizeSchedule(schedule)
	local defaults = Config.DefaultMarketSchedule or {}
	schedule = type(schedule) == "table" and schedule or {}
	local enabled = schedule.enabled

	if enabled == nil then
		enabled = schedule.Enabled
	end

	if enabled == nil then
		enabled = defaults.Enabled
	end

	return {
		enabled = enabled ~= false,
		startHour = normalizeHour(schedule.startHour or schedule.StartHour, defaults.StartHour or 20),
		endHour = normalizeHour(schedule.endHour or schedule.EndHour, defaults.EndHour or 6),
	}
end

local function sanitizeId(value)
	if type(value) ~= "string" then
		return nil
	end

	value = value:gsub("%s+", "_"):lower()
	value = value:gsub("[^%w_%-:]", "")

	if #value < 2 or #value > 64 then
		return nil
	end

	return value
end

local function sanitizeItems(items)
	local clean = {}

	if type(items) ~= "table" then
		return clean
	end

	for index, item in ipairs(items) do
		if type(item) == "table" then
			local name = type(item.item) == "string" and item.item:gsub("%s+", "") or nil
			local label = type(item.label) == "string" and item.label:sub(1, 80) or name
			local price = math.floor(tonumber(item.price) or 0)
			local amount = math.floor(tonumber(item.amount) or 1)
			local maxStock24h = math.floor(tonumber(item.maxStock24h) or 0)

			if name and name ~= "" and price >= 0 then
				clean[#clean + 1] = {
					id = sanitizeId(item.id or name) or ("%s_%s"):format(name, index),
					item = name,
					label = label or name,
					price = price,
					amount = amount > 0 and amount or 1,
					maxStock24h = maxStock24h > 0 and maxStock24h or 0,
					metadata = type(item.metadata) == "table" and item.metadata or nil,
					enabled = item.enabled ~= false,
				}
			end
		end
	end

	return clean
end

local function normalizeMarket(market, source)
	if type(market) ~= "table" then
		return nil
	end

	local id = sanitizeId(market.id)
	if not id then
		return nil
	end

	return {
		id = id,
		label = type(market.label) == "string" and market.label:sub(1, 128) or id,
		source = source or market.source or "ui",
		zoneId = market.zoneId and tonumber(market.zoneId) or nil,
		enabled = market.enabled ~= false,
		npc = normalizeNpc(market.npc),
		schedule = normalizeSchedule(market.schedule),
		access = type(market.access) == "table" and market.access or { type = "public" },
		items = sanitizeItems(market.items),
	}
end

local function marketForClient(market, includeItems)
	local data = {
		id = market.id,
		label = market.label,
		source = market.source,
		zoneId = market.zoneId,
		enabled = market.enabled,
		npc = market.npc,
		schedule = market.schedule,
	}

	if includeItems then
		data.items = {}

		for index, item in ipairs(market.items or {}) do
			local clientItem = {}

			for key, value in pairs(item) do
				clientItem[key] = value
			end

			local maxStock24h = tonumber(item.maxStock24h) or 0
			local sold24h = maxStock24h > 0 and GetItemSoldLast24h(market.id, item.item) or 0

			clientItem.sold24h = sold24h
			clientItem.remainingStock24h = maxStock24h > 0 and math.max(maxStock24h - sold24h, 0) or nil
			data.items[index] = clientItem
		end
	end

	return data
end

local function findMarketByZoneId(zoneId)
	if not zoneId then
		return nil
	end

	for _, market in pairs(BlackMarket.Markets) do
		if market.zoneId and tostring(market.zoneId) == tostring(zoneId) then
			return market
		end
	end

	return nil
end

local function getServerPlayerCoords(src)
	local ped = GetPlayerPed(src)
	if not ped or ped == 0 then
		return nil
	end

	local coords = GetEntityCoords(ped)

	return {
		x = coords.x,
		y = coords.y,
		z = coords.z,
		w = GetEntityHeading(ped),
	}
end

local function playerOwnsElectusGangZone(src, zoneId)
	if not zoneId or not electusGangsStarted() then
		return false
	end

	local resource = "electus_gangs"
	local gangId = exports[resource]:GetSourceGangId(src)
	local ownerGangId = exports[resource]:GetGangFromZoneId(zoneId).gangId
	if not gangId or not ownerGangId or tostring(gangId) ~= tostring(ownerGangId) then
		return false
	end

	if Config.ElectusGangs.RequirePlayerInZone then
		return tostring(exports[resource]:GetSourceZoneId(src)) == tostring(zoneId)
	end

	return true
end

local function buildGangZoneMarket(zoneId, coords)
	local existing = findMarketByZoneId(zoneId)
	local defaults = Config.ElectusGangs.DefaultZoneMarket or {}
	local npcDefaults = defaults.npc or {}
	local enabled = true

	if existing then
		enabled = existing.enabled ~= false
	end

	return normalizeMarket({
		id = existing and existing.id or ("zone:%s"):format(zoneId),
		label = existing and existing.label or defaults.label or ("Zone %s Black Market"):format(zoneId),
		source = "electus_gangs",
		zoneId = zoneId,
		enabled = enabled,
		npc = {
			model = existing and existing.npc and existing.npc.model or npcDefaults.model or Config.DefaultPed.Model,
			coords = coords,
			scenario = existing and existing.npc and existing.npc.scenario
				or npcDefaults.scenario
				or Config.DefaultPed.Scenario,
			invincible = npcDefaults.invincible ~= false,
		},
		schedule = existing and existing.schedule or defaults.schedule,
		access = { type = "electus_zone" },
		items = existing and existing.items or defaults.items or {},
	}, "electus_gangs")
end

local function getZoneBlackMarketMarker(customData)
	if type(customData) == "string" and customData ~= "" then
		customData = json.decode(customData)
	end

	if type(customData) ~= "table" then
		return nil
	end

	local zoneType = Config.ElectusGangs.ZoneType
	local zoneTypeName = zoneType.Name
	local actionName = zoneType.ActionName
	local zoneData = customData[zoneTypeName]

	if type(zoneData) ~= "table" then
		return nil
	end

	return coordsToTable(zoneData[actionName])
end

local function syncGangZoneMarket(zone, customData)
	if not Config.ElectusGangs.Enabled or type(zone) ~= "table" then
		return
	end

	local zoneId = tonumber(zone.id)
	local marker = getZoneBlackMarketMarker(customData)

	if not zoneId or not marker then
		return
	end

	local market = buildGangZoneMarket(zoneId, marker)
	if not market then
		return
	end

	saveAndSync(market, nil, L("zone_marker_set"))
end

local function applyDatabaseRow(row)
	local decodedCoords = {}
	local decodedSchedule = nil
	local decodedItems = {}

	if row.npc_coords and row.npc_coords ~= "" then
		decodedCoords = json.decode(row.npc_coords) or {}
	end

	if row.schedule and row.schedule ~= "" then
		decodedSchedule = json.decode(row.schedule) or nil
	end

	if row.items and row.items ~= "" then
		decodedItems = json.decode(row.items) or {}
	end

	local existing = BlackMarket.Markets[row.id]
	local source = row.source or (existing and existing.source) or "ui"

	local market = normalizeMarket({
		id = row.id,
		label = row.label,
		source = source,
		zoneId = row.zone_id,
		enabled = row.enabled == true or row.enabled == 1 or row.enabled == "1",
		npc = {
			model = row.npc_model,
			coords = decodedCoords,
			scenario = row.npc_scenario,
		},
		schedule = decodedSchedule,
		access = existing and existing.access or (row.zone_id and { type = "electus_zone" } or { type = "public" }),
		items = decodedItems,
	}, source)

	if market then
		if existing and existing.zoneId and not market.zoneId then
			market.zoneId = existing.zoneId
		end

		if existing and existing.access then
			market.access = existing.access
		end

		BlackMarket.Markets[market.id] = market
	end
end

function BlackMarket.Register(market, source)
	local normalized = normalizeMarket(market, source)

	if not normalized then
		return false
	end

	BlackMarket.Markets[normalized.id] = normalized
	TriggerClientEvent("electus_black_market:client:syncMarkets", -1, BlackMarket.GetClientMarkets())
	return true
end

function BlackMarket.LoadBaseMarkets()
	BlackMarket.Markets = {}

	for _, market in ipairs(Config.BlackMarkets or {}) do
		BlackMarket.Register(market, "config")
	end
end

function BlackMarket.Reload(cb)
	BlackMarket.LoadBaseMarkets()

	local rows = LoadMarkets()

	for _, row in ipairs(rows or {}) do
		applyDatabaseRow(row)
	end

	BlackMarket.Loaded = true
	TriggerClientEvent("electus_black_market:client:syncMarkets", -1, BlackMarket.GetClientMarkets())

	if cb then
		cb(true)
	end
end

function BlackMarket.GetClientMarkets()
	local markets = {}

	for _, market in pairs(BlackMarket.Markets) do
		if market.enabled and market.npc and market.npc.coords then
			markets[#markets + 1] = marketForClient(market, false)
		end
	end

	table.sort(markets, function(a, b)
		return a.id < b.id
	end)

	return markets
end

function BlackMarket.GetManageMarkets()
	local markets = {}

	for _, market in pairs(BlackMarket.Markets) do
		markets[#markets + 1] = marketForClient(market, true)
	end

	table.sort(markets, function(a, b)
		return a.id < b.id
	end)

	return markets
end

function BlackMarket.FindItem(market, itemId)
	for _, item in ipairs(market.items or {}) do
		if item.enabled ~= false and (item.id == itemId or item.item == itemId) then
			return item
		end
	end

	return nil
end

function BlackMarket.HasAccess(src, market)
	if not market or market.enabled == false then
		return false, L("no_market")
	end

	if market.zoneId then
		if not playerOwnsElectusGangZone(src, market.zoneId) then
			return false, L("no_access")
		end
	end

	local access = market.access or { type = "public" }

	if access.type == "public" or access.type == nil then
		return true
	end

	if access.type == "electus_zone" then
		return playerOwnsElectusGangZone(src, market.zoneId), L("no_access")
	end

	return true
end

function BlackMarket.IsNearMarket(src, market)
	if not market or not market.npc or not market.npc.coords then
		return false
	end

	local ped = GetPlayerPed(src)
	if not ped or ped == 0 then
		return false
	end

	local playerCoords = GetEntityCoords(ped)
	local npcCoords = market.npc.coords
	local distance = #(playerCoords - vector3(npcCoords.x, npcCoords.y, npcCoords.z))

	return distance <= Config.Security.MaxPurchaseDistance
end

saveAndSync = function(market, respond, successMessage)
	local ok, saved = pcall(function()
		return SaveMarket(market)
	end)

	if not ok then
		debugprint(("Failed to save market '%s': %s"):format(market.id, saved))

		return {
			ok = false,
			message = L("zone_marker_failed"),
		}
	end

	if not saved then
		return {
			ok = false,
			message = L("db_missing"),
		}
	end

	BlackMarket.Markets[market.id] = market
	TriggerClientEvent("electus_black_market:client:syncMarkets", -1, BlackMarket.GetClientMarkets())
	debugprint(("Saved black market '%s'."):format(market.id))

	return {
		ok = true,
		message = successMessage,
	}
end

RegisterServerCallback("electus_black_market:getClientMarkets", function()
	if not BlackMarket.Loaded then
		BlackMarket.Reload()
	end

	return {
		ok = true,
		markets = BlackMarket.GetClientMarkets(),
	}
end)

RegisterServerCallback("electus_black_market:getMarket", function(src, marketId)
	local market = BlackMarket.Markets[marketId]
	local access, reason = BlackMarket.HasAccess(src, market)

	if not access then
		return {
			ok = false,
			message = reason or L("no_access"),
		}
	end

	return {
		ok = true,
		market = marketForClient(market, true),
	}
end)

RegisterServerCallback("electus_black_market:buyItem", function(src, payload)
	payload = payload or {}
	local market = BlackMarket.Markets[payload.marketId]
	local amount = math.floor(tonumber(payload.amount) or 1)

	if amount < 1 or amount > Config.Security.MaxPurchaseAmount then
		return {
			ok = false,
			message = L("invalid_amount"),
		}
	end

	local access, reason = BlackMarket.HasAccess(src, market)
	if not access then
		return {
			ok = false,
			message = reason or L("no_access"),
		}
	end

	if not BlackMarket.IsNearMarket(src, market) then
		return {
			ok = false,
			message = L("too_far"),
		}
	end

	local item = BlackMarket.FindItem(market, payload.itemId)
	if not item then
		return {
			ok = false,
			message = L("invalid_item"),
		}
	end

	local itemAmount = (tonumber(item.amount) or 1) * amount
	local total = item.price * amount
	local maxStock24h = tonumber(item.maxStock24h) or 0

	if maxStock24h > 0 then
		local sold = GetItemSoldLast24h(market.id, item.item)
		if sold + itemAmount > maxStock24h then
			return {
				ok = false,
				message = L("stock_limit_reached"),
			}
		end
	end

	if not removePayment(src, total) then
		return {
			ok = false,
			message = L("not_enough_money"),
		}
	end

	if not addPurchasedItem(src, item.item, itemAmount) then
		refundPayment(src, total)
		return {
			ok = false,
			message = L("inventory_full"),
		}
	end

	LogTransaction(src, market, item, itemAmount)

	return {
		ok = true,
		message = L("purchase_success"),
		market = marketForClient(market, true),
	}
end, { preventSpam = true, rateLimit = 30 })

RegisterServerCallback("electus_black_market:getManageData", function(src)
	if not IsAdmin(src) then
		return {
			ok = false,
			message = L("not_admin"),
		}
	end

	return {
		ok = true,
		markets = BlackMarket.GetManageMarkets(),
	}
end)

RegisterServerCallback("electus_black_market:saveMarket", function(src, payload)
	if not IsAdmin(src) then
		return {
			ok = false,
			message = L("not_admin"),
		}
	end

	payload = payload or {}
	local existing = BlackMarket.Markets[payload.id]

	if not existing then
		return {
			ok = false,
			message = L("no_market"),
		}
	end

	local market = normalizeMarket({
		id = existing.id,
		label = payload.label or existing.label,
		source = existing.source,
		zoneId = existing.zoneId,
		enabled = payload.enabled ~= false,
		npc = payload.npc or existing.npc,
		schedule = payload.schedule or existing.schedule,
		access = existing.access,
		items = payload.items or existing.items,
	}, existing.source)

	return saveAndSync(market, nil, L("saved"))
end)

local function setGangZoneMarkerForSource(src, payload)
	debugprint(("Received gang zone marker request from %s."):format(src))

	if not Config.ElectusGangs.Enabled then
		return {
			ok = false,
			message = L("no_market"),
		}
	end

	payload = payload or {}
	local zoneId = tonumber(payload.zoneId)
	debugprint(("Resolved marker zone id: %s."):format(zoneId or "nil"))

	if not zoneId then
		return {
			ok = false,
			message = L("zone_missing"),
		}
	end

	local coords = coordsToTable(payload.coords) or getServerPlayerCoords(src)
	debugprint(
		("Resolved marker coords: %s."):format(coords and ("%s, %s, %s"):format(coords.x, coords.y, coords.z) or "nil")
	)
	if not coords then
		return {
			ok = false,
			message = L("zone_marker_failed"),
		}
	end

	local market = buildGangZoneMarket(zoneId, coords)
	if not market then
		return {
			ok = false,
			message = L("zone_marker_failed"),
		}
	end

	debugprint(("Saving gang zone black market '%s' for zone %s."):format(market.id, zoneId))
	return saveAndSync(market, nil, L("zone_marker_set"))
end

RegisterServerCallback("electus_black_market:setGangZoneMarker", function(src, payload)
	return setGangZoneMarkerForSource(src, payload)
end)

RegisterNetEvent("electus_black_market:server:setGangZoneMarker", function(payload)
	local src = source
	local response = setGangZoneMarkerForSource(src, payload)

	-- if response and response.message then
	-- 	TriggerClientEvent(
	-- 		"electus_black_market:client:notify",
	-- 		src,
	-- 		response.message,
	-- 		response.ok and "success" or "error"
	-- 	)
	-- end
end)

RegisterServerCallback("electus_black_market:deleteMarket", function(src, id)
	if not IsAdmin(src) then
		return {
			ok = false,
			message = L("not_admin"),
		}
	end

	local market = BlackMarket.Markets[id]
	if not market then
		return {
			ok = false,
			message = L("no_market"),
		}
	end

	if market.source ~= "ui" then
		market.enabled = false
		return saveAndSync(market, nil, L("deleted"))
	end

	DeleteMarket(id)
	BlackMarket.Markets[id] = nil
	TriggerClientEvent("electus_black_market:client:syncMarkets", -1, BlackMarket.GetClientMarkets())

	return {
		ok = true,
		message = L("deleted"),
	}
end)

RegisterCommand(Config.Command.Manage, function(src)
	if not IsAdmin(src) then
		TriggerClientEvent("electus_black_market:client:notify", src, L("not_admin"), "error")
		return
	end

	TriggerClientEvent("electus_black_market:client:openManager", src)
end, false)

CreateThread(function()
	Wait(500)
	BlackMarket.Reload()
end)

AddEventHandler("onResourceStart", function(resource)
	if resource == "electus_gangs" then
		Wait(1000)
		BlackMarket.Reload()
	end
end)

AddEventHandler("electus_gangs:server:zoneCreated", function(src, zone, customData)
	syncGangZoneMarket(zone, customData)
end)

AddEventHandler("electus_gangs:server:zoneEdited", function(src, zone, customData)
	syncGangZoneMarket(zone, customData)
end)

exports("RegisterBlackMarket", function(market)
	return BlackMarket.Register(market, market.source or "external")
end)

exports("GetBlackMarkets", function()
	return BlackMarket.GetManageMarkets()
end)

exports("GetBlackMarket", function(id)
	return BlackMarket.Markets[id]
end)
