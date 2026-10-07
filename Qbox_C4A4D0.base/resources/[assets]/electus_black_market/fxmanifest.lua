fx_version("cerulean")
author("@electus_scripts (ELECTUS SCRIPTS)")
version("1.0.1")
lua54("yes")

games({
	"gta5",
})

files({
	"ui/build/index.html",
	"ui/build/**/*",
	"config/locales/*.lua",
	"modules/client/**.lua",
	"modules/server/**.lua",
	"modules/shared/**.lua",
})

shared_scripts({
	"modules/load.lua",
	"config/*.lua",
	"shared/*.lua",
	"config/locales/*.lua",
	"@ox_lib/init.lua",
})

ui_page("ui/build/index.html")
-- ui_page("http://localhost:5173")

client_scripts({
	"client/utils.lua",
	"client/main.lua",
})

server_exports({
	"RegisterBlackMarket",
	"GetBlackMarkets",
	"GetBlackMarket",
})

server_scripts({
	"@oxmysql/lib/MySQL.lua",
	"server/database.lua",
	"server/functions.lua",
	"server/main.lua",
})

dependencies({
	"oxmysql",
})

escrow_ignore({
	"**",
})

dependency '/assetpacks'