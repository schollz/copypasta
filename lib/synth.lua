-- simple class for synth
local Synth={}

function Synth:new(o)
  o=o or {}
  setmetatable(o,self)
  self.__index=self
  o:init()
  return o
end

function Synth:init()

end

function Synth:key(k,z)
  print("[synth] key",k,z)
end

function Synth:enc(k,d)
end

function Synth:redraw()
end

return Synth
