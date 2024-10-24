local Jax = class("Jax", vRP.Extension)
Jax.tunnel = {}

function Jax:__construct()
  vRP.Extension.__construct(self)
  print("ready...")

  RegisterCommand("show-nui", function()
    local user = self.remote.name(self)
    print("user", table.unpack(user))
    TriggerEvent("SendReactMessage", "setPlayerName", {playerName = "nil"})
  end)
end

vRP:registerExtension(Jax)
