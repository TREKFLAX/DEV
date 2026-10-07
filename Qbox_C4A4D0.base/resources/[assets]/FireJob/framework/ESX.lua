ESXFramework = setmetatable({}, {__index = FrameworkBase})
ESXFramework.__index = ESXFramework

function ESXFramework.new()
    local self = setmetatable(FrameworkBase.new(), ESXFramework)
    self.name = "ESX"
    self.core = nil
    return self
end

function ESXFramework:init()
    self.core = exports['es_extended']:getSharedObject()
    local playerData = self.core.GetPlayerData()

    if playerData and playerData.job then
        self.jobName = playerData.job.name
        self.onDuty = true
    end
    print(("[FireJob] Framework loaded as: %s"):format(self.name))
    self:syncPermissions()
end

function ESXFramework:hasFireJob()
    if self:passesAceCheck() then return true end
    if not Config.JobCheck.EnablePermissions then return true end
    if not Config.JobCheck.ESX.Enabled then return true end
    
    if Config.JobCheck.ESX.CheckJob.Enabled then
        for _, validJob in pairs(Config.JobCheck.ESX.CheckJob.Jobs) do
            if self.jobName == validJob then return true end
        end
    end
    return false
end

function ESXFramework:isFireFighter()
    if Config.JobCheck.RequireOnDuty == false then return self:hasFireJob() end
    return self:hasFireJob() and self.onDuty
end

function ESXFramework:toggleDuty()
    self.onDuty = not self.onDuty
    TriggerEvent('firejob:cl:dutyChanged', self.onDuty, "Station")
end

function ESXFramework:registerListeners(onUpdateCallback)
    RegisterNetEvent('esx:playerLoaded', function(xPlayer)
        if xPlayer and xPlayer.job then self.jobName = xPlayer.job.name end
        onUpdateCallback()
    end)
    RegisterNetEvent('esx:setJob', function(job)
        if job then 
            self.jobName = job.name 
            self.onDuty = false 
        end
        onUpdateCallback()
    end)
end