local InvUI = class("InvUI", vRP.Extension)
InvUI.event = {}
InvUI.tunnel = {}

function InvUI:__construct()
  vRP.Extension.__construct(self)
  self.cfg = module("vrp_inventory", "cfg/cfg")

  print('^6Initializing InvUI^0')
end
vRP:registerExtension(InvUI)
