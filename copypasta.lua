-- copypasta v0.0.1
-- a simple demo script for copying
--
-- llllllll.co/t/copypasta
--
--
--
--    ▼ instructions below ▼
--
-- a simple demo

-- includes will include anything and everything
-- needed by the added classes
musicutil=require("musicutil")
lattice_=require("lattice")

-- OPINION: paging is done by having classes
-- for each page that has a "enc",
--"key", and "redraw" function
kick_=include("lib/kick")
synth_=include("lib/synth")
page_current=1
pages={}

-- OPINION: use "scinstaller" for managing 3rd party engines
--          this uses .gitmodules "scinstaller" to manage installation
installer_=include("lib/scinstaller/scinstaller")
installer=installer_:new{requirements={"Fverb"},zip="https://github.com/schollz/portedplugins/releases/download/v0.4.5/PortedPlugins-RaspberryPi.zip"}
engine.name=installer:ready() and 'CopyPasta' or nil

function init()
  -- check the installer
  if not installer:ready() then
    clock.run(function()
      while true do
        redraw()
        clock.sleep(1/5)
      end
    end)
    do return end
  end

  -- setup main parameters
  engine.set("main","secondsPerBeat",clock.get_beat_sec())
  local prams={
    {id="delayBeats",name="delay beats",min=0.25,max=32,exp=false,div=0.25,default=1,unit="beats"},
    {id="delayFeedback",name="delay feedback",min=0,max=1,exp=false,div=0.01,default=0.05},
  }
  params:add_group("MAIN",#prams)
  for _,pram in ipairs(prams) do
    local id="main_"..pram.id
    params:add{
      type="control",
      id=id,
      name=pram.name,
      controlspec=controlspec.new(pram.min,pram.max,pram.exp and "exp" or "lin",pram.div,pram.default,pram.unit or "",pram.div/(pram.max-pram.min)),
      formatter=pram.formatter,
    }
    params:set_action(id,function(x)
      engine.set("main",pram.id,x)
    end)
  end

  -- setup the paging by initializing the classes
  table.insert(pages,synth_:new())
  table.insert(pages,kick_:new())

  -- paging also sets up parameters
  -- so now we can bang them to initialize everything
  params:bang()

  -- OPINION: refresh the screen at 15 fps
  -- ALTERNATIVE: refresh the screen
  -- only when "dirty"
  clock.run(function()
    while true do
      clock.sleep(1/15)
      redraw()
    end
  end)

  -- setup lattice
  lattice=lattice_:new{
    auto=true,
    ppqn=96
  }

  -- make some sprockets
  sprocket=lattice:new_sprocket{
    action=function(t)
      for _,p in ipairs(pages) do
        p:emit()
      end
    end,
    division=1/16,
    enabled=true
  }
  lattice:start()
end

function key(k,z)
  if not installer:ready() then
    installer:key(k,z)
    do return end
  end
  if k>1 then
    pages[k-1]:key(k,z)
  end
end

function enc(k,d)
  if not installer:ready() then
    do return end
  end

  if k==1 then
    page_current=util.wrap(page_current+d,1,#pages)
  else
    pages[page_current]:enc(k,d)
  end
end

function redraw()
  if not installer:ready() then
    installer:redraw()
    do return end
  end

  screen.clear()

  pages[page_current]:redraw()

  screen.update()
end
