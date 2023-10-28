fx_version 'cerulean'

game 'gta5'

name 'ww-lib'

author 'White Wolf'

version '1.0.0'

description 'A library with shared functions to utilise in other resources by White Wolf'

lua54 'yes'

client_scripts {
    'common.lua',
    'modules/**/client.lua',
    'modules/**/shared.lua'
}

server_scripts {
    'common.lua',
    'modules/**/server.lua',
    'modules/**/shared.lua'
}

files {
    'init.lua'
}

dependencies {
    '/server:6000',
    '/onesync',
    '/gameBuild:mpchristmas3'
}