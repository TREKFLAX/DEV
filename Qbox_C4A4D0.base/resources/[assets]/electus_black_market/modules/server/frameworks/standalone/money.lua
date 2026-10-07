if Config.Framework ~= "custom" then
    return
end

---@param source number
---@param account? LoafWrapperMoneyAccount
---@return number
function GetMoney(source, account)
    return 0
end

---@param source number
---@param amount number
---@param account? LoafWrapperMoneyAccount
---@return boolean success
function RemoveMoney(source, amount, account)
    return true
end

---@param source number
---@param amount number
---@param account? LoafWrapperMoneyAccount
---@return boolean
function AddMoney(source, amount, account)
    return true
end
