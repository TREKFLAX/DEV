function GetPlayerJob()
    if Config.Framework == "standalone" then
        return nil, 0, true
    end
    if Config.Framework == "esx" then
        local data = ESX and ESX.GetPlayerData and ESX.GetPlayerData() or nil
        if data and data.job and data.job.name then
            local grade = tonumber(data.job.grade)
            if grade == nil then grade = tonumber(data.job.grade_level) end
            return data.job.name, grade or 0, false
        end
    elseif Config.Framework == "qb" then
        local data = QBCore and QBCore.Functions and QBCore.Functions.GetPlayerData and QBCore.Functions.GetPlayerData() or nil
        if data and data.job and data.job.name then
            local grade = 0
            if type(data.job.grade) == "table" then
                grade = tonumber(data.job.grade.level) or 0
            else
                grade = tonumber(data.job.grade) or 0
            end
            return data.job.name, grade, false
        end
    end
    return nil, 0, false
end

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
