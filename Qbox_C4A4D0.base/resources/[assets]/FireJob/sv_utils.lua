--[[
    Server-side permission hooks for Fire Job.
    This file is not escrowed — edit it to match your server's permission setup.
]]

FireJob = FireJob or {}

local standaloneFirefighters = {}

--- Returns true when the player holds the configured ACE permission.
---@param src number
---@return boolean
function FireJob.HasAceFirePermission(src)
    local aceCfg = Config.JobCheck and Config.JobCheck.AcePermissions
    if not aceCfg or not aceCfg.Enabled then
        return false
    end

    local permission = aceCfg.Permission or "firejob.usescba"
    return IsPlayerAceAllowed(src, permission)
end

--- Returns true when the player is on the standalone /setfire allow list.
---@param src number
---@return boolean
function FireJob.IsStandaloneFirefighter(src)
    return standaloneFirefighters[src] == true
end

--- Hire or unhire a player on the standalone allow list.
---@param src number
---@param hired boolean
function FireJob.SetStandaloneFirefighter(src, hired)
    if hired then
        standaloneFirefighters[src] = true
    else
        standaloneFirefighters[src] = nil
    end
end

--- Server-side job check for the active framework. Used for standalone sync and
--- can be extended for server events that need validation.
---@param src number
---@return boolean
function FireJob.PlayerHasFireJob(src)
    if not Config.JobCheck or not Config.JobCheck.EnablePermissions then
        return true
    end

    if FireJob.HasAceFirePermission(src) then
        return true
    end

    if FireJob.IsStandaloneFirefighter(src) then
        return true
    end

    if GetResourceState('qb-core') == 'started' then
        local cfg = Config.JobCheck.QBCore
        if not cfg or not cfg.Enabled then return true end

        local QBCore = exports['qb-core']:GetCoreObject()
        local player = QBCore.Functions.GetPlayer(src)
        if not player then return false end

        if cfg.CheckJob and cfg.CheckJob.Enabled then
            for _, job in ipairs(cfg.CheckJob.Jobs or {}) do
                if player.PlayerData.job.name == job then
                    return true
                end
            end
        end

        return false
    end

    if GetResourceState('qbx_core') == 'started' then
        local cfg = Config.JobCheck.QBX
        if not cfg or not cfg.Enabled then return true end

        local player = exports.qbx_core:GetPlayer(src)
        if not player then return false end

        if cfg.CheckJob and cfg.CheckJob.Enabled then
            for _, job in ipairs(cfg.CheckJob.Jobs or {}) do
                if player.PlayerData.job.name == job then
                    return true
                end
            end
        end

        return false
    end

    if GetResourceState('es_extended') == 'started' then
        local cfg = Config.JobCheck.ESX
        if not cfg or not cfg.Enabled then return true end

        local ESX = exports['es_extended']:getSharedObject()
        local xPlayer = ESX.GetPlayerFromId(src)
        if not xPlayer then return false end

        if cfg.CheckJob and cfg.CheckJob.Enabled then
            for _, job in ipairs(cfg.CheckJob.Jobs or {}) do
                if xPlayer.job.name == job then
                    return true
                end
            end
        end

        return false
    end

    if GetResourceState('core') == 'started' then
        local cfg = Config.JobCheck.TMC
        if not cfg or not cfg.Enabled then return true end

        local TMC = exports.core:getCoreObject()
        local player = TMC.Functions.GetPlayer(src)
        if not player then return false end

        if cfg.CheckPermission and cfg.CheckPermission.Enabled then
            for _, perm in ipairs(cfg.CheckPermission.Permissions or {}) do
                if TMC.Functions.HasPermission(src, perm) then
                    return true
                end
            end
        end

        if cfg.CheckJob and cfg.CheckJob.Enabled then
            for _, job in ipairs(cfg.CheckJob.Jobs or {}) do
                if player.Functions.HasJob(job) then
                    return true
                end
            end
        end

        return false
    end

    return FireJob.IsStandaloneFirefighter(src)
end

RegisterNetEvent('firejob:standalone:checkJob', function()
    local src = source
    TriggerClientEvent('firejob:standalone:updateJob', src, FireJob.PlayerHasFireJob(src))
end)

RegisterNetEvent('firejob:server:syncAcePermission', function()
    local src = source
    TriggerClientEvent('firejob:client:acePermission', src, FireJob.HasAceFirePermission(src))
end)

AddEventHandler('playerDropped', function()
    local src = source
    if standaloneFirefighters[src] then
        standaloneFirefighters[src] = nil
    end
end)
