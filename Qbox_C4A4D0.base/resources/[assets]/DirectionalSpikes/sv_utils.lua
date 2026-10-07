function UserHasPermission(source, location)

    if not location.EnablePermissions then
        return true
    end

    if location.AcePermissions.Enabled then
        for k, v in pairs(location.AcePermissions.Permissions) do
            if IsPlayerAceAllowed(source, v) then
                return true
            end
        end
    end

    -- ESX Permissions
    if location.ESX.Enabled then
        local xPlayer = ESX.GetPlayerFromId(source)
        if location.ESX.CheckJob.Enabled then
            for k, v in pairs(location.ESX.CheckJob.Jobs) do
                if xPlayer.job.name == v then
                    return true
                end
            end
        end
    end

    -- vRP Permission
    if location.vRP.Enabled then
        if location.vRP.CheckPermission.Enabled then
            for k, v in pairs(location.vRP.CheckPermission.Permissions) do
                if vRP.hasPermission({vRP.getUserId({source}),v}) then
                    return true
                end
            end
        end

        if location.vRP.CheckGroup.Enabled then
            for k, v in pairs(location.vRP.CheckGroup.Groups) do
                if vRP.hasGroup({vRP.getUserId({source}),v}) then
                    return true
                end
            end
        end
    end

    -- QBCore Permission
    if location.QBCore.Enabled then
        local player = QBCore.Functions.GetPlayer(source)
        if location.QBCore.CheckJob.Enabled then
            for k, v in pairs(location.QBCore.CheckJob.Jobs) do
                if player.PlayerData.job.name == v then
                    return true
                end
            end
        end
        if location.QBCore.CheckPermission.Enabled then
            for k, v in pairs(location.QBCore.CheckPermission.Permissions) do
                if QBCore.Functions.HasPermission(source, v) then
                    return true
                end
            end
        end
    end

    if location.QBX.Enabled then
        local player = exports.qbx_core:GetPlayer(source)
        if location.QBX.CheckJob.Enabled then
            for k, v in pairs(location.QBX.CheckJob.Jobs) do
                if player.PlayerData.job.name == v then
                    return true
                end
            end
        end
    end

    return false
end