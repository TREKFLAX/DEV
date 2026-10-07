if Config.Framework ~= "custom" then
    return
end

---@param source number
---@return string?
function GetIdentifier(source)
    ---@diagnostic disable-next-line: param-type-mismatch
    return GetPlayerIdentifierByType(source, "license")
end

---@param identifier string
---@return number?
function GetSourceFromIdentifier(identifier)
    local players = GetPlayers()

    for i = 1, #players do
        if GetPlayerIdentifierByType(players[i], "license") == identifier then
            ---@diagnostic disable-next-line: return-type-mismatch
            return players[i]
        end
    end
end

---@param source number
---@return string firstname
---@return string lastname
function GetCharacterName(source)
    return GetPlayerName(source), tostring(source)
end

---@param identifier string
---@return string? firstname
---@return string? lastname
function GetCharacterNameFromIdentifier(identifier)
    local source = GetSourceFromIdentifier(identifier)

    if not source then
        return
    end

    return GetCharacterName(source)
end
