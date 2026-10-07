function LoadMarkets()
	return MySQL.query.await(("SELECT * FROM `%s`"):format(Config.Database.MarketsTable), {}) or {}
end

function SaveMarket(market)
	local npc = market.npc or {}
	local coords = npc.coords or {}

	MySQL.update.await(
		([[INSERT INTO `%s`
		(`id`, `label`, `source`, `zone_id`, `enabled`, `npc_model`, `npc_coords`, `npc_scenario`, `schedule`, `items`)
		VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
		ON DUPLICATE KEY UPDATE
			`label` = VALUES(`label`),
			`source` = VALUES(`source`),
			`zone_id` = VALUES(`zone_id`),
			`enabled` = VALUES(`enabled`),
			`npc_model` = VALUES(`npc_model`),
			`npc_coords` = VALUES(`npc_coords`),
			`npc_scenario` = VALUES(`npc_scenario`),
			`schedule` = VALUES(`schedule`),
			`items` = VALUES(`items`)]]):format(Config.Database.MarketsTable),
		{
			market.id,
			market.label,
			market.source or "ui",
			market.zoneId,
			market.enabled ~= false and 1 or 0,
			npc.model,
			json.encode(coords),
			npc.scenario,
			json.encode(market.schedule or {}),
			json.encode(market.items or {}),
		}
	)

	return true
end

function DeleteMarket(id)
	MySQL.update.await(("DELETE FROM `%s` WHERE `id` = ?"):format(Config.Database.MarketsTable), {
		id,
	})

	return true
end

function GetItemSoldLast24h(marketId, itemName)
	local result = MySQL.scalar.await(
		([[SELECT COALESCE(SUM(`amount`), 0) FROM `%s`
		WHERE `market_id` = ?
			AND `item` = ?
			AND `created_at` >= DATE_SUB(NOW(), INTERVAL 24 HOUR)]]):format(Config.Database.TransactionsTable),
		{
			marketId,
			itemName,
		}
	)

	return tonumber(result) or 0
end

function LogTransaction(src, market, item, amount, cb)
	MySQL.insert.await(
		([[INSERT INTO `%s`
		(`market_id`, `zone_id`, `identifier`, `item`, `amount`, `unit_price`)
		VALUES (?, ?, ?, ?, ?, ?)]]):format(Config.Database.TransactionsTable),
		{
			market.id,
			market.zoneId,
			GetIdentifier(src),
			item.item,
			amount,
			item.price,
		}
	)

	if cb then
		cb(true)
	end

	return true
end
