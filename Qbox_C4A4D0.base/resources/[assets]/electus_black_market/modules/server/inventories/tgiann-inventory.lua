if Config.Inventory ~= "tgiann-inventory" then
	return
end

---@param options LoafWrapperStashOptions
function RegisterStash(options)

end

---@param source number
---@param item string
---@return number count
function GetItemCount(source, item)
	return exports["tgiann-inventory"]:GetItemCount(source, item)
end

---@param source number
---@param item string
---@param count? number
---@param metadata? table
---@return boolean success
function AddItem(source, item, count, metadata)
	return exports["tgiann-inventory"]:AddItem(source, item, count, nil, metadata)
end

---@param source number
---@param item string
---@param count? number
---@return boolean success
function RemoveItem(source, item, count)
	return exports["tgiann-inventory"]:RemoveItem(source, item, count)
end

---@param source number
---@param item string
---@param slot number
---@param metadata table
---@return boolean success
function SetItemMetadata(source, item, slot, metadata)
	if not item or not slot or not metadata then
		return false
	end

	exports["tgiann-inventory"]:UpdateItemMetadata(source, item, slot, metadata)
	return true
end

---@param source number
---@param item string
---@param slot? number
---@return table? metadata
function GetMetaData(source, item, slot)
	local itemData = slot and exports["tgiann-inventory"]:GetItemBySlot(source, slot) or exports["tgiann-inventory"]:GetItemByName(source, item)

	if not itemData or itemData.name ~= item then
		return nil
	end

	return itemData.metadata or itemData.info
end

---@param source number
---@param item string
---@return number? slot
function GetItemSlot(source, item)
	local itemData = exports["tgiann-inventory"]:GetItemByName(source, item)
	return itemData and (itemData.slot or itemData.key) or nil
end
