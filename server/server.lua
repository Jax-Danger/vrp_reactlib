local lang = vRP.lang
local Luang = module("vrp", "lib/Luang")

local ReactLib = class("ReactLib", vRP.Extension)
ReactLib.event = {}
ReactLib.tunnel = {}

if not lib.checkDependency('vrp_reactlib', 'v1.0.0') then error() end

function ReactLib:__construct()
  vRP.Extension.__construct(self)

  -- load config
  self.cfg = module("vrp_reactlib", "cfg/cfg")
end

vRP:registerExtension(ReactLib)
