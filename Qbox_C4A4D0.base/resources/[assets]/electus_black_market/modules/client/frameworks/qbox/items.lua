if Config.Framework ~= "qbox" then
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

	infoprint("warning", "Unsupported inventory.")

	return 0
end
