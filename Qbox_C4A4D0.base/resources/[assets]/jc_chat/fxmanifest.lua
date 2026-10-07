fx_version 'bodacious'
game 'gta5'
Autor 'Jota Dev | https://store.jotadev.site/'

Descripcion '[JOTA DEV] Chat System | https://store.jotadev.site/'

lua54 'yes'

version '1.0.12'

ui_page 'html/index.html'

files {
  'html/**/*.*'
}

shared_scripts {
  'Config/Setting.lua',
  'Config/Commands.lua',
  'Locales/*.lua'
}

client_scripts {
  'Client/*.lua'
}

server_scripts {
  'Server/*.lua'
}

escrow_ignore {
  'Config/*.lua',
  'Locales/*.lua'
}
dependency '/assetpacks'