if Config.Inventory ~= "core_inventory" then
	return
end

---@param options LoafWrapperStashOptions
function RegisterStash(options)

end

---@param source number
---@param item string
---@return number count
function GetItemCount(source, item)
	return exports.core_inventory:getItemCount(source, item)
end

---@param source number
---@param item string
---@param count? number
---@param metadata? table
---@return boolean success
function AddItem(source, item, count, metadata)
	return exports.core_inventory:addItem(source, item, count, metadata) ~= false
end

---@param source number
---@param item string
---@param count? number
---@return boolean success
function RemoveItem(source, item, count)
	return exports.core_inventory:removeItem(source, item, count)
end

---@param source number
---@param item string
---@param slot number
---@param metadata table
---@return boolean success
function SetItemMetadata(source, item, slot, metadata)
	if not slot or not metadata then
		return false
	end

	exports.core_inventory:setMetadata(source, slot, metadata)
	return true
end

---@param source number
---@param item string
---@param slot? number
---@return table? metadata
function GetMetaData(source, item, slot)
	local itemData = slot and exports.core_inventory:getItemBySlot(source, slot) or exports.core_inventory:getItem(source, item)

	if not itemData or itemData.name ~= item then
		return nil
	end

	return itemData.metadata or itemData.info
end

---@param source number
---@param item string
---@return number? slot
function GetItemSlot(source, item)
	return exports.core_inventory:getFirstSlotByItem(source, item)
end
