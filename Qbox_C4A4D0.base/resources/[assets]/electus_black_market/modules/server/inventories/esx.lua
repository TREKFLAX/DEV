if Config.Inventory ~= "esx" then
	return
end

---@param options LoafWrapperStashOptions
function RegisterStash(options)

end

---@param source number
---@param item string
---@return number count
function GetItemCount(source, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	return xPlayer.getInventoryItem(item)?.count or 0
end

---@param source number
---@param item string
---@param count? number
---@param metadata? table
---@return boolean success
function AddItem(source, item, count, metadata)
	local xPlayer = ESX.GetPlayerFromId(source)
	return xPlayer.addInventoryItem(item, count, metadata)
end

---@param source number
---@param item string
---@param count? number
---@return boolean success
function RemoveItem(source, item, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	return xPlayer.removeInventoryItem(item, count)
end

---@param source number
---@param item string
---@param slot number
---@param metadata table
---@return boolean success
function SetItemMetadata(source, item, slot, metadata)
	return false
end

---@param source number
---@param item string
---@param slot? number
---@return table? metadata
function GetMetaData(source, item, slot)
	return nil
end

---@param source number
---@param item string
---@return number? slot
function GetItemSlot(source, item)
	return nil
end
