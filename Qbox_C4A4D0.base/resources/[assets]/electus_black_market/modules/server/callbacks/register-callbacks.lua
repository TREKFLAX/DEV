---@class LoafWrapperCallbackOptions
---@field preventSpam? boolean # Prevents the same callback from being called by the same source until the previous one has finished
---@field rateLimit? number # How many times this callback can be called per source per minute
---@field defaultReturn? any # Default return value if the callback is not called or fails

local resourceName = GetCurrentResourceName()

---@type { [string]: EventHandler }
local registeredCallbacks = {}

---<b>Key:</b> Player source<br><b>Value:</b> Lookup table of callback names and how many times they have been called in the last minute
---@type { [number]: { [string]: number } }
local callbackRateLimits = {}

---<b>Key:</b> Source<br><b>Value:</b> Lookup table of callbacks that have been triggered but not yet finished
---@type { [number]: { [string]: boolean } }
local triggeredCallbacks = {}

---@param source number
---@param callbackName string
---@param options LoafWrapperCallbackOptions
---@return boolean
local function CanPlayerTriggerCallback(source, callbackName, options)
    if not options then
        return true
    end

    if options.preventSpam then
        if not triggeredCallbacks[source] then
            triggeredCallbacks[source] = {}
        end

        if triggeredCallbacks[source][callbackName] then
            debugprint(("callback '%s' is already being processed for player %s"):format(callbackName, source))
            return false
        end
    end

    if options.rateLimit then
        if not callbackRateLimits[source] then
            callbackRateLimits[source] = {}
        end

        local callsPastMinute = math.max(callbackRateLimits[source][callbackName] or 0, 0)

        if callsPastMinute >= options.rateLimit then
            debugprint(("callback '%s' has reached rate limit for player %s"):format( callbackName, source))
            return false
        end

        callbackRateLimits[source][callbackName] = callsPastMinute + 1

        SetTimeout(60000, function()
            if not callbackRateLimits[source] or not callbackRateLimits[source][callbackName] or callbackRateLimits[source][callbackName] <= 0 then
                return
            end

            callbackRateLimits[source][callbackName] = callbackRateLimits[source][callbackName] - 1
        end)
    end

    if options.preventSpam then
        triggeredCallbacks[source][callbackName] = true
    end

    return true
end

---@param event string
---@param handler fun(source: number, ...) : ...
---@param options? LoafWrapperCallbackOptions
function RegisterServerCallback(event, handler, options)
    assert(registeredCallbacks[event] == nil, ("event '%s' is already registered"):format(event))

    registeredCallbacks[event] = RegisterNetEvent(resourceName .. ":cb:" .. event, function(requestId, ...)
        local src = source

        if options and not CanPlayerTriggerCallback(src, event, options) then
            TriggerClientEvent(resourceName .. ":cb:response", src, requestId, options.defaultReturn)
            return
        end

        local params = { ... }
        local startTime = os.nanotime()

        local success, errorMessage = pcall(function()
            local payload = msgpack.pack_args(requestId, handler(src, table.unpack(params)))
            local length = #payload

            if length > 64000 then
                debugprint("Using latent event for callback '" .. event .. "' due to payload size: " .. length)
                TriggerLatentClientEventInternal(resourceName .. ":cb:response", src, payload, length, 10^6)
            else
                TriggerClientEventInternal(resourceName .. ":cb:response", src, payload, length)
            end

            local finishTime = os.nanotime()
            local ms = (finishTime - startTime) / 1e6

            debugprint(("Callback ^5%s^7 took %.4fms"):format(event, ms))
        end)

        if not success then
            local stackTrace = Citizen.InvokeNative(`FORMAT_STACK_TRACE` & 0xFFFFFFFF, nil, 0, Citizen.ResultAsString())

            print(("^1SCRIPT ERROR: Callback '%s' failed: %s^7\n%s"):format(event, errorMessage or "", stackTrace or ""))
            TriggerClientEvent(resourceName .. ":cb:response", src, requestId, options and options.defaultReturn or nil)
        end

        if options and options.preventSpam and triggeredCallbacks[src] then
            triggeredCallbacks[src][event] = nil
        end
    end)
end

AddEventHandler("playerDropped", function()
    local src = source

    triggeredCallbacks[src] = nil
    callbackRateLimits[src] = nil
end)
