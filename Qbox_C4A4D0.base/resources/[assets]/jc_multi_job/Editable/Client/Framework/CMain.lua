function ShowNotification(message, notifType)
    notifType = notifType or "inform"
    local notify = (Config.Notify and Config.Notify.Notification) or "ox_lib"
    if notify == "ox_lib" then
        if lib and lib.notify then
            lib.notify({ description = message, type = notifType })
        end
    elseif notify == "esx_framework" then
        if ESX and ESX.ShowNotification then
            ESX.ShowNotification(message)
        end
    elseif notify == "qb-core" then
        if QBCore and QBCore.Functions and QBCore.Functions.Notify then
            QBCore.Functions.Notify(message, notifType, 5000)
        else
            TriggerEvent("QBCore:Notify", message, notifType, 5000)
        end
    end
end

function GetPlayerJob()
    if Config.Framework == "esx" then
        local data = ESX.GetPlayerData()
        return data and data.job and data.job.name
    elseif Config.Framework == "qb" then
        if GetResourceState("qbx_core") == "started" then
            local data = exports.qbx_core:GetPlayerData()
            return data and data.job and data.job.name
        elseif QBCore then
            local data = QBCore.Functions.GetPlayerData()
            return data and data.job and data.job.name
        end
    end
    return nil
end

function GetPlayerJobGrade()
    if Config.Framework == "esx" then
        local data = ESX.GetPlayerData()
        return data and data.job and data.job.grade
    elseif Config.Framework == "qb" then
        if GetResourceState("qbx_core") == "started" then
            local data = exports.qbx_core:GetPlayerData()
            return data and data.job and data.job.grade and data.job.grade.level
        elseif QBCore then
            local data = QBCore.Functions.GetPlayerData()
            return data and data.job and data.job.grade and data.job.grade.level
        end
    end
    return nil
end

function GetPlayerGang()
    if Config.Framework == "qb" then
        if GetResourceState("qbx_core") == "started" then
            local data = exports.qbx_core:GetPlayerData()
            return data and data.gang and data.gang.name
        elseif QBCore then
            local data = QBCore.Functions.GetPlayerData()
            return data and data.gang and data.gang.name
        end
    end
    return nil
end

