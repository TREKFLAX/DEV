Config = {}

Config.Framework = "auto" -- "auto", "esx", "qbcore", "qbox"
Config.Inventory = "auto" -- "auto", "ox_inventory", "core", "qs-inventory", "tgiann", "esx", "qb-core", "codem", "qb-inventory"
Config.Target = "auto" -- "auto", true, false
Config.NotificationSystem = "ox_lib" -- "auto" | "framework" | "ox_lib" | "gta"
Config.MenuSystem = "ox_lib_menu"
Config.HelpTextStyle = "ox_lib"

Config.Locale = "en"
Config.Debug = true

Config.Command = {
	Manage = "manage_black_market",
}

Config.Admin = {
	Ace = "command.manage_black_market",
	Groups = { "admin", "god", "superadmin" },
}

Config.Database = {
	MarketsTable = "electus_black_market_markets",
	TransactionsTable = "electus_black_market_transactions",
}

Config.Interaction = {
	Distance = 2.0,
	NativeKey = 38,
}

Config.Security = {
	MaxPurchaseDistance = 5.0,
	MaxPurchaseAmount = 25,
}

Config.Camera = {
	Enabled = true,
	Fov = 38.0,
	Offset = vector3(0.0, 1.75, 0.72),
	PointOffset = vector3(0.0, 0.0, 0.62),
	TransitionMs = 450,
}

Config.DefaultPed = {
	Model = "g_m_m_chicold_01",
	Scenario = "WORLD_HUMAN_SMOKING",
	Invincible = true,
}

Config.NpcProp = {
	Enabled = true,
	Model = "ba_prop_batle_crates_mule",
	Offset = vector3(1.25, -1.0, 0.0),
	HeadingOffset = -90.0,
}

Config.DefaultMarketSchedule = {
	Enabled = true,
	StartHour = 20,
	EndHour = 6,
}

Config.BlackMoneyItem = "markedbills"

Config.ElectusGangs = {
	Enabled = true,
	RequirePlayerInZone = false,

	Blip = {
		Enabled = true,
		OnlyWhenAvailable = true,
		Sprite = 500,
		Color = 1,
		Scale = 0.75,
		Display = 4,
		ShortRange = true,
		Label = "Gang Black Market",
	},

	ZoneType = {
		Name = "black_market",
		Label = "Black Market",
		Description = "Black market zone where you can buy and sell illegal items.",
		Icon = "IoCube",
		ActionName = "black_market_marker",
		ActionLabel = "Black Market marker",
		ActionButtonLabel = "Set marker",
		CloseManageZones = true,
	},

	DefaultZoneMarket = {
		label = "Zone Black Market",
		npc = {
			model = "g_m_m_chicold_01",
			scenario = "WORLD_HUMAN_SMOKING",
		},
		items = {
			{ id = "lockpick", item = "lockpick", label = "Lockpick", price = 450, maxStock24h = 25 },
			{ id = "weapon_pistol", item = "weapon_pistol", label = "Pistol", price = 18500, maxStock24h = 5 },
		},
	},
}

Config.BlackMarkets = {
	{
		id = "vespucci_drop",
		label = "Vespucci Drop",
		npc = {
			model = "g_m_m_chicold_01",
			coords = vector4(-1172.57, -1572.11, 4.66, 124.0),
			scenario = "WORLD_HUMAN_SMOKING",
		},
		access = {
			type = "public",
		},
		items = {
			{ id = "weapon_knife", item = "weapon_knife", label = "Knife", price = 1250, maxStock24h = 20 },
			{ id = "armor", item = "armor", label = "Armor", price = 3200, maxStock24h = 15 },
			{ id = "radio", item = "radio", label = "Encrypted Radio", price = 900, maxStock24h = 25 },
		},
	},
}
