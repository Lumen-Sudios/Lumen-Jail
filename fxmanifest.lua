fx_version 'cerulean'
game 'gta5'
author 'Liam'
description 'Liam\'s Jail System'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
} 
client_script 'client.lua'
server_script 'server.lua'

lua54 'yes'
dependencies {
    'ox_lib'
}