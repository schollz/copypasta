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

engine.name="CopyPasta"

function init()
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

end

function enc(k,d)

end

function redraw()
  screen.clear()

  screen.update()
end
