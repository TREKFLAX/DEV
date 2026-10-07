local resourceName = GetCurrentResourceName()

local CALLBACK_TIMEOUT <const> = 120

---@type { [number]: { cb: fun(...), event: string } }
local waitingCallbacks = {}

---@param event string
---@param cb fun(...)
---@param ... ...
function TriggerServerCallback(event, cb, ...)
    local requestId = GenerateUniqueKey(waitingCallbacks)

    if not cb then
        debugprint(("Callback '%s' was triggered without a callback function^7"):format(event))
        cb = function() end
    end

    waitingCallbacks[requestId] = { cb = cb, event = event }

    SetTimeout(CALLBACK_TIMEOUT * 1000, function()
        if waitingCallbacks[requestId] then
            infoprint("error", ("Callback ^1%s^7 timed out after %is"):format(event, CALLBACK_TIMEOUT))

            waitingCallbacks[requestId].cb(nil)
            waitingCallbacks[requestId] = nil
        end
    end)

    local payload = msgpack.pack_args(requestId, ...)
    local length = #payload

    if length > 64000 then
        debugprint("Using latent event for callback '" .. event .. "' due to payload size: " .. length)
        TriggerLatentServerEventInternal(resourceName .. ":cb:" .. event, payload, length, 10^6)
    else
        TriggerServerEventInternal(resourceName .. ":cb:" .. event, payload, length)
    end
end

---@param event string
---@param ... ...
---@return ...
function AwaitServerCallback(event, ...)
    local responsePromise = promise.new()

    TriggerServerCallback(event, function(...)
        responsePromise:resolve({ ... })
    end, ...)

    local result = Citizen.Await(responsePromise)

    return table.unpack(result)
end

---@param requestId number
---@param ... ...
RegisterNetEvent(resourceName .. ":cb:response", function(requestId, ...)
    local callback = waitingCallbacks[requestId]

    if callback then
        local success, errorMessage = pcall(callback.cb, ...)

        if not success then
            local stackTrace = Citizen.InvokeNative(`FORMAT_STACK_TRACE` & 0xFFFFFFFF, nil, 0, Citizen.ResultAsString())

            print(("^1SCRIPT ERROR: Callback '%s' failed: %s^7\n%s"):format(callback.event, errorMessage or "", stackTrace or ""))
        end

        waitingCallbacks[requestId] = nil
    end
end)
