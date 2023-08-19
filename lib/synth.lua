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
  self.prams={
    {id="mix",name="mix",min=0,max=1,exp=false,div=0.01,default=1.0,unit="%",
    formatter=function(param) return string.format("%d%%",100*param:get()) end},
    {id="detune",name="detune",min=0,max=1,exp=false,div=0.01,default=0.4,unit="%",
    formatter=function(param) return string.format("%d%%",100*param:get()) end},
    {id="sendDelay",name="delay send",min=0,max=1,exp=false,div=0.01,default=0.1,unit="%",
    formatter=function(param) return string.format("%d%%",100*param:get()) end},
    {id="sendReverb",name="reverb send",min=0,max=1,exp=false,div=0.01,default=30,unit="%",
    formatter=function(param) return string.format("%d%%",100*param:get()) end},
  }
  params:add_group("SYNTH",#self.prams)
  for _,pram in ipairs(self.prams) do
    local id="synth_"..pram.id
    params:add{
      type="control",
      id=id,
      name=pram.name,
      controlspec=controlspec.new(pram.min,pram.max,pram.exp and "exp" or "lin",pram.div,pram.default,pram.unit or "",pram.div/(pram.max-pram.min)),
      formatter=pram.formatter,
    }
    params:set_action(id,function(x)
      engine.set("synth",pram.id,x)
    end)
  end
end

function Synth:emit()
  if self.armed then
    print("[kick] emit")
    engine.synth_on(self.armed)
    self.armed=nil
  end
end

function Synth:key(k,z)
  print("[synth] key",k,z)
  if z==1 then
    self.armed=32
  end
end

function Synth:enc(k,d)
end

function Synth:redraw()
  screen.move(64,32)
  screen.text("synth")
end

return Synth
