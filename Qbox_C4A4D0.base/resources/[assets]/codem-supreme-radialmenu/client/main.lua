local isMenuOpen = false
local DynamicMenuItems = {}
local FinalMenuItems = {}
local currentMugshot = nil
local radialBehaviour = 'press'

local function getPlayerName()
    local data = Framework:GetPlayerData()

    if Framework.Type == 'qbx' or Framework.Type == 'qbcore' then
        if data.charinfo then
            return data.charinfo.firstname .. ' ' .. data.charinfo.lastname
        end
    elseif Framework.Type == 'esx' then
        if data.firstName then
            return data.firstName .. ' ' .. data.lastName
        end
    end

    return GetPlayerName(PlayerId())
end

local function getPlayerId()
    return GetPlayerServerId(PlayerId())
end

local function ResolveServerName()
    if GetResourceState('codem-supreme-hud') == 'started' then
        local ok, info = pcall(function() return exports['codem-supreme-hud']:GetServerInfo() end)
        if ok and type(info) == 'table' and info.name and info.name ~= '' then return info.name end
    end
    return Config.ServerName or ''
end

local function sendPlayerData()
    SendNUIMessage({
        action = 'setPlayerData',
        data = {
            name = getPlayerName(),
            id = tostring(getPlayerId()),
            serverName = ResolveServerName()
        }
    })
end

local function getLocalizedDefaultCommands()
    local defaults = Config.DefaultCommands or {}
    local localized = {}
    for i, cmd in ipairs(defaults) do
        local copy = {}
        for k, v in pairs(cmd) do
            copy[k] = v
        end
        if copy.labelKey then
            copy.label = _L(copy.labelKey)
            copy.labelKey = nil
        end
        localized[i] = copy
    end
    return localized
end

local function sendDefaultCommands()
    local cmdMenu = Config.CommandMenu or {}
    SendNUIMessage({
        action = 'setDefaultCommands',
        data = getLocalizedDefaultCommands(),
        commandMenuEnabled = cmdMenu.enabled ~= false
    })
end

local cachedLocale = { code = nil, data = nil }
local localePromise = nil

RegisterNetEvent('codem-radialmenu:client:getLocaleResult', function(result)
    if localePromise then
        localePromise(result)
        localePromise = nil
    end
end)

local function requestLocaleFromServer(desired)
    if Framework.Type == 'qbx' then
        return lib.callback.await('codem-radialmenu:server:getLocale', false, desired)
    elseif Framework.Type == 'qbcore' then
        local p = promise.new()
        Framework.Object.Functions.TriggerCallback('codem-radialmenu:server:getLocale', function(result)
            p:resolve(result)
        end, desired)
        return Citizen.Await(p)
    else
        local p = promise.new()
        localePromise = function(result) p:resolve(result) end
        TriggerServerEvent('codem-radialmenu:server:getLocale', desired)
        return Citizen.Await(p)
    end
end

local function ensureLocaleLoaded()
    local desired = Config.Locale or "en"
    if cachedLocale.code == desired and cachedLocale.data then
        return
    end

    local result = requestLocaleFromServer(desired)
    if not result or not result.messages then
        print('[codem-radialmenu] server returned no locale data')
        return
    end

    cachedLocale.code = desired
    cachedLocale.data = result
end

local function sendLocale()
    ensureLocaleLoaded()
    if not cachedLocale.data then return end

    SendNUIMessage({
        action = 'setLocale',
        data = {
            locale = cachedLocale.data.locale,
            messages = cachedLocale.data.messages
        }
    })
end

local function captureMugshot()
    local ped = PlayerPedId()

    if currentMugshot then
        UnregisterPedheadshot(currentMugshot)
        currentMugshot = nil
    end

    local handle = RegisterPedheadshot(ped)

    local timeout = 50
    while not IsPedheadshotReady(handle) and timeout > 0 do
        Wait(100)
        timeout = timeout - 1
    end

    if not IsPedheadshotReady(handle) then
        UnregisterPedheadshot(handle)
        return nil
    end

    currentMugshot = handle
    local txd = GetPedheadshotTxdString(handle)

    SendNUIMessage({
        action = 'setMugshot',
        data = {
            txd = txd
        }
    })

    return txd
end

local function deepcopy(orig, skipPermCheck)
    if type(orig) ~= 'table' then
        return orig
    end

    if not skipPermCheck and orig.canOpen and type(orig.canOpen) == 'function' then
        if not orig.canOpen() then
            return nil
        end
    end

    local copy = {}
    for key, value in pairs(orig) do
        if key == 'canOpen' then
            copy[key] = value
        else
            local copied_value = deepcopy(value, true)
            if copied_value ~= nil then
                copy[key] = copied_value
            end
        end
    end

    local mt = getmetatable(orig)
    if mt then
        setmetatable(copy, deepcopy(mt, true))
    end

    return copy
end

local function setupVehicleMenu()
    local vehicle = getNearestVeh()
    if not vehicle then return {} end

    local items = {}

    local doorItems = {}
    for i = 0, 5 do
        if DoesVehicleHaveDoor(vehicle, i) then
            table.insert(doorItems, {
                id = 'door' .. i,
                label = VehicleDoorLabels[i] or _L('game.vehicle.door_fallback', i + 1),
                icon = 'door-open',
                event = 'codem-radialmenu:client:ToggleDoor',
                type = 'client',
                args = { door = i },
                shouldClose = false
            })
        end
    end

    if #doorItems > 0 then
        table.insert(items, {
            id = 'doors',
            label = _L('game.vehicle.doors'),
            icon = 'door-open',
            items = doorItems
        })
    end

    local seatItems = {}
    for i = -1, GetVehicleMaxNumberOfPassengers(vehicle) - 1 do
        if IsVehicleSeatFree(vehicle, i) then
            local seatLabel = i == -1 and _L('game.vehicle.driver') or _L('game.vehicle.seat', i + 2)
            table.insert(seatItems, {
                id = 'seat' .. i,
                label = seatLabel,
                icon = 'chair',
                event = 'codem-radialmenu:client:ChangeSeat',
                type = 'client',
                args = { seat = i },
                shouldClose = true
            })
        end
    end

    if #seatItems > 0 then
        table.insert(items, {
            id = 'seats',
            label = _L('game.vehicle.seats'),
            icon = 'chair',
            items = seatItems
        })
    end

    if Config.VehicleMenu and Config.VehicleMenu.EnableExtras then
        local extraItems = {}
        local extraCount = 0
        for i = 0, 12 do
            if DoesExtraExist(vehicle, i) then
                extraCount = extraCount + 1
                local isOn = IsVehicleExtraTurnedOn(vehicle, i)
                table.insert(extraItems, {
                    id = 'extra' .. i,
                    label = _L('game.vehicle.extra', extraCount, isOn and _L('game.common.on') or _L('game.common.off')),
                    icon = isOn and 'toggle-on' or 'toggle-off',
                    event = 'codem-radialmenu:client:ToggleExtra',
                    type = 'client',
                    args = { extra = i },
                    shouldClose = false
                })
            end
        end

        if #extraItems > 0 then
            table.insert(items, {
                id = 'extras',
                label = _L('game.vehicle.extras'),
                icon = 'sliders',
                items = extraItems
            })
        end
    end

    table.insert(items, {
        id = 'flip',
        label = _L('game.vehicle.flip'),
        icon = 'rotate',
        event = 'codem-radialmenu:client:FlipVehicle',
        type = 'client',
        shouldClose = true
    })

    return items
end

local function setupJobMenu()
    local job = Framework:GetPlayerJob()

    if not job or not job.name or job.name == 'unemployed' then
        return nil
    end

    if not job.onduty then
        return nil
    end

    local jobMenu = JobInteractions[job.name]
    if not jobMenu then
        return nil
    end

    if jobMenu.canOpen and not jobMenu.canOpen() then
        return nil
    end

    local copied = deepcopy(jobMenu)
    if not copied then
        return nil
    end

    if copied.items then

        copied.label = copied.label or copied.title or _L('game.menu.job_actions')
        return copied
    else

        return {
            id = job.name,
            label = job.label or job.name:gsub("^%l", string.upper),
            icon = 'briefcase',
            items = copied
        }
    end
end

local function buildMenuItems()
    FinalMenuItems = {}

    local isDead = Framework:IsDead()

    if isDead then
        table.insert(FinalMenuItems, {
            id = 'emergency',
            label = _L('game.vehicle.emergency'),
            icon = 'phone',
            event = 'hospital:client:CallEmergency',
            type = 'client',
            shouldClose = true
        })
        return
    end

    for _, menuData in ipairs(MenuItems) do
        local copiedMenu = deepcopy(menuData)
        if copiedMenu then
            table.insert(FinalMenuItems, copiedMenu)
        end
    end

    local cmdMenu = Config.CommandMenu or {}
    if cmdMenu.enabled ~= false then
        table.insert(FinalMenuItems, {
            id = cmdMenu.id or 'commands',
            label = cmdMenu.label or cmdMenu.title or _L('game.menu.commands'),
            icon = cmdMenu.icon or 'terminal',
            items = {}
        })
    end

    local jobMenu = setupJobMenu()
    if jobMenu then
        table.insert(FinalMenuItems, jobMenu)
    end

    local vehicleItems = setupVehicleMenu()
    if #vehicleItems > 0 then
        table.insert(FinalMenuItems, {
            id = 'vehicle',
            label = _L('game.vehicle.vehicle'),
            icon = 'car',
            items = vehicleItems
        })
    end

    for _, item in pairs(DynamicMenuItems) do
        local copiedItem = deepcopy(item)
        if copiedItem then
            table.insert(FinalMenuItems, copiedItem)
        end
    end
end

local function convertToNUIFormat(items)
    local converted = {}
    local idCounter = 1

    for _, item in ipairs(items) do
        local nuiItem = {
            id = idCounter,
            label = item.label or item.title,
            icon = item.icon,
            action = item.id
        }

        if item.items then
            nuiItem.items = convertToNUIFormat(item.items)
        end

        table.insert(converted, nuiItem)
        idCounter = idCounter + 1
    end

    return converted
end

local function openRadialMenu()
    if isMenuOpen then return end
    if IsPauseMenuActive() then return end

    buildMenuItems()

    local nuiItems = convertToNUIFormat(FinalMenuItems)

    SetCursorLocation(0.5, 0.5)
    SetNuiFocus(true, true)

    if radialBehaviour == 'hold' then
        SetNuiFocusKeepInput(true)
    end
    sendLocale()
    SendNUIMessage({
        action = 'openMenu',
        items = nuiItems
    })

    isMenuOpen = true
end

local function closeRadialMenu()
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)

    if isMenuOpen then
        SendNUIMessage({
            action = 'closeMenu'
        })
        isMenuOpen = false
    end
end

CreateThread(function()
    while true do
        if isMenuOpen and radialBehaviour == 'hold' then

            DisableAllControlActions(0)
            DisableAllControlActions(1)
            DisableAllControlActions(2)
            Wait(0)
        else
            Wait(500)
        end
    end
end)

RegisterKeyMapping('+radialmenu', _L('game.keymap.open'), 'keyboard', 'F3')
RegisterKeyMapping('-radialmenu', _L('game.keymap.close'), 'keyboard', '')

RegisterCommand('+radialmenu', function()
    if not isMenuOpen then
        openRadialMenu()
    end
end, false)

RegisterCommand('-radialmenu', function()
    if radialBehaviour == 'hold' and isMenuOpen then
        closeRadialMenu()
    end
end, false)

RegisterCommand('radialsettings', function()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openSettings'
    })
    sendLocale()
    sendPlayerData()
    captureMugshot()
    sendDefaultCommands()
end, false)

RegisterNUICallback('closeMenu', function(_, cb)
    closeRadialMenu()
    cb('ok')
end)

RegisterNUICallback('setRadialBehaviour', function(data, cb)
    if data and data.behaviour then
        if data.behaviour == 'hold' or data.behaviour == 'press' then
            radialBehaviour = data.behaviour
        end
    end
    cb('ok')
end)

local function findMenuItem(items, targetId)
    for _, item in ipairs(items) do
        if item.id == targetId then
            return item
        end
        if item.items then
            local found = findMenuItem(item.items, targetId)
            if found then return found end
        end
    end
    return nil
end

RegisterNUICallback('selectItem', function(data, cb)

    if not data or type(data) ~= 'table' then
        closeRadialMenu()
        cb('error')
        return
    end

    if not data.action or type(data.action) ~= 'string' then
        closeRadialMenu()
        cb('error')
        return
    end

    if #data.action > 200 then
        closeRadialMenu()
        cb('error')
        return
    end

    local action = data.action

    if string.sub(action, 1, 1) == '/' then
        closeRadialMenu()
        ExecuteCommand(string.sub(action, 2))
        cb('ok')
        return
    end

    local menuItem = findMenuItem(FinalMenuItems, action)

    if not menuItem or menuItem.shouldClose ~= false then
        closeRadialMenu()
    end

    if menuItem and menuItem.event then
        local eventData = { id = menuItem.id }
        if menuItem.args then
            for k, v in pairs(menuItem.args) do
                eventData[k] = v
            end
        end

        if menuItem.type == 'server' then
            TriggerServerEvent(menuItem.event, eventData)
        else
            TriggerEvent(menuItem.event, eventData)
        end
        cb('ok')
        return
    end

    cb('ok')
end)

exports('AddMenuItem', function(item)
    if not item or not item.id then
        return false
    end
    DynamicMenuItems[item.id] = item
    return true
end)

exports('RemoveMenuItem', function(itemId)
    if DynamicMenuItems[itemId] then
        DynamicMenuItems[itemId] = nil
        return true
    end
    return false
end)

local settingsPromise = nil

RegisterNUICallback('returnSettings', function(data, cb)
    if settingsPromise then
        settingsPromise(data)
        settingsPromise = nil
    end
    cb('ok')
end)

exports("GetSettings", function()
    local p = promise.new()
    settingsPromise = function(data) p:resolve(data) end
    SendNUIMessage({ action = "getSettings" })
    return Citizen.Await(p)
end)

exports("UpdateSettings", function(data)
    SendNUIMessage({ action = "updateSettings", data = data })
end)

local commandsPromise = nil

RegisterNUICallback('returnCustomCommands', function(data, cb)
    if commandsPromise then
        commandsPromise(data.commands or {})
        commandsPromise = nil
    end
    cb('ok')
end)

exports("GetCustomCommands", function()
    local p = promise.new()
    commandsPromise = function(data) p:resolve(data) end
    SendNUIMessage({ action = "getCustomCommands" })
    return Citizen.Await(p)
end)

exports("SetCustomCommands", function(commands)
    SendNUIMessage({ action = "setCustomCommands", data = commands })
end)

exports("IsCommandMenuEnabled", function()
    return (Config.CommandMenu or {}).enabled ~= false
end)

exports("GetDefaultCommands", function()
    return getLocalizedDefaultCommands()
end)

RegisterNetEvent('codem-radialmenu:client:OpenSettings', function()
    SendNUIMessage({
        action = 'openSettings'
    })
    SetNuiFocus(true, true)
    sendLocale()
    sendPlayerData()
    captureMugshot()
    sendDefaultCommands()
end)
