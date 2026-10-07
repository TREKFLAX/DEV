fx_version 'cerulean'
game 'gta5'
lua54 'yes'
version '1.3'
games {
  "gta5",
  "rdr3"
}

ui_page 'ui/index.html'

shared_scripts {
  '@ox_lib/init.lua',
  "shared/framework.lua",
  "shared/config.lua",
  "shared/locale.lua",
  "shared/items.lua",
}

client_scripts {
  "client/vehicle.lua",
  "client/clothing.lua",
  "client/trunk.lua",
  "client/blips.lua",
  "client/stretcher.lua",
  "client/main.lua",
}

server_scripts {
  "server/server.lua",
  "server/trunk.lua",
  "server/stretcher.lua",
}

files {
  'ui/index.html',
  'ui/**/*',
  'locales/*.json',
}

escrow_ignore {
  "shared/*.lua",
  "client/*.lua",
  "server/*.lua",
}

dependency '/assetpacks'
dependency '/assetpacks-redm'