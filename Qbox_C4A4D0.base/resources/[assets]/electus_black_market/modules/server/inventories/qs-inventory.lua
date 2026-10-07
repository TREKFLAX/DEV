if Config.Inventory ~= "qs-inventory" then
    return
end

---@param options LoafWrapperStashOptions
function RegisterStash(options)

end

---@param source number
---@param item string
---@return number count
function GetItemCount(source, item)
    return exports["qs-inventory"]:GetItemTotalAmount(source, item)
end

---@param source number
---@param item string
---@param count? number
---@param metadata? table
---@return boolean success
function AddItem(source, item, count, metadata)
    return exports["qs-inventory"]:AddItem(source, item, count, nil, metadata)
end

---@param source number
---@param item string
---@param count? number
---@return boolean success
function RemoveItem(source, item, count)
    return exports["qs-inventory"]:RemoveItem(source, item, count)
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

    exports["qs-inventory"]:SetItemMetadata(source, slot, metadata)
    return true
end

---@param source number
---@param item string
---@param slot? number
---@return table? metadata
function GetMetaData(source, item, slot)
    local inventory = exports["qs-inventory"]:GetInventory(source) or {}
    local itemData = slot and inventory[slot] or nil

    if not itemData then
        for _, inventoryItem in pairs(inventory) do
            if inventoryItem.name == item then
                itemData = inventoryItem
                break
            end
        end
    end

    if not itemData or itemData.name ~= item then
        return nil
    end

    return itemData.info or itemData.metadata
end

---@param source number
---@param item string
---@return number? slot
function GetItemSlot(source, item)
    local inventory = exports["qs-inventory"]:GetInventory(source) or {}

    for slot, itemData in pairs(inventory) do
        if itemData.name == item then
            return itemData.slot or slot
        end
    end

    return nil
end
