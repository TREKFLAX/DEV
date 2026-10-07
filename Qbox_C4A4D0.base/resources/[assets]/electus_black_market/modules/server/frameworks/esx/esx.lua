if Config.Framework ~= "esx" then
	return
end

ESX = exports.es_extended:getSharedObject()

---@param source number
---@return string?
function GetIdentifier(source)
	return ESX.GetPlayerFromId(source)?.identifier
end

---@param identifier string
---@return number?
function GetSourceFromIdentifier(identifier)
	local xPlayer = ESX.GetPlayerFromIdentifier(identifier)

	if xPlayer then
		return xPlayer.source
	end
end

---@param source number
---@return string firstname
---@return string lastname
function GetCharacterName(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local firstName = xPlayer.get and xPlayer.get("firstName")
    local lastName = xPlayer.get and xPlayer.get("lastName")

    if not firstName or not lastName then
        local row = MySQL.single.await("SELECT firstname, lastname FROM users WHERE identifier=?", { GetIdentifier(source) })

        firstName = row?.firstname or GetPlayerName(source)
        lastName = row?.lastname or ""
    end

    return firstName, lastName
end

---@param identifier string
---@return string? firstname
---@return string? lastname
function GetCharacterNameFromIdentifier(identifier)
    local source = GetSourceFromIdentifier(identifier)

	if source then
		return GetCharacterName(source)
	end

    local name = MySQL.single.await("SELECT firstname, lastname FROM users WHERE identifier = ?", { identifier })

	if not name then
		return
	end

	return name.firstname, name.lastname
end
