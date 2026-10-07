fx_version 'bodacious'
game 'gta5'
author 'Jota Dev'
description '[JOTA DEV] Blips Creator | https://store.jotadev.site/'
lua54 'yes'

version '1.0.0'

dependency 'jc_admin'

client_script {
  'Client/*.lua',
}

server_script {
  '@oxmysql/lib/MySQL.lua',
  'Server/*.lua'
}

shared_script {
  '@ox_lib/init.lua',
  'Editable/**/*.lua',
  'Config/Setting.lua',
  'Bridge.lua'
}

escrow_ignore {
  'Editable/**/*.lua',
  'Config/*.lua'
}

dependency '/assetpacks'