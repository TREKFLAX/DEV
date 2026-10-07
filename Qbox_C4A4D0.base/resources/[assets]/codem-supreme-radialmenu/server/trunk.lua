local trunkBusy = {}

local function IsCloseToTarget(source, target)
    if not DoesPlayerExist(target) then return false end

    local sourceCoords = GetEntityCoords(GetPlayerPed(source))
    local targetCoords = GetEntityCoords(GetPlayerPed(target))

    return #(sourceCoords - targetCoords) < 2.0
end

RegisterNetEvent('codem-radialmenu:trunk:server:Door', function(open, plate, door)
    TriggerClientEvent('codem-radialmenu:trunk:client:Door', -1, plate, door, open)
end)

RegisterNetEvent('codem-trunk:server:setTrunkBusy', function(plate, busy)
    trunkBusy[plate] = busy
end)

RegisterNetEvent('codem-trunk:server:KidnapTrunk', function(targetId, closestVehicle)
    local src = source

    if not IsCloseToTarget(src, targetId) then
        Framework:Notify(src, _L('game.notify.too_far_target'), 'error')
        return
    end

    TriggerClientEvent('codem-trunk:client:KidnapGetIn', targetId, closestVehicle)
end)

if Framework.Type == 'qbx' then
    lib.callback.register('codem-trunk:server:getTrunkBusy', function(source, plate)
        return trunkBusy[plate] or false
    end)
elseif Framework.Type == 'qbcore' then
    Framework.Object.Functions.CreateCallback('codem-trunk:server:getTrunkBusy', function(source, cb, plate)
        cb(trunkBusy[plate] or false)
    end)
else
    RegisterNetEvent('codem-trunk:server:getTrunkBusy', function(plate)
        local src = source
        TriggerClientEvent('codem-trunk:client:trunkBusyResult', src, false)
    end)
end

RegisterCommand('getintrunk', function(source)
    TriggerClientEvent('codem-trunk:client:GetIn', source)
end, false)

RegisterCommand('putintrunk', function(source)
    TriggerClientEvent('codem-trunk:client:InitKidnapTrunk', source)
end, false)
