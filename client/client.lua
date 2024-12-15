--##########	VRP Main	##########--
-- init vRP server context
Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")
local cvRP = module("vrp", "client/vRP")
vRP = cvRP()
local pvRP = {}
-- load script in vRP context
pvRP.loadScript = module
Proxy.addInterface("vRP", pvRP)
local cfg = module("vrp_dealerships", "cfg/cfg")

local Dealerships = class("Dealerships", vRP.Extension)

local focus = false
local active = false
--Vehicle Classes
local vehicleClassNames = {
  [0] = "compacts",
  [1] = "sedans",
  [2] = "suvs",
  [3] = "coupes",
  [4] = "muscle",
  [5] = "sportsclassics",
  [6] = "sports",
  [7] = "super",
  [8] = "motorcycles",
  [9] = "offroad",
  [10] = "industrial",
  [11] = "utility",
  [12] = "vans",
  [13] = "cycles",
  [14] = "boats",
  [15] = "helicopters",
  [16] = "planes",
  [17] = "service",
  [18] = "emergency",
  [19] = "military",
  [20] = "commercial",
  [21] = "trains"
}
local rentedVehicles = {}
local eventTriggered = false

-- Everything in here is triggered when the extension is loaded.
function Dealerships:__construct()
  vRP.Extension.__construct(self)
  Init(self)
  lib.hideTextUI()
end

--[[FUNCTIONS]]--
function Init(self)
  -- Create blips for each dealership
  for name, dealership in pairs(cfg.dealerships) do
    if not dealership.blips then
      return
    end
    local x, y, z = table.unpack(dealership.blip.coords)
    local blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, dealership.blip.id)
    SetBlipColour(blip, dealership.blip.colour)
    SetBlipScale(blip, dealership.blip.scale)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
  end
  -- spawn the vehicles for each dealership
  for _, dealership in pairs(cfg.dealerships) do
    for position, pos in pairs(dealership.positions) do
      local x, y, z = table.unpack(pos.coords)
      local model = pos.model

      -- Request and load the model
      RequestModel(model)
      while not HasModelLoaded(model) do
        Wait(500) -- Wait for the model to load
      end

      -- Create the vehicle
      local vehicle = CreateVehicle(model, x, y, z, pos.heading, true, false)
      SetEntityAsMissionEntity(vehicle, true, true)
      SetVehicleOnGroundProperly(vehicle)
      SetVehicleHasBeenOwnedByPlayer(vehicle, true)
      SetVehicleNumberPlateText(vehicle, "PDM")
      SetVehicleNumberPlateTextIndex(vehicle, 1)
      SetModelAsNoLongerNeeded(model)

      -- Make the vehicle invincible and frozen
      SetEntityInvincible(vehicle, true)
      FreezeEntityPosition(vehicle, true)

      -- Ensure the vehicle does not despawn
      local networkId = NetworkGetNetworkIdFromEntity(vehicle)
      SetNetworkIdCanMigrate(networkId, false)
      SetNetworkIdExistsOnAllMachines(networkId, true)
    end
  end
  -- Interaction to purchase vehicles
  for name, ds in pairs(cfg.dealerships) do
    for _, pos in pairs(ds.positions) do
      if not pos.interaction then print("No interaction found for this position") end -- Check if pos.interaction is not nil
      local x, y, z = table.unpack(pos.interaction.coords)
      exports.ox_target:addBoxZone({
        coords = vec3(x, y, z),
        options = {{
          label = "Purchase Vehicle",
          name = "veh_interaction",
          icon = "fas fa-car",
          distance = 2.5,
          onSelect = function()
            local coords = vector3(x, y, z)
            local nveh, nvehcoords = lib.getClosestVehicle(coords, 5, false)
            local model = GetEntityModel(nveh)
            local vehname = string.lower(GetDisplayNameFromVehicleModel(model))
            print(model, vehname, nveh)
            local cx, cy, cz = table.unpack(ds.vehSpawn)
            local price, name, model = table.unpack(getVehicleDetails(vehname))
            local isVehiclePurchased = self.remote.purchaseVehicle(self, name, model, price)
            print('purchasing vehicle')
            if isVehiclePurchased then
              print('vehicle purchased')
              spawnCar(self, model)
            end
          end
        }}
      })
    end
  end
end

-- Returns the details of a specific vehicle.
function getVehicleDetails(vehname)
  local price = 0
  local vehName = nil
  local vehModel = nil
  for dealershipName, dealership in pairs(cfg.dealerships) do
    for _, vehicles in pairs(dealership.vehicles) do
      if vehname == vehicles.name then
        price, vehName, vehModel = vehicles.price, vehicles.label, vehicles.name
        print(price,vehName, vehModel)
        break
      end
    end
  end
  return {price, vehName, vehModel}
end

--[[TUNNELS]]--
-- This spawns the car at the position for the player
function spawnCar(self, model)
  local vehicleSpawned = false
  for name, ds in pairs(cfg.dealerships) do
    local x, y, z = table.unpack(ds.vehSpawn)
    for class, veh in pairs(ds.vehicles) do
      if veh.name == model then
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(500) end
        if not HasModelLoaded(model) then return print("Failed to load model:", model) end
        local spawnedVehicle = CreateVehicle(model, x, y, z, 0.0, true, false)
        SetEntityAsMissionEntity(spawnedVehicle, true, true)
        SetVehicleOnGroundProperly(spawnedVehicle)
        SetVehicleHasBeenOwnedByPlayer(spawnedVehicle, true)
        SetVehicleDirtLevel(spawnedVehicle, 0)

        -- Generate a random plate number
        local plateNumber = tostring(math.random(10000, 99999))
        SetVehicleNumberPlateText(spawnedVehicle, plateNumber)
        SetVehicleNumberPlateTextIndex(spawnedVehicle, 1)
        SetEntityAsNoLongerNeeded(spawnedVehicle)
        SetModelAsNoLongerNeeded(model)

        -- Put the player in the driver seat
        local playerPed = PlayerPedId()
        TaskWarpPedIntoVehicle(playerPed, spawnedVehicle, -1)
        --self.remote._setVehicleAsOwned(model, plateNumber, spawnedVehicle)
        print('set as owned.')
        vehicleSpawned = true
        break
      end
    end
    if vehicleSpawned then break end
  end
  if vehicleSpawned then return end
end

function Dealerships:test(self,model)
  print('testing tunnel', model)
end

--[[NUI EVENTS]]--

-- Changes vehicle
RegisterNUICallback('ChangeVehicle', function(data, cb)
  for index, dealership in pairs(cfg.dealerships) do
    for _, pos in pairs(dealership.positions) do
      local plcoords = GetEntityCoords(PlayerPedId())
      local nvehicle, vehicleCoords = lib.getClosestVehicle(plcoords, 5, false)

      if nvehicle then
        DeleteEntity(nvehicle)
      else
        vehicleCoords = pos
      end

      local model = GetHashKey(data.model)
      RequestModel(model)
      while not HasModelLoaded(model) do
        Wait(1)
      end

      local newVehicle = CreateVehicle(model, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, vehicleCoords.heading or pos.heading, true, false)
      SetModelAsNoLongerNeeded(model)
      cb('ok')
    end
  end
end)

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

Dealerships.tunnel={}
Dealerships.tunnel.spawnCar = Dealerships.spawnCar
Dealerships.tunnel.test = Dealerships.test
vRP:registerExtension(Dealerships)
