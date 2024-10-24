---@param action string The action you wish to target
---@param data any The data you wish to send along with this action
function SendReactMessage(action, data)
  SendNUIMessage({
    action = action,
    data = data
  })
end

function toggleNuiFrame(shouldShow)
  SetNuiFocus(shouldShow, shouldShow)
  SendReactMessage("setVisible", shouldShow)
end

RegisterNetEvent("SendReactMessage")
AddEventHandler("SendReactMessage", function(action, data)
  SendNUIMessage({
    action = action,
    data = data
  })
  toggleNuiFrame(true)
  print("Show NUI frame")
  local success = lib.notify({title = "NUI", description = "Nui Has Been Sent Successfully.", type = "success"})
end)

RegisterNUICallback("hideFrame", function(_, cb)
  toggleNuiFrame(false)
  print("Hide NUI frame")
  cb({})
end)

function Draw3DText(x, y, z, text)
  local onScreen, _x, _y = World3dToScreen2d(x, y, z)
  local px, py, pz = table.unpack(GetGameplayCamCoord())
  local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)
  local scale = (1 / dist) * 2
  local fov = (1 / GetGameplayCamFov()) * 100
  local scale = scale * fov
  if onScreen then
    SetTextScale(0.0, 1)
    SetTextFont(5)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextDropshadow(0, 0, 0, 0, 55)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
  end
end
local center = vec3(158.8961, -460.7508, 41.8907)

RegisterNUICallback("startTimer", function()
  startTimer()
end)
function startTimer()
  local timer = lib.timer(15000, nil, false)
  Citizen.CreateThread(function()
    while true do
      print("Time Left: " .. timer:getTimeLeft("m"))
      Citizen.Wait(1000)
    end
  end)
  Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)
      Draw3DText(center.x, center.y, center.z, "Time Left: " .. timer:getTimeLeft("m"))
    end
  end)
end
