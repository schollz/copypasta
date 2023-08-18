-- simple class for synth
local Kick={}

function Kick:new(args)
  -- metatable jargon
  local l=setmetatable({},{__index=Kick})
  local args=args==nil and {} or args
  l:init()
  return l
end

function Kick:init()

end

function Kick:key(k,z)
  print("[kick] key",k,z)
end

function Kick:enc(k,d)
end

function Kick:redraw()
end

return Kick
