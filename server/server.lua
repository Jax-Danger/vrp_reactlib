local Jax = class("Jax", vRP.Extension)
Jax.tunnel = {}

function Jax:__construct()
  vRP.Extension.__construct(self)
  print("started.")
end

function Jax:name(self)
  local user = vRP.users_by_source[source]
  if user then
    local name = user.cdata
    print("user", table.unpack(name))
    return name
  else
    vRP.EXT.Base.remote._notify(source, "something is very wrong here.")
  end
end
Jax.tunnel.name = Jax.name
vRP:registerExtension(Jax)
