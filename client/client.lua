local InvUI = class("InvUI", vRP.Extension)
InvUI.event = {}
InvUI.tunnel = {}

function InvUI:__construct()
  vRP.Extension.__construct(self)
  self.cfg = module("vrp_inventory", "cfg/cfg")
end

RegisterNUICallback("getServerInfo", function(_, cb)
  local pvp = "disabled"
  if self.cfg.EnablePvP then pvp = "enabled" end
  local isPvp = pvp
  print("Sending server info to UI")
  cb({
    serverName = self.cfg.ServerName,
    StartingMoney = self.cfg.StartingMoney,
    EnablePvP = isPvp
  })
end)

function SendReactMessage(action, data)
  SendNUIMessage({action = action, data = data})
end

function toggleNuiFrame(shouldShow)
  SetNuiFocus(shouldShow, shouldShow)
  SendReactMessage("setVisible", shouldShow)
end

RegisterNUICallback("hideFrame", function(_, cb)
  toggleNuiFrame(false)
  print("Hide NUI frame")
  cb({})
end)


vRP:registerExtension(InvUI)
