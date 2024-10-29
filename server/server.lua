--original code at bottom
local htmlEntities = module("lib/htmlEntities")
local lang = vRP.lang
local radial_menu = class("radial_menu", vRP.Extension)
-- TUNNEL

function radial_menu:__construct()
  vRP.Extension.__construct(self)
end
-- Give nearest player money
function radial_menu:giveMoney()
  local user = vRP.users_by_source[source]
  local nplayer = vRP.EXT.Base.remote.getNearestPlayer(user.source, 10)

  if nplayer then
    local nuser = vRP.users_by_source[nplayer]
    if nuser then
      -- Prompt for amount
      local amount = parseInt(user:prompt(lang.money.give.prompt(), "")) or 0
      if amount > 0 and user:tryPayment(amount) then
        nuser:giveWallet(amount)
        vRP.EXT.Base.remote._notify(user.source, lang.money.given({amount}))
        vRP.EXT.Base.remote._notify(nuser.source, lang.money.received({amount}))
      else
        vRP.EXT.Base.remote._notify(user.source, lang.money.not_enough())
      end
    else
      vRP.EXT.Base.remote._notify(user.source, lang.common.no_player_near())
    end
  else
    vRP.EXT.Base.remote._notify(user.source, lang.common.no_player_near())
  end
end

-- Call admin to submit a report.
function radial_menu:callAdmin()
  local user = vRP.users_by_source[source]

  if not user:hasPermission("player.calladmin") then
    vRP.EXT.Base.remote._notify(user.source, "You do not have permission to call an admin.")
    return
  end

  local desc = user:prompt(lang.admin.call_admin.prompt(), "") or ""
  local answered = false

  local admins = {}
  for _, user in pairs(vRP.users) do
    if user:isReady() and user:hasPermission("admin.tickets") then
      table.insert(admins, user)
    end
  end

  for _, admin in pairs(admins) do
    async(function()
      local ok = admin:request(lang.admin.call_admin.request({user.id, htmlEntities.encode(desc)}), 60)
      if ok and not answered then
        answered = true
        vRP.EXT.Base.remote._notify(user.source, "An Admin has claimed your ticket.")
        vRP.EXT.Base.remote._teleport(admin.source, vRP.EXT.Base.remote.getPosition(user.source))
      elseif ok then
        vRP.EXT.Base.remote._notify(admin.source, "Ticket is already claimed.")
      end
    end)
  end
end

-- Check if player is police, and provide the menu if they are.
function radial_menu:isPolice()
  local users = vRP.users
  local group = vRP.EXT.Group:getUsersByGroup("police")
  for k, v in pairs(group) do
    if v.source == source then
      return true
    else
      return false
    end
  end
end

function radial_menu:Repair()
  local user = vRP.users_by_source[source]

  -- anim and repair
  if user:tryTakeItem("repairkit",1) then
    vRP.EXT.Base.remote._playAnim(user.source,false,{task="WORLD_HUMAN_WELDING"},false)
    SetTimeout(15000, function()
      self.remote._fixNearestVehicle(user.source,7)
      vRP.EXT.Base.remote._stopAnim(user.source,false)
    end)
  end
end


function radial_menu:store_weapons()
  local user = vRP.users_by_source[source]

  local weapons = vRP.EXT.PlayerState.remote.replaceWeapons(user.source, {})
  for k,v in pairs(weapons) do
    -- convert weapons to parametric weapon items
    user:tryGiveItem("wbody|"..k, 1)
    if v.ammo > 0 then
      user:tryGiveItem("wammo|"..k, v.ammo)
    end
  end
end

function radial_menu:identity()
  local user = vRP.users_by_source[source]

  local home = vRP.EXT.Home:getAddress(user.cid).home
  local phone = user.identity.phone
  local name = user.identity.firstname .. " " .. user.identity.name
  local job = user.cdata
  print('^8some data^0 '..home, name, phone)

  local groups = user:getGroupByType('job')
  print('^3some data^0 '..json.encode(groups))
end



radial_menu.tunnel = {}

radial_menu.tunnel.isPolice = radial_menu.isPolice
radial_menu.tunnel.callAdmin = radial_menu.callAdmin
radial_menu.tunnel.giveMoney = radial_menu.giveMoney
radial_menu.tunnel.Repair = radial_menu.Repair
radial_menu.tunnel.store_weapons = radial_menu.store_weapons
radial_menu.tunnel.identity = radial_menu.identity

vRP:registerExtension(radial_menu)
