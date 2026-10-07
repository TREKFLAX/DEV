QBXFramework = setmetatable({}, {__index = FrameworkBase})
QBXFramework.__index = QBXFramework

function QBXFramework.new()
    local self = setmetatable(FrameworkBase.new(), QBXFramework)
    self.name = "QBX"
    return self
end

function QBXFramework:init()
    local playerData = exports.qbx_core:GetPlayerData()
    if playerData and playerData.job then
        self.jobName = playerData.job.name
        self.onDuty = playerData.job.onduty
    end
    print(("[FireJob] Framework loaded as: %s"):format(self.name))
    self:syncPermissions()
end

function QBXFramework:hasFireJob()
    if self:passesAceCheck() then return true end
    if not Config.JobCheck.EnablePermissions then return true end
    if not Config.JobCheck.QBX.Enabled then return true end
    
    if Config.JobCheck.QBX.CheckJob.Enabled then
        for _, validJob in pairs(Config.JobCheck.QBX.CheckJob.Jobs) do
            if self.jobName == validJob then return true end
        end
    end
    return false
end

function QBXFramework:isFireFighter()
    if Config.JobCheck.RequireOnDuty == false then return self:hasFireJob() end
    return self:hasFireJob() and self.onDuty
end

function QBXFramework:toggleDuty()
    TriggerServerEvent("QBCore:ToggleDuty")
end

function QBXFramework:registerListeners(onUpdateCallback)
    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
        self:init()
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