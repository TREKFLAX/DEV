function GetPlayer(src)
    if Config.Framework == "esx" then
        return ESX.GetPlayerFromId(src)
    elseif Config.Framework == "qb" then
        return QBCore.Functions.GetPlayer(src)
    end
    return nil
end

function NotifyPlayer(source, message, notifType)
    if not source or source == 0 then return end
    message = tostring(message or "")
    notifType = notifType or "inform"
    local notify = (Config.Notify and Config.Notify.Notification) or "ox_lib"
    if notify == "qb-core" then
        TriggerClientEvent("QBCore:Notify", source, message, notifType, 5000)
    elseif notify == "esx_framework" then
        TriggerClientEvent("esx:showNotification", source, message)
    else
        TriggerClientEvent("ox_lib:notify", source, { description = message, type = notifType })
    end
end

