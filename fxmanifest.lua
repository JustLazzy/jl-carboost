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
client_script 'client/main.lua'

ui_page 'html/index.html'

lua54 'yes'


files {
	'html/index.html',
	'html/style.css',
	'html/js/*.js',
	'html/assets/*.png',
	'html/assets/shop/*.png',
	'html/assets/*.svg',
	'html/assets/audio/*.mp3',
	'html/assets/audio/*.wav',
}