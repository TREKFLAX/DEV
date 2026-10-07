if Config.Inventory ~= "qb-inventory" then
    return
end

---@param options LoafWrapperStashOptions
function RegisterStash(options)

end

---@param source number
---@param item string
---@return number count
function GetItemCount(source, item)
    return exports["qb-inventory"]:GetItemCount(source, item)
end

---@param source number
---@param item string
---@param count? number
---@param metadata? table
---@return boolean success
function AddItem(source, item, count, metadata)
    return exports["qb-inventory"]:AddItem(source, item, count, false, metadata)
end

---@param source number
---@param item string
---@param count? number
---@return boolean success
function RemoveItem(source, item, count)
    return exports["qb-inventory"]:RemoveItem(source, item, count)
end

---@param source number
---@param item string
---@param slot number
---@param metadata table
---@return boolean success
function SetItemMetadata(source, item, slot, metadata)
    if not item or not metadata then
        return false
    end

    return exports["qb-inventory"]:SetItemData(source, item, "info", metadata, slot)
end

---@param source number
---@param item string
---@param slot? number
---@return table? metadata
function GetMetaData(source, item, slot)
    local itemData = slot and exports["qb-inventory"]:GetItemBySlot(source, slot) or exports["qb-inventory"]:GetItemByName(source, item)

    if not itemData or itemData.name ~= item then
        return nil
    end

    return itemData.info or itemData.metadata
end

---@param source number
---@param item string
---@return number? slot
function GetItemSlot(source, item)
    local itemData = exports["qb-inventory"]:GetItemByName(source, item)
    return itemData and itemData.slot or nil
end
