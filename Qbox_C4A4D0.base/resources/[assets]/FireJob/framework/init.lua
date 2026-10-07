ActiveFramework = nil

RegisterNetEvent('firejob:client:acePermission', function(hasPermission)
    if ActiveFramework then
        ActiveFramework.aceFirePermission = hasPermission == true
    end
end)

local SUPPORTED_FRAMEWORKS = {
    { resource = 'core',        new = function() return TMCFramework.new() end },
    { resource = 'qb-core',     new = function() return QBCoreFramework.new() end },
    { resource = 'es_extended', new = function() return ESXFramework.new() end },
    { resource = 'qbx_core',    new = function() return QBXFramework.new() end },
}


local DETECT_INTERVAL_MS  = 250
local DETECT_MAX_ATTEMPTS = 120
local function isInstalled(state)
    return state ~= nil and state ~= 'missing' and state ~= 'unknown'
end

local function detectStartedFramework()
    for _, fw in ipairs(SUPPORTED_FRAMEWORKS) do
        if GetResourceState(fw.resource) == 'started' then
            return fw.new()
        end
    end
    return nil
end

local function anyFrameworkInstalled()
    for _, fw in ipairs(SUPPORTED_FRAMEWORKS) do
        if isInstalled(GetResourceState(fw.resource)) then
            return true
        end
    end
    return false
end

CreateThread(function()
    local framework = detectStartedFramework()
    if not framework and anyFrameworkInstalled() then
        local attempts = 0
        while not framework and attempts < DETECT_MAX_ATTEMPTS do
            Wait(DETECT_INTERVAL_MS)
            framework = detectStartedFramework()
            attempts = attempts + 1
        end

        if not framework then
            print('^3[FireJob] A supported framework is installed but never reached the "started" state; falling back to Standalone. Check your resource start order.^0')
        end
    end

    ActiveFramework = framework or FrameworkBase.new()
    ActiveFramework:init()
    ActiveFramework:registerListeners(function()
        ApplyPendingDutyState()
    end)
end)
