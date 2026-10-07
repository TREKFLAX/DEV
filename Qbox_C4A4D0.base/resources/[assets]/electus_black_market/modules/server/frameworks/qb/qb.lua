if Config.Framework ~= "qbcore" then
    return
end

debugprint("Loading QBCore")

QB = exports["qb-core"]:GetCoreObject()

---@param source number
function GetQBPlayer(source)
    return QB.Functions.GetPlayer(tonumber(source))
end

---@param source number
---@return string?
function GetIdentifier(source)
    local qPlayer = GetQBPlayer(source)

    if not qPlayer?.PlayerData?.citizenid then
        debugprint("GetIdentifier: Failed to get player for source:", source)
        return
    end

    return qPlayer.PlayerData.citizenid
end

---@param identifier string
---@return number?
function GetSourceFromIdentifier(identifier)
    local qPlayer = QB.Functions.GetPlayerByCitizenId(identifier)

    if qPlayer?.PlayerData?.source then
        return qPlayer.PlayerData.source
    end
end

---@param source number
---@return string firstname
---@return string lastname
function GetCharacterName(source)
    local qPlayer = QB.Functions.GetPlayer(tonumber(source))

    if not qPlayer then
        return GetPlayerName(source), ""
    end

    local characterInfo = qPlayer.PlayerData.charinfo

    return characterInfo.firstname, characterInfo.lastname
end

---@param identifier string
---@return string? firstname
---@return string? lastname
function GetCharacterNameFromIdentifier(identifier)
    local characterInfo = QB.Functions.GetPlayerByCitizenId(identifier)?.PlayerData?.charinfo

    if not characterInfo then
        characterInfo = MySQL.scalar.await("SELECT charinfo FROM players WHERE citizenid = ?", { identifier })

        if characterInfo then
            characterInfo = json.decode(characterInfo)
        else
            return
        end
    end

    return characterInfo.firstname, characterInfo.lastname
end
