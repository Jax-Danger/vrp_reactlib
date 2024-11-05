-- --##########	VRP Main	##########--
-- -- init vRP server context
-- Tunnel = module("vrp", "lib/Tunnel")
-- Proxy = module("vrp", "lib/Proxy")
-- local cvRP = module("vrp", "client/vRP")
-- vRP = cvRP()
-- local pvRP = {}
-- -- load script in vRP context
-- pvRP.loadScript = module
-- Proxy.addInterface("vRP", pvRP)
-- I don't know if above is needed :/
local ReactLib = class("ReactLib", vRP.Extension)
local cfg = module("vrp_reactlib", "cfg/cfg")

local focus = false
local active = false

function ReactLib:__construct()
  vRP.Extension.__construct(self)

  local openui = lib.addKeybind({
    name = 'openui',
    description = 'Opens the UI',
    defaultKey = cfg.open,
    onPressed = function(self)
      if not active then
        SetDisplay(not display)
        active = true
      elseif active then
        SetDisplay(false)
        active = false
      end
      SetNuiFocus(true, true)		-- (hasFocus [[true/false]], hasCursor [[true/false]])
    end
  })

  openui:disable(false) -- enables the keybind

end

-- toggle off ui
RegisterNUICallback("exit", function(data)
  SetNuiFocus(false, false)
  SetDisplay(false)
  active = false
end)

-- toggle ui
function SetDisplay(bool)
  display = bool
  SendNUIMessage({
    action = "setVisible",
    data = bool,
  })
end
vRP:registerExtension(ReactLib)
