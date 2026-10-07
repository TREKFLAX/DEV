local function hasFrameworkGroup(src)
	if Config.Framework == "qbcore" or Config.Framework == "qbox" then
		if not QB or not QB.Functions or not QB.Functions.HasPermission then
			return false
		end

		for i = 1, #Config.Admin.Groups do
			local group = Config.Admin.Groups[i]

			if QB.Functions.HasPermission(src, group) then
				return true
			end
		end

		return false
	end

	if Config.Framework == "esx" then
		local player = ESX and ESX.GetPlayerFromId and ESX.GetPlayerFromId(src)
		local group = player and player.getGroup and player.getGroup() or nil

		for i = 1, #Config.Admin.Groups do
			local allowed = Config.Admin.Groups[i]

			if group == allowed then
				return true
			end
		end
	end

	return false
end

function IsAdmin(src)
	if src == 0 then
		return true
	end

	if Config.Admin.Ace and IsPlayerAceAllowed(src, Config.Admin.Ace) then
		return true
	end

	if IsPlayerAceAllowed(src, "command") then
		return true
	end

	if hasFrameworkGroup(src) then
		return true
	end

	return false
end
