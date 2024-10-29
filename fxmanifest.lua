fx_version "cerulean"
lua54 "yes"
games {"gta5"}
lua54 "yes"

ui_page "cfg/html/index.html"

dependency "vrp"

shared_scripts {
  '@ox_lib/init.lua',
}

server_script {
  "@vrp/lib/utils.lua",
  "server/vrp_s.lua"
}

client_script {
  "@vrp/lib/utils.lua",
  'client/client.lua'
}

files {
  "cfg/cfg.lua",
  'cfg/html/index.html',
  'cfg/html/assets/*.js',
  'cfg/html/assets/*.css'
}
