fx_version 'cerulean'

game 'gta5'

author 'JustLazzy'

description 'QBCore Car Boosting Script With Laptop UI'

version '1.0.1'

shared_script {
	'@qb-core/shared/locale.lua',
	'locales/en.lua',
	'config.lua',
	'utils.lua'
}

server_script {
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua',
}
client_script {
	'@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'client/*.lua',
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