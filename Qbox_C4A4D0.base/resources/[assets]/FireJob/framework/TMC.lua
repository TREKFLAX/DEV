TMCFramework = setmetatable({}, { __index = FrameworkBase })
TMCFramework.__index = TMCFramework

function TMCFramework.new()
    local self = setmetatable(FrameworkBase.new(), TMCFramework)
    self.name = "TMC"
    self.core = nil
    return self
end

function TMCFramework:refreshDutyState()
    if not self.core then return end

    self.onDuty = false
    self.jobName = nil

    local checkJob = Config.JobCheck.TMC and Config.JobCheck.TMC.CheckJob
    if not checkJob or not checkJob.Enabled then
        return
    end

    for _, validJob in pairs(checkJob.Jobs or {}) do
        local onDuty = self.core.Functions.IsOnDuty(validJob)
        if onDuty and onDuty ~= false then
            self.onDuty = true
            self.jobName = type(onDuty) == 'string' and onDuty or validJob
            return
        end
    end
end

function TMCFramework:init()
    self.core = exports.core:getCoreObject()
    self:refreshDutyState()
    print(("[FireJob] Framework loaded as: %s"):format(self.name))
    self:syncPermissions()
end

function TMCFramework:playerHasConfiguredJob()
    if not self.core then return false end

    local checkJob = Config.JobCheck.TMC and Config.JobCheck.TMC.CheckJob
    if not checkJob or not checkJob.Enabled then
        return true
    end

    local data = self.core.Functions.GetPlayerData()
    if not data then return false end

    if data.jobs then
        for _, job in pairs(data.jobs) do
            for _, validJob in pairs(checkJob.Jobs or {}) do
                if job.name == validJob then
                    return true
                end
            end
        end
    end

    if data.job and data.job.name then
        for _, validJob in pairs(checkJob.Jobs or {}) do
            if data.job.name == validJob then
                return true
            end
        end
    end

    return false
end

function TMCFramework:hasFireJob()
    if self:passesAceCheck() then return true end
    if not Config.JobCheck.EnablePermissions then return true end
    if not Config.JobCheck.TMC or not Config.JobCheck.TMC.Enabled then return true end

    if Config.JobCheck.TMC.CheckPermission and Config.JobCheck.TMC.CheckPermission.Enabled then
        for _, perm in ipairs(Config.JobCheck.TMC.CheckPermission.Permissions or {}) do
            if self.core.Functions.HasPermission(perm) then
                return true
            end
        end
    end

    return self:playerHasConfiguredJob()
end

function TMCFramework:isFireFighter()
    if not self:hasFireJob() then
        return false
    end

    if Config.JobCheck.RequireOnDuty == false then return true end

    self:refreshDutyState()
    return self.onDuty
end

function TMCFramework:toggleDuty()
    -- TMC maintains QBCore-compatible duty events on many builds
    TriggerServerEvent('QBCore:ToggleDuty')
    SetTimeout(250, function()
        self:refreshDutyState()
        TriggerEvent('firejob:cl:dutyChanged', self.onDuty, "Station")
    end)
end

function TMCFramework:registerListeners(onUpdateCallback)
    local function handleDutyChange()
        self:refreshDutyState()
        onUpdateCallback()
        TriggerEvent('firejob:cl:dutyChanged', self.onDuty, "Station")
    end

    RegisterNetEvent('TMC:Client:OnPlayerLoaded', function()
        self:init()
        onUpdateCallback()
    end)

    RegisterNetEvent('TMC:Client:OnJobUpdate', function()
        self:refreshDutyState()
        onUpdateCallback()
    end)

    RegisterNetEvent('TMC:Client:SetDuty', function()
        handleDutyChange()
    end)

    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
        self:init()
        onUpdateCallback()
    end)

    RegisterNetEvent('QBCore:Client:OnJobUpdate', function()
        self:refreshDutyState()
        onUpdateCallback()
    end)

    RegisterNetEvent('QBCore:Client:SetDuty', function(duty)
        if duty ~= nil then
            self.onDuty = duty
        else
            self:refreshDutyState()
        end
        onUpdateCallback()
        TriggerEvent('firejob:cl:dutyChanged', self.onDuty, "Station")
    end)
end
