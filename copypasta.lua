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
musicutil=require("MusicUtil")

engine.name="CopyPasta"

-- OPINION: paging is done by having classes
-- for each page that has a "enc",
--"key", and "redraw" function
kick_=include("lib/kick")
synth_=include("lib/synth")
page_current=1
pages={}

function init()
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
end

function key(k,z)
  pages[page_current]:key(k,z)
end

function enc(k,d)
  if k==1 then
    page_current=util.wrap(page_current+d,1,#pages)
  else
    pages[page_current]:enc(k,d)
  end
end

function redraw()
  screen.clear()

  pages[page_current]:redraw()

  screen.update()
end
