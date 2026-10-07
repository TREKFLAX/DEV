if Config.Framework ~= "qbcore" then
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

	local count = 0
	local items = PlayerData?.items or {}

	for slot, item in pairs(items) do
		if item.name == itemName then
			count += item.amount
		end
	end

	return count
end
