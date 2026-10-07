local function resolveFw()
    if Config.Framework and Config.Framework ~= "auto" then
        return Config.Framework
    end
    if detectFramework then
        return detectFramework()
    end
    return "standalone"
end

function GetPlayer(src)
    if not src or src == 0 then return nil end
    src = tonumber(src)
    if not src then return nil end

    local fw = resolveFw()
    if fw == "esx" then
        if ESX and ESX.GetPlayerFromId then
            return ESX.GetPlayerFromId(src)
        elseif exports["es_extended"] and exports["es_extended"].getSharedObject then
            local esx = exports["es_extended"]:getSharedObject()
            return esx and esx.GetPlayerFromId and esx.GetPlayerFromId(src)
        end
    elseif fw == "qb" then
        if GetResourceState("qbx_core") == "started" then
            return exports.qbx_core:GetPlayer(src)
        elseif QBCore and QBCore.Functions and QBCore.Functions.GetPlayer then
            return QBCore.Functions.GetPlayer(src)
        elseif exports["qb-core"] and exports["qb-core"].GetCoreObject then
            local qb = exports["qb-core"]:GetCoreObject()
            if qb and qb.Functions then
                QBCore = qb
                return qb.Functions.GetPlayer(src)
            end
        end
    end
    return nil
end

function GetIdentifierBySource(source)
    local xPlayer = GetPlayer(source)
    if not xPlayer then return nil end
    return GetIdentifier(xPlayer)
end

function GetIdentifier(xPlayer)
    if not xPlayer then return nil end
    local fw = resolveFw()
    if fw == "esx" then
        return xPlayer.identifier
    elseif fw == "qb" then
        return xPlayer.PlayerData and xPlayer.PlayerData.citizenid
    end
    return nil
end

function GetPlayerName(xPlayer)
    if not xPlayer then return "Unknown" end
    if type(xPlayer) == "number" or type(xPlayer) == "string" then
        xPlayer = GetPlayer(tonumber(xPlayer))
        if not xPlayer then return "Unknown" end
    end
    local fw = resolveFw()
    if fw == "esx" then
        if xPlayer.getName then return xPlayer.getName() end
        return "Unknown"
    elseif fw == "qb" then
        local charinfo = xPlayer.PlayerData and xPlayer.PlayerData.charinfo
        if charinfo then
            return (charinfo.firstname or "") .. " " .. (charinfo.lastname or "")
        end
    end
    return "Unknown"
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

function GetPlayerMoney(xPlayer, paymentMethod)
    paymentMethod = paymentMethod or "cash"
    local fw = resolveFw()
    if fw == "esx" then
        if paymentMethod == "bank" or paymentMethod == "card" then
            local account = xPlayer.getAccount("bank")
            return account and account.money or 0
        else
            return xPlayer.getMoney()
        end
    elseif fw == "qb" then
        local account = (paymentMethod == "bank" or paymentMethod == "card") and "bank" or "cash"
        return xPlayer.PlayerData and xPlayer.PlayerData.money and xPlayer.PlayerData.money[account] or 0
    end
    return 0
end

function RemovePlayerMoney(xPlayer, amount, paymentMethod)
    paymentMethod = paymentMethod or "cash"
    local fw = resolveFw()
    if fw == "esx" then
        if paymentMethod == "bank" or paymentMethod == "card" then
            xPlayer.removeAccountMoney("bank", amount)
        else
            xPlayer.removeMoney(amount)
        end
        return true
    elseif fw == "qb" then
        local account = (paymentMethod == "bank" or paymentMethod == "card") and "bank" or "cash"
        if GetResourceState("qbx_core") == "started" then
            return exports.qbx_core:RemoveMoney(xPlayer.PlayerData.source, account, amount)
        elseif xPlayer.Functions and xPlayer.Functions.RemoveMoney then
            xPlayer.Functions.RemoveMoney(account, amount)
            return true
        end
    end
    return false
end

function GetPlayerJob(xPlayer)
    if not xPlayer then return nil end
    local fw = resolveFw()
    if fw == "esx" then
        return xPlayer.job and xPlayer.job.name
    elseif fw == "qb" then
        return xPlayer.PlayerData and xPlayer.PlayerData.job and xPlayer.PlayerData.job.name
    end
    return nil
end

function SetPlayerJob(xPlayer, jobname, grade)
    if not xPlayer then return end
    grade = tonumber(grade) or 0
    local fw = resolveFw()
    if fw == "esx" then
        if xPlayer.setJob then
            xPlayer.setJob(jobname, grade)
        end
    elseif fw == "qb" then
        if xPlayer.Functions and xPlayer.Functions.SetJob then
            xPlayer.Functions.SetJob(jobname, grade)
        end
    end
end

function SetPlayerDuty(xPlayer, onDuty)
    if not xPlayer then return end
    local fw = resolveFw()
    if fw == "qb" then
        if GetResourceState("qbx_core") == "started" then
            exports.qbx_core:SetJobDuty(xPlayer.PlayerData.source, onDuty)
        elseif xPlayer.Functions and xPlayer.Functions.SetJobDuty then
            xPlayer.Functions.SetJobDuty(onDuty)
        end
    end
end

function GetPlayerJobGrade(xPlayer)
    if not xPlayer then return nil end
    local fw = resolveFw()
    if fw == "esx" then
        return xPlayer.job and xPlayer.job.grade
    elseif fw == "qb" then
        return xPlayer.PlayerData and xPlayer.PlayerData.job and xPlayer.PlayerData.job.grade and
            xPlayer.PlayerData.job.grade.level
    end
    return nil
end

function GetPlayerGang(xPlayer)
    if not xPlayer then return nil end
    local fw = resolveFw()
    if fw == "qb" then
        return xPlayer.PlayerData and xPlayer.PlayerData.gang and xPlayer.PlayerData.gang.name
    end
    return nil
end

function RegisterItem(itemName, cb)
    local fw = resolveFw()
    if fw == "qb" then
        if QBCore and QBCore.Functions and QBCore.Functions.CreateUseableItem then
            QBCore.Functions.CreateUseableItem(itemName, function(source, item)
                cb(source)
            end)
        elseif GetResourceState("qbx_core") == "started" then
            exports.qbx_core:CreateUseableItem(itemName, function(source, item)
                cb(source)
            end)
        end
    elseif fw == "esx" then
        if ESX and ESX.RegisterUsableItem then
            ESX.RegisterUsableItem(itemName, function(source)
                cb(source)
            end)
        end
    end
end

function IsAdmin(source)
    if not source or source == 0 then return false end
    if IsPlayerAceAllowed(source, "group.admin") or IsPlayerAceAllowed(source, "command") then
        return true
    end
    local fw = resolveFw()
    if fw == "esx" then
        local xPlayer = GetPlayer(source)
        if not xPlayer then return false end
        local group = xPlayer.getGroup()
        return group == "admin" or group == "superadmin"
    elseif fw == "qb" then
        if QBCore and QBCore.Functions and QBCore.Functions.HasPermission then
            return QBCore.Functions.HasPermission(source, "admin") or QBCore.Functions.HasPermission(source, "god")
        end
        return IsPlayerAceAllowed(source, "group.admin") or IsPlayerAceAllowed(source, "command")
    end
    return IsPlayerAceAllowed(source, "group.admin") or IsPlayerAceAllowed(source, "command")
end

function GetFrameworkJobs()
    local jobs = {}
    local fw = resolveFw()
    if fw == "esx" then
        local esxJobs = {}
        if ESX and ESX.GetJobs then
            esxJobs = ESX.GetJobs()
        elseif exports["es_extended"] and exports["es_extended"].getSharedObject then
            local esx = exports["es_extended"]:getSharedObject()
            if esx and esx.GetJobs then esxJobs = esx.GetJobs() end
        end
        for jobName, jobData in pairs(esxJobs) do
            local grades = {}
            for gradeVal, gradeData in pairs(jobData.grades or {}) do
                table.insert(grades, {
                    grade = tonumber(gradeVal) or 0,
                    label = gradeData.label or ("Grade " .. gradeVal),
                    name = gradeData.name or tostring(gradeVal)
                })
            end
            table.sort(grades, function(a, b) return a.grade < b.grade end)
            jobs[jobName] = {
                label = jobData.label or jobName,
                grades = grades
            }
        end
    elseif fw == "qb" then
        local qbJobs = {}
        if QBCore and QBCore.Shared and QBCore.Shared.Jobs then
            qbJobs = QBCore.Shared.Jobs
        elseif exports.qbx_core and exports.qbx_core.GetJobs then
            qbJobs = exports.qbx_core:GetJobs()
        elseif exports["qb-core"] and exports["qb-core"].GetCoreObject then
            local qb = exports["qb-core"]:GetCoreObject()
            if qb and qb.Shared and qb.Shared.Jobs then
                QBCore = qb
                qbJobs = qb.Shared.Jobs
            end
        end
        for jobName, jobData in pairs(qbJobs) do
            local grades = {}
            for gradeVal, gradeData in pairs(jobData.grades or {}) do
                table.insert(grades, {
                    grade = tonumber(gradeVal) or 0,
                    label = gradeData.label or gradeData.name or ("Grade " .. gradeVal),
                    name = gradeData.name or tostring(gradeVal)
                })
            end
            table.sort(grades, function(a, b) return a.grade < b.grade end)
            jobs[jobName] = {
                label = jobData.label or jobName,
                grades = grades
            }
        end
    end
    return jobs
end

function GetFrameworkJobGradeLabel(jobname, grade, src)
    grade = tonumber(grade) or 0

    if src then
        local xPlayer = GetPlayer(src)
        if xPlayer then
            local fw = resolveFw()
            if fw == 'esx' and xPlayer.job and xPlayer.job.name == jobname and tonumber(xPlayer.job.grade) == grade then
                if xPlayer.job.grade_label and xPlayer.job.grade_label ~= '' then
                    return xPlayer.job.grade_label
                end
            elseif fw == 'qb' and xPlayer.PlayerData and xPlayer.PlayerData.job and xPlayer.PlayerData.job.name == jobname and tonumber(xPlayer.PlayerData.job.grade.level) == grade then
                if xPlayer.PlayerData.job.grade.name and xPlayer.PlayerData.job.grade.name ~= '' then
                    return xPlayer.PlayerData.job.grade.name
                end
            end
        end
    end

    local jobs = GetFrameworkJobs()
    local jobData = jobs[jobname]
    if not jobData or not jobData.grades then return 'Grade ' .. grade end

    local grades = jobData.grades
    if type(grades) == 'table' then
        for k, gData in pairs(grades) do
            if type(gData) == 'table' then
                if tonumber(gData.grade) == grade or tostring(k) == tostring(grade) then
                    return gData.label or gData.name or ('Grade ' .. grade)
                end
            end
        end
    end

    return 'Grade ' .. grade
end

CreateThread(function()
    AddEventHandler("esx:playerLoaded", function(playerId, _xPlayer, isNew)
        debugPrint('[Framework] esx:playerLoaded ->', playerId)
        LoadOnlinePlayer(playerId)
    end)

    local function handleQbPlayer(player)
        local src = type(player) == "table" and (player.PlayerData and player.PlayerData.source or player.source) or
            tonumber(player) or source
        if src then
            debugPrint('[Framework] qb playerLoaded ->', src)
            LoadOnlinePlayer(src)
        end
    end
    AddEventHandler("QBCore:Server:PlayerLoaded", handleQbPlayer)
    AddEventHandler("QBCore:Server:OnPlayerLoaded", handleQbPlayer)
end)

local isReverting = {}

local function getRealJobCount(playerId, unemployedName)
    local jobs = exports['jc_multi_job']:GetJobs(playerId)
    local count = 0
    for i = 1, #jobs do
        if jobs[i].name ~= unemployedName then
            count = count + 1
        end
    end
    return count
end

AddEventHandler('esx:setJob', function(src, job, lastJob)
    local playerId = tonumber(src) or source
    if not playerId or not job or not job.name then return end
    if isReverting[playerId] then return end
    if lastJob and job.name == lastJob.name and job.grade == lastJob.grade then return end

    local unemployedName = (Config.UnemployedJob and Config.UnemployedJob.name) or 'unemployed'

    if job.name == unemployedName then
        if lastJob and lastJob.name and lastJob.name ~= unemployedName and
            exports['jc_multi_job']:HasJob(playerId, lastJob.name) then
            exports['jc_multi_job']:ResignJob(playerId, lastJob.name)
        end
        return
    end

    local maxSlots = exports['jc_multi_job']:GetMaxSlots(playerId)
    local realJobs = getRealJobCount(playerId, unemployedName)
    local hasNewJob = exports['jc_multi_job']:HasJob(playerId, job.name)

    if job.name ~= unemployedName and not hasNewJob and realJobs >= maxSlots then
        isReverting[playerId] = true
        local xPlayer = GetPlayer(playerId)
        if xPlayer and lastJob and lastJob.name then
            SetPlayerJob(xPlayer, lastJob.name, lastJob.grade or 0)
        end

        NotifyPlayer(playerId, Tr('job_slot_full'), "error")

        SetTimeout(1000, function()
            isReverting[playerId] = nil
        end)
    elseif job.name ~= unemployedName then
        if exports['jc_multi_job']:HasJob(playerId, unemployedName) then
            exports['jc_multi_job']:ResignJob(playerId, unemployedName)
        end
        exports['jc_multi_job']:AddJobToPlayer(playerId, job.name, tonumber(job.grade) or 0)
    end
end)

local function handleQbJobUpdate(src, newJob, oldJob)
    local playerId = tonumber(src) or source
    if not playerId or not newJob or not newJob.name then return end
    if isReverting[playerId] then return end

    local unemployedName = (Config.UnemployedJob and Config.UnemployedJob.name) or 'unemployed'
    local newGrade = (type(newJob.grade) == 'table' and newJob.grade.level) or tonumber(newJob.grade) or 0
    local activeJob = exports['jc_multi_job']:GetActiveJob(playerId)

    if newJob.name == unemployedName then
        if activeJob then
            exports['jc_multi_job']:ResignJob(playerId, activeJob.name)
        end
        return
    end

    if activeJob and activeJob.name == newJob.name and tonumber(activeJob.grade) == newGrade then
        return
    end

    local maxSlots = exports['jc_multi_job']:GetMaxSlots(playerId)
    local realJobs = getRealJobCount(playerId, unemployedName)
    local hasNewJob = exports['jc_multi_job']:HasJob(playerId, newJob.name)

    if newJob.name ~= unemployedName and not hasNewJob and realJobs >= maxSlots then
        isReverting[playerId] = true

        local fallbackJob = (oldJob and oldJob.name) or (activeJob and activeJob.name) or unemployedName
        local fallbackGrade = (oldJob and (type(oldJob.grade) == 'table' and oldJob.grade.level or oldJob.grade)) or
            (activeJob and activeJob.grade) or 0

        local xPlayer = GetPlayer(playerId)
        if xPlayer then
            SetPlayerJob(xPlayer, fallbackJob, fallbackGrade)
        end

        NotifyPlayer(playerId, Tr('job_slot_full'), "error")

        SetTimeout(1000, function()
            isReverting[playerId] = nil
        end)
    elseif newJob.name ~= unemployedName then
        if exports['jc_multi_job']:HasJob(playerId, unemployedName) then
            exports['jc_multi_job']:ResignJob(playerId, unemployedName)
        end
        exports['jc_multi_job']:AddJobToPlayer(playerId, newJob.name, newGrade)
    end
end

-- Qbox / QBX Core
AddEventHandler('QBCore:Server:OnJobUpdate', handleQbJobUpdate)

-- QBCore standard
AddEventHandler('QBCore:Server:OnPlayerUpdated', function(src, key, val)
    if key == 'job' and type(val) == 'table' then
        handleQbJobUpdate(src, val)
    end
end)
