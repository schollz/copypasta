-- simple class for synth
local Synth={}

function Synth:new(args)
  -- metatable jargon
  local l=setmetatable({},{__index=Synth})
  local args=args==nil and {} or args
  l:init()
  return l
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
