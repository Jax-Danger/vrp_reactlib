fx_version "cerulean"
lua54 "yes"
games {"gta5"}

ui_page "build/index.html"
lua54 "yes"

shared_script "@ox_lib/init.lua"

dependency "vrp"

server_script {
  "@vrp/lib/utils.lua",
  "server/sv_vrp.lua"
}

client_script {
  "@vrp/lib/utils.lua",
  "client/cl_vrp.lua",
}

files {
  "cfg/cfg.lua",
  "client/client.lua",
  "client/utils.lua",
  "build/index.html",
  "build/**/*"
}
