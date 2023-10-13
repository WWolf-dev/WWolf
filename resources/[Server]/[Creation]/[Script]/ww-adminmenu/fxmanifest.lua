fx_version 'cerulean'

game 'gta5'

author 'White Wolf'

version '1.0.0'

description 'Advanced Admin Menu by White Wolf'

lua54 'yes'

shared_scripts {
    '@es_extended/imports.lua',
    -- '@es_extended/locale.lua',
    '@ox_lib/init.lua',
    'shared/framework.lua',
    'shared/translation.lua',
    'shared/webhooks.lua',
    'shared/config.lua',
    'shared/config_peds.lua',
}

client_scripts {
    'client/main.lua',
    'client/modules/noclip.lua',
    'client/modules/compatibility.lua',
    'client/modules/spectate.lua',
    'client/modules/menu/main.lua',
    'client/modules/menu/selfOptions.lua',
    'client/modules/menu/playerOptions.lua',
    'client/modules/menu/vehicleOptions.lua',
    'client/modules/menu/serverOptions.lua',
    'client/modules/menu/zoneOptions.lua',

    -- 'client/modules/noclip.lua',
    -- 'client/modules/menu/main.lua',
    -- 'client/modules/menu/selfOptions.lua',
    -- 'client/modules/menu/playerOptions.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/modules/admin_perm.lua',
    'server/modules/callbacks.lua',
    'server/modules/spectate.lua',
    'server/modules/compatibility.lua',
    'server/modules/ban.lua',
    'server/modules/zones.lua',
    'server/main.lua',
    'server/events.lua',
    'server/commands.lua',

    -- 'server/callbacks.lua',
    -- 'server/modules/spectate.lua',
}

dependencies {
    '/server:6000',
    '/onesync',
    'oxmysql',
    '/gameBuild:mpchristmas3',
    'ox_lib'
}