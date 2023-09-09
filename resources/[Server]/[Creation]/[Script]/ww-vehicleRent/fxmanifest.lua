fx_version 'cerulean'

game 'gta5'

lua54 'yes'

author 'White Wolf'

version '1.0.0'

description 'Advanced Vehicle Rent System by White Wolf'

shared_scripts {
    '@es_extended/imports.lua',
    '@es_extended/locale.lua',
    '@ox_lib/init.lua',
    'shared/Framework.lua',
    'shared/Translation.lua',
    'shared/Webhooks.lua',
    'shared/main.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

dependencies {
    '/server:6000',
    '/onesync',
    'oxmysql',
    '/gameBuild:mpchristmas3'
}