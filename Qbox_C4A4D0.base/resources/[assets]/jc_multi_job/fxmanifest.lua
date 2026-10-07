fx_version 'bodacious'
game 'gta5'

author 'Jota Dev'

version '1.0.07'

description '[JOTA DEV] Multijob | https://store.jotadev.site/'
lua54 'yes'

dependencies {
  'oxmysql',
  'ox_lib',
}

shared_script {
  '@ox_lib/init.lua',
  'Config/Setting.lua',
  'Locale/*.lua',
  'Bridge.lua',
}

client_scripts {
  'Editable/Client/**/*.lua',
  'Client/CMain.lua',
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'Editable/Server/**/*.lua',
  'Config/SConfig.lua',
  'Server/SMain.lua',
}

ui_page 'Web/build/index.html'

files {
  'Web/build/**/*',
}


escrow_ignore {
  'Locale/en.lua',
  'Locale/es.lua',
  'Locale/fr.lua',
  'Locale/de.lua',
  'Locale/it.lua',
  'Locale/pt.lua',
  'Bridge.lua',
  'Editable/**/*.lua',
  'Config/*.lua',
}

dependency '/assetpacks'