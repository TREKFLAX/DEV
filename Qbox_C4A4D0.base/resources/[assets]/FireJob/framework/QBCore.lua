QBCoreFramework = setmetatable({}, {__index = FrameworkBase})
QBCoreFramework.__index = QBCoreFramework

function QBCoreFramework.new()
    local self = setmetatable(FrameworkBase.new(), QBCoreFramework)
    self.name = "QBCore"
    self.core = nil
    return self
end

function QBCoreFramework:init()
    self.core = exports['qb-core']:GetCoreObject()
    local data = self.core.Functions.GetPlayerData()
    if data and data.job then
        self.jobName = data.job.name
        self.onDuty = data.job.onduty
    end
    print(("[FireJob] Framework loaded as: %s"):format(self.name))
    self:syncPermissions()
end

function QBCoreFramework:hasFireJob()
    if self:passesAceCheck() then return true end
    if not Config.JobCheck.EnablePermissions then return true end
    if not Config.JobCheck.QBCore.Enabled then return true end
    
    if Config.JobCheck.QBCore.CheckJob.Enabled then
        for _, validJob in pairs(Config.JobCheck.QBCore.CheckJob.Jobs) do
            if self.jobName == validJob then return true end
        end
    end
    return false
end

function QBCoreFramework:isFireFighter()
    if Config.JobCheck.RequireOnDuty == false then return self:hasFireJob() end
    return self:hasFireJob() and self.onDuty
end

function QBCoreFramework:toggleDuty()
    TriggerServerEvent("QBCore:ToggleDuty")
end

function QBCoreFramework:registerListeners(onUpdateCallback)
    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
        self:init()
        self:syncPermissions()
        onUpdateCallback()
    end)
    RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
        self.jobName = JobInfo.name
        self.onDuty = JobInfo.onduty
        onUpdateCallback()
    end)
    RegisterNetEvent('QBCore:Client:SetDuty', function(duty)
        self.onDuty = duty
        onUpdateCallback()
        TriggerEvent('firejob:cl:dutyChanged', self.onDuty, "Station")
    end)
end