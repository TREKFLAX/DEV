-- Please do not rename this resource folder

fx_version 'cerulean'

game 'gta5'
lua54 'yes'

author 'London Studios'
description 'Fire Job'
version '1.0.24'

ui_page 'web/build/index.html'

shared_scripts {
    'locales/init.lua',
    'locales/en.lua',
    'locales/es.lua',
    'locales/fr.lua',
    'locales/de.lua',
    'locales/pt.lua',
    'locales/it.lua',
    'locales/nl.lua',
    'locales/pl.lua',
    'locales/ru.lua',
    'locales/zh.lua',
    'config.lua',
}

client_scripts {
    'cl_utils.lua',
    'cl_commands.lua',
    'cl_notify.lua',
    'framework/cl_base.lua',
    'framework/ESX.lua',
    'framework/QBCore.lua',
    'framework/QBX.lua',
    'framework/TMC.lua',
    'framework/init.lua',
    'modules/cl_duty.lua',
    'modules/cl_aop.lua',
    'modules/cl_gearmenu.lua',
    'modules/cl_turnout.lua',
    'modules/cl_stationalerts.lua',
    'modules/cl_lightsetup.lua',
    'modules/cl_tvsetup.lua',
    -- 'cl_weaponNames.lua'
}

server_scripts {
    'sv_utils.lua',
    'server.lua',
}

files {
    'station_tvs.json',
    'station_lights.json',
    'web/build/index.html',
    'web/build/**/*',
    'data/firetones_sounds.dat54.rel',
    'audiodirectory/firejob_sounds.awc',
}

escrow_ignore {
    '*.json',
    'config.lua',
    'locales/*.lua',
    'sv_utils.lua',
    'cl_utils.lua',
    'framework/cl_base.lua',
    'framework/ESX.lua',
    'framework/QBCore.lua',
    'framework/QBX.lua',
    'framework/TMC.lua',
    'framework/init.lua',
}

data_file 'AUDIO_WAVEPACK'  'audiodirectory'
data_file 'AUDIO_SOUNDDATA' 'data/firetones_sounds.dat'

-- --ems tone:
-- https://www.zedge.net/ringtones/e18b0f27-f7bf-3eaf-ade2-e551aecfba37

-- beep boop entry tone:
--https://www.zedge.net/notification-sounds/53aaf948-5eb5-47f0-b165-d3b60eb773cb

-- fire tone:
-- https://www.zedge.net/notification-sounds/95899dea-9a8d-4044-a232-8b3f5d9b796e
dependency '/assetpacks'