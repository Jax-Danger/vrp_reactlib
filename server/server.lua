local lang = vRP.lang
local Luang = module("vrp", "lib/Luang")

local Dealerships = class("Dealerships", vRP.Extension)
Dealerships.event = {}
Dealerships.tunnel = {}

function Dealerships:__construct()
  vRP.Extension.__construct(self)
  -- load config
  self.cfg = module("vrp_dealerships", "cfg/cfg")
end

function Dealerships:purchaseVehicle(self, name, model, price)
  local user = vRP.users_by_source[source]
  local curCash = user:getWallet()
  local curBank = user:getBank()
  print(model, price) -- debug print
  if curCash >= price or curBank >= price then
    user:tryFullPayment(price)
    local uvehicles = user:getVehicles()
    if uvehicles == nil then return print('uvechicles is nil') end
    uvehicles[model] = 1
    print(json.encode(uvehicles)) -- debug print
    return true
  else
    print('user does not have enough money')
    vRP.vRP.EXT.Base.remote._notify(user.source, "Not enough money")
  end
end

-- function Dealerships:setVehicleAsOwned(model)
--   local user = vRP.users_by_source[source]
--   local uvehicles = user:getVehicles()
--   if uvehicles == nil then return print('uvechicles is nil') end
--   uvehicles[prompt] = 1
--   print(json.encode(uvehicles)) -- debug print
-- end

Dealerships.tunnel={}
Dealerships.tunnel.purchaseVehicle = Dealerships.purchaseVehicle
Dealerships.tunnel.setVehicleAsOwned = Dealerships.setVehicleAsOwned
vRP:registerExtension(Dealerships)
