RegisterNetEvent('codem-supreme-radialmenu:server:RemoveStretcher', function(pos, stretcherObject)
    TriggerClientEvent('codem-supreme-radialmenu:client:RemoveStretcherFromArea', -1, pos, stretcherObject)
end)

RegisterNetEvent('codem-supreme-radialmenu:Stretcher:BusyCheck', function(id, type)
    TriggerClientEvent('codem-supreme-radialmenu:Stretcher:client:BusyCheck', id, source, type)
end)

RegisterNetEvent('codem-supreme-radialmenu:server:BusyResult', function(isBusy, otherId, type)
    TriggerClientEvent('codem-supreme-radialmenu:client:Result', otherId, isBusy, type)
end)
