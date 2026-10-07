if Config.Framework ~= "esx" then
    return
end

---@param source number
---@param account? LoafWrapperMoneyAccount
---@return number
function GetMoney(source, account)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        return 0
    end

    if not account then
        local cash = xPlayer.getMoney() or 0
        local bank = xPlayer.getAccount("bank")?.money or 0

        return math.max(cash, bank)
    end

    return xPlayer.getAccount(account)?.money or 0
end

---@param source number
---@param amount number
---@param account? LoafWrapperMoneyAccount
---@return boolean success
function RemoveMoney(source, amount, account)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        return false
    end

    if account then
        local money = xPlayer.getAccount(account)?.money or 0

        if money >= amount then
            xPlayer.removeAccountMoney(account, amount)

            return true
        end

        return false
    end

    local cash = xPlayer.getMoney() or 0
    local bank = xPlayer.getAccount("bank")?.money or 0

    if cash >= amount then
        xPlayer.removeMoney(amount)

        return true
    elseif bank >= amount then
        xPlayer.removeAccountMoney("bank", amount)

        return true
    end

    return false
end

---@param source number
---@param amount number
---@param account? LoafWrapperMoneyAccount
---@return boolean
function AddMoney(source, amount, account)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        return false
    end

    xPlayer.addAccountMoney(account or "money", amount)

    return true
end
