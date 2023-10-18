fx_version 'cerulean'

game 'gta5'

author 'White Wolf'

version '1.0.0'

description 'Rental Script by White Wolf'

lua54 'yes'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'shared/framework.lua',
    'shared/translation.lua',
    'shared/webhooks.lua',
    'shared/config.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
}

dependencies {
    '/server:6000',
    '/onesync',
    'oxmysql',
    '/gameBuild:mpchristmas3',
    'ox_lib'
}