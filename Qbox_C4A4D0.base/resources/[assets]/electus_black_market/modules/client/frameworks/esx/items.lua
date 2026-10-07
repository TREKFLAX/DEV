if Config.Framework ~= "esx" then
	return
end

---@param itemName string
---@return number
function GetItemCount(itemName)
	if GetResourceState("ox_inventory") == "started" then
		return exports.ox_inventory:Search("count", itemName) or 0
	elseif GetResourceState("qs-inventory") == "started" then
		return exports["qs-inventory"]:Search(itemName) or 0
	end

	if ESX.SearchInventory then
		return ESX.SearchInventory(itemName, 1) or 0
	end

	local inventory = ESX.PlayerData?.inventory

	if not inventory then
		infoprint("warning", "Unsupported inventory, tell the inventory author to add support for it.")
		return 0
	end

	debugprint("inventory", inventory)

	for i = 1, #inventory do
		local item = inventory[i]

		if item.name == itemName and item.count > 0 then
			return item.count
		end
	end

	return 0
end
