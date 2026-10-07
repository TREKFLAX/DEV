
function drawInstructionalText(msg, coords)
    AddTextEntry('instructionalText', msg)
    SetFloatingHelpTextWorldPosition(1, coords)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('instructionalText')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(2, false, false, -1)
end

vRP = nil
ESX = nil

if config.Notifications.Enabled and config.Notifications.Framework.ESX then
    ESX = exports["es_extended"]:getSharedObject()
end

if config.Notifications.Enabled and config.Notifications.Framework.vRP then
    vRP = Proxy.getInterface("vRP")
end

function Notify(text)

    if not config.Notifications.Enabled then
        return
    end

    if config.Notifications.Framework.ESX then
        if ESX ~= nil then
            ESX.ShowNotification(text)
        end
    elseif config.Notifications.Framework.QBCore then
        TriggerEvent('QBCore:Notify', text, 'info')
    elseif config.Notifications.Framework.QBX then
        exports.qbx_core:Notify(text, 'primary')
    elseif config.Notifications.Framework.vRP then
        vRP.notify(source, {text})
    elseif config.Notifications.Framework.okok then
        exports['okokNotify']:Alert("Police Tracker", text, 2000, 'info', true)
    else
        showBaseNotification(text)
    end
end

function showBaseNotification(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(0,1)
end