FrameworkBase = {}
FrameworkBase.__index = FrameworkBase

function FrameworkBase.new()
    local self = setmetatable({}, FrameworkBase)
    self.name = "Standalone"
    self.jobName = "unemployed"
    self.onDuty = false
    self.employed = false
    self.aceFirePermission = false
    return self
end

function FrameworkBase:passesAceCheck()
    local ace = Config.JobCheck and Config.JobCheck.AcePermissions
    return ace and ace.Enabled and self.aceFirePermission == true
end

function FrameworkBase:syncPermissions()
    TriggerServerEvent('firejob:standalone:checkJob')
    TriggerServerEvent('firejob:server:syncAcePermission')
end

function FrameworkBase:init()
    print(("[FireJob] Framework loaded as: %s"):format(self.name))
    self:syncPermissions()
end

function FrameworkBase:isFireFighter()
    if Config.JobCheck.RequireOnDuty == false then return self.employed end
    return self.employed and self.onDuty
end

function FrameworkBase:hasFireJob()
    if self:passesAceCheck() then return true end
    return self.employed
end

function FrameworkBase:toggleDuty()
    if not self.employed then return end
    self.onDuty = not self.onDuty
    TriggerEvent('firejob:cl:dutyChanged', self.onDuty, "Station")
end

function FrameworkBase:registerListeners(onUpdateCallback)
    RegisterNetEvent('firejob:standalone:updateJob', function(hasJob)
        self.employed = hasJob
        
        if not hasJob and self.onDuty then
            self.onDuty = false
            TriggerEvent('firejob:cl:dutyChanged', false, "Station")
        end
        
        onUpdateCallback()
    end)
end