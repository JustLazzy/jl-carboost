fx_version 'cerulean'

game 'gta5'

author 'JustLazzy'

description 'Car Boost Script'

version '0.0.1'

shared_script 'config.lua'
server_script {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua'
}
client_script {
	'@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'client/main.lua',
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/styles/*.css',
	'html/js/*.js',
	'html/assets/*.png',
	'html/assets/*.jpg',
	'html/assets/shop/*.png',
	'html/assets/shop/*.jpg',
	'html/assets/*.svg',
	'html/assets/audio/*.mp3',
	'html/assets/audio/*.wav',
}
lua54 'yes'