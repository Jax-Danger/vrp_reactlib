local Proxy = module("vrp", "lib/Proxy")

local vRP = Proxy.getInterface("vRP")

async(
  function()
    vRP.loadScript("vrp_reactlib", "client/client")
  end
)
