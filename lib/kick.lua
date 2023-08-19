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
  self.params={
    {id="note",name="note",min=10,max=120,exp=false,div=1,default=32,
    formatter=formatter=function(param) return musicutil.note_num_to_name(param:get(),true) end},
    {id="predb",name="preamp",min=-96,max=16,exp=false,div=0.1,default=0,unit="dB"},
    {id="db",name="postamp",min=-96,max=16,exp=false,div=0.1,default=0,unit="dB"},
    {id="ratio",name="ratio",min=1,max=20,exp=false,div=1,default=6},
    {id="sweeptime",name="sweep time",min=0,max=0.2,exp=false,div=0.01,default=0.05,unit="s"},
    {id="decay1",name="decay1",min=0.005,max=2,exp=false,div=0.01,default=0.3,unit="s"},
    {id="decay1L",name="decay1L",min=0.005,max=2,exp=false,div=0.01,default=0.8,unit="s"},
    {id="decay2",name="decay2",min=0.005,max=2,exp=false,div=0.01,default=0.15,unit="s"},
    {id="clicky",name="clicky",min=0,max=1,exp=false,div=0.01,default=0,unit="%",
    formatter=function(param) return string.format("%d%%",100*param:get()) end},
    {id="sendDelay",name="delay send",min=0,max=1,exp=false,div=0.01,default=0,unit="%",
    formatter=function(param) return string.format("%d%%",100*param:get()) end},
    {id="sendReverb",name="reverb send",min=0,max=1,exp=false,div=0.01,default=0,unit="%",
    formatter=function(param) return string.format("%d%%",100*param:get()) end},
  }
  params:add_group("KICK",#self.params)
  for _,pram in ipairs(self.params) do
    local id="kick_"..pram.id
    params:add{
      type="control",
      id=id,
      name=pram.name,
      controlspec=controlspec.new(pram.min,pram.max,pram.exp and "exp" or "lin",pram.div,pram.default,pram.unit or "",pram.div/(pram.max-pram.min)),
      formatter=pram.formatter,
    }
    params:set_action(id,function(x)
      engine.set("kick",pram.id,x)
    end)
  end
end

function Kick:emit()
  print("[kick] emit")
  engine.kick_on()
end

function Kick:key(k,z)
  print("[kick] key",k,z)
end

function Kick:enc(k,d)
end

function Kick:redraw()
  screen.move(64,32)
  screen.text("kick")
end

return Kick
