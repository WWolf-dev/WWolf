fx_version 'cerulean'

game 'gta5'

author 'White Wolf'

version '1.0.0'

description 'Advanced GoFast Script by White Wolf'

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
    'client/modules/**/*.lua',
    'client/modules/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/modules/**/*.lua',
    'server/modules/*.lua',
}

dependencies {
    '/server:6000',
    '/onesync',
    'oxmysql',
    '/gameBuild:mpchristmas3',
    'ox_lib'
}