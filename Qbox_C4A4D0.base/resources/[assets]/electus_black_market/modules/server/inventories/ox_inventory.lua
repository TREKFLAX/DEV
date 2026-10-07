if Config.Inventory ~= "ox_inventory" then
    return
end

---@param options LoafWrapperStashOptions
function RegisterStash(options)
    exports.ox_inventory:RegisterStash(
        options.id,
        options.label,
        options.slots or 50,
        options.maxWeight or 5000,
        options.unique == true or options.owner,
        options.jobs,
        options.coords
    )
end

-- add item
-- remove item
-- get item count
-- get all items
-- register stash
-- open stash
-- remove stash
-- get item metadata (key?)
-- set item metadata (key, value)

---@param source number
---@param item string
---@return number count
function GetItemCount(source, item)
    return exports.ox_inventory:GetItem(source, item, nil, true) or 0
end

---@param source number
---@param item string
---@param count? number
---@param metadata? table
---@return boolean success
function AddItem(source, item, count, metadata)
    count = math.max(count or 1, 1)

    if not exports.ox_inventory:CanCarryItem(source, item, count) then
        return false
    end

    local success, response = exports.ox_inventory:AddItem(source, item, count, metadata)

    if response then
        debugprint("ox_inventory AddItem:", source, item, count, metadata, response)
    end

    return success
end

---@param source number
---@param item string
---@param count? number
---@return boolean success
function RemoveItem(source, item, count)
    count = math.max(count or 1, 1)

    if GetItemCount(source, item) < count then
        return false
    end

    local success, response = exports.ox_inventory:RemoveItem(source, item, count)

    if response then
        debugprint("ox_inventory RemoveItem:", source, item, count, response)
    end

    return success
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

    exports.ox_inventory:SetMetadata(source, slot, metadata)
    return true
end

---@param source number
---@param item string
---@param slot? number
---@return table? metadata
function GetMetaData(source, item, slot)
    local itemData = slot and exports.ox_inventory:GetSlot(source, slot) or exports.ox_inventory:GetSlotWithItem(source, item)

    if not itemData or itemData.name ~= item then
        return nil
    end

    return itemData.metadata
end

---@param source number
---@param item string
---@return number? slot
function GetItemSlot(source, item)
    return exports.ox_inventory:GetSlotIdWithItem(source, item)
end

-- TODO:
---@return { item: string, count: string, metadata?: table }[]
function GetAllItems(source)
    local items = exports.ox_inventory:GetAllItems(source) or {}

    return items
end
