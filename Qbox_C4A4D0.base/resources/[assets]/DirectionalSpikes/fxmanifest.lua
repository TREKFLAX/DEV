fx_version 'bodacious'
games { 'gta5' }

author 'London Studios'
description 'A resource allowing you to create directional spikes.'
version '1.0.5'
lua54 'yes'

files {
    'locations.json',
}

client_scripts {
    'cl_directionalspikes.lua',
    'cl_spooner.lua',
    'cl_utils.lua',
}

server_scripts {
    'sv_directionalspikes.lua',
    'sv_utils.lua'
}

shared_script 'config.lua'

escrow_ignore {
    'cl_utils.lua',
    'sv_utils.lua',
    'config.lua',
    'locations.json'
}

shared_script 'config.lua'

files {
    'stream/bv_directionalspikes.ytyp',
 }
 
 data_file 'DLC_ITYP_REQUEST' 'stream/bv_directionalspikes.ytyp'
dependency '/assetpacks'