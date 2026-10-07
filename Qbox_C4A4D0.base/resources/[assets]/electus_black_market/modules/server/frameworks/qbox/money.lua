if Config.Framework ~= "qbox" then
	return
end

local BLACK_MONEY_ITEMS = { "markedbills", "dirtycash", "dirty_cash" }

local function GetBlackMoneyItem()
	if Config.BlackMoneyItem and Config.BlackMoneyItem ~= "auto" then
		return Config.BlackMoneyItem
	end

	for _, itemName in ipairs(BLACK_MONEY_ITEMS) do
		if QB and QB.Shared and QB.Shared.Items and QB.Shared.Items[itemName] then
			return itemName
		end
	end

	return BLACK_MONEY_ITEMS[1]
end

local blackMoneyItem = GetBlackMoneyItem()

local function GetMarkedBills(qPlayer)
	local markedBills = {}
	local total = 0

	for slot, item in pairs(qPlayer.PlayerData.items or {}) do
		if type(item) == "table" and item.name == blackMoneyItem then
			local metadata = item.info or item.metadata or {}
			local count = math.max(tonumber(item.amount or item.count) or 1, 1)
			local worth = math.max(tonumber(metadata.worth) or 1, 1)
			local value = count * worth

			if value > 0 then
				markedBills[#markedBills + 1] = {
					item = blackMoneyItem,
					slot = item.slot or slot,
					count = count,
					worth = worth,
					value = value,
					metadata = metadata,
				}

				total = total + value
			end
		end
	end

	return total, markedBills
end

local function AddMarkedBills(source, qPlayer, amount)
	local metadata = { worth = amount }

	if type(AddItem) == "function" and AddItem(source, blackMoneyItem, 1, metadata) then
		return true
	end

	return qPlayer.Functions.AddItem(blackMoneyItem, 1, false, metadata) == true
end

local function RemoveMarkedBillItems(qPlayer, bill, count)
	if count < 1 then
		return true
	end

	if not qPlayer.Functions.RemoveItem(bill.item, count, bill.slot) then
		return false
	end

	return true
end

local function RemoveMarkedBills(source, qPlayer, amount)
	local total, markedBills = GetMarkedBills(qPlayer)

	if total < amount then
		return false
	end

	local remaining = amount

	for _, bill in ipairs(markedBills) do
		if remaining <= 0 then
			break
		end

		if bill.value <= remaining then
			if not RemoveMarkedBillItems(qPlayer, bill, bill.count) then
				return false
			end

			remaining = remaining - bill.value
		else
			local removeCount = math.floor(remaining / bill.worth)
			local partialWorth = remaining - (removeCount * bill.worth)

			if partialWorth > 0 then
				removeCount = removeCount + 1
			end

			if not RemoveMarkedBillItems(qPlayer, bill, removeCount) then
				return false
			end

			if partialWorth > 0 then
				return AddMarkedBills(source, qPlayer, bill.worth - partialWorth)
			end

			return true
		end
	end

	return remaining <= 0
end

---@param source number
---@param account? LoafWrapperMoneyAccount
---@return number
function GetMoney(source, account)
	local qPlayer = GetQBPlayer(source)

	if not qPlayer then
		return 0
	end

	if not account then
		local cash = qPlayer.Functions.GetMoney("cash") or 0
		local bank = qPlayer.Functions.GetMoney("bank") or 0

		return math.max(cash, bank)
	end

	if account == "money" then
		return qPlayer.Functions.GetMoney("cash") or 0
	elseif account == "bank" then
		return qPlayer.Functions.GetMoney("bank") or 0
	elseif account == "black_money" then
		local total = GetMarkedBills(qPlayer)
		return total
	end

	debugprint("GetMoney: Invalid account type (Qbox):", account)

	return 0
end

---@param source number
---@param amount number
---@param account? LoafWrapperMoneyAccount
---@return boolean success
function RemoveMoney(source, amount, account)
	local qPlayer = GetQBPlayer(source)

	if not qPlayer then
		return false
	end

	if account == "black_money" then
		return RemoveMarkedBills(source, qPlayer, amount)
	end

	if account then
		local money = GetMoney(source, account)

		if money >= amount then
			qPlayer.Functions.RemoveMoney(account == "money" and "cash" or "bank", amount)

			return true
		end

		return false
	end

	local cash = qPlayer.Functions.GetMoney("cash") or 0
	local bank = qPlayer.Functions.GetMoney("bank") or 0

	if cash >= amount then
		qPlayer.Functions.RemoveMoney("cash", amount)

		return true
	elseif bank >= amount then
		qPlayer.Functions.RemoveMoney("bank", amount)

		return true
	end

	return false
end

---@param source number
---@param amount number
---@param account? LoafWrapperMoneyAccount
---@return boolean
function AddMoney(source, amount, account)
	local qPlayer = GetQBPlayer(source)

	if not qPlayer then
		return false
	end

	if account == "black_money" then
		return AddMarkedBills(source, qPlayer, amount)
	end

	account = account or "money"

	qPlayer.Functions.AddMoney(account == "money" and "cash" or "bank", amount)

	return true
end
