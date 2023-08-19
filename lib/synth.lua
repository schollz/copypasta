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
  -- OPINION: set parameters using the control type while
  -- keeping all the parameters into an array.
  -- the parameter ids are pulled exactly as they are in the Engine to make
  -- it easy to "set" them using the generic engine.set function.
  self.params={
    {id="beats",name="sample length",min=1,max=64,exp=false,div=1,default=16,unit="beats"},
  }
  for _,pram in ipairs(self.params) do
    params:add{
      type="control",
      id=self.id..pram.id,
      name=pram.name,
      controlspec=controlspec.new(pram.min,pram.max,pram.exp and "exp" or "lin",pram.div,pram.default,pram.unit or "",pram.div/(pram.max-pram.min)),
      formatter=pram.formatter,
    }
  end
end

function Synth:key(k,z)
  print("[synth] key",k,z)
end

function Synth:enc(k,d)
end

function Synth:redraw()
end

return Synth
