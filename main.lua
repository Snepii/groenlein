io.stdout:setvbuf("no")

if arg[2] == "debug" then
    require("lldebugger").start()
end


-- static loads
require "libs.util"
require "classes.staticvalues"
require "classes.debugger"

print("loading world")
TheWorld = (require "classes.world")()
print("world there? " .. tostring(TheWorld ~= nil))
print("tesselation? " .. tostring(TheWorld.tesselation ~= nil))

print("loading player")
ThePlayer = (require "classes.player")()



function testMenu()

  local m = require "classes.menubutton"
  mn = m(0, "default", {0.5,0.5,1,1}, {1,0,1,1}, {0,0,0,1}, nil, "henloooo", 200, 30, 50)

  mn.Click = function ()
    mn.text = mn.text .."o"
  end

  -- style, main_color, hovor_color, text_color, img_path, text, width, height, r
  mn2 = m(1, "circular", {0.5,0.2,1,1}, {1,0.7,0.1,1}, {0,0,0,1}, nil, "yass", 200, 400, 50)
  mn2.Click = function ()
    mn2.text = mn2.text .. "s"
  end

  local menue = require "classes.menu"
  menu = menue(0, "testmenuuuuuu12", "vertical", {0, 0, 1,1}, 100, 50)

  mn3 = m(3, "default", {0.5,0.3,0.3,1}, {1,0.3,0.3,1}, {0,0,1,1}, nil, "add more",100, 200, 50)
  mn3.Click = function()
    local mn4 = m(4, "default", {1,0.5,1,1}, {1,0.75,0.75,1}, {0,0,0,1}, nil, "good", 100, 200, 50)
    menu:addButton(mn4)
  end

  menu:show()
  menu:updateSize()
  print("menuwidth1: " .. menu.width)
  menu:addButton(mn)
  menu:updateSize()
  print("menuwidht2: " .. menu.width)
  menu:addButton(mn2)
  menu:addButton(mn3)
end

function GameStart()
  OnTitleScreen = false
end

-- CALLBACKS-----------------------------------------------------------
function love.load()
  --testMenu()
  Debugger.cls()
  
  CallbackItems = { Update = {}, Draw = {}, Key = {}, Mouse = {}}

  AddCallback = function(item, update, draw, key, mouse)
    if update then
      table.insert(CallbackItems.Update, item)
    end

    if draw then
      table.insert(CallbackItems.Draw, item)
    end

    if key then
      table.insert(CallbackItems.Key, item)
    end

    if mouse then
      table.insert(CallbackItems.Mouse, item)
    end
  end



  AddCallback(TheWorld, true, true, false, false)

  AddCallback(ThePlayer, true, true, true, false)

  TheWorld:populate()

  OnTitleScreen = true
  -- do NOT add TitleMenu to Callback Table
  TitleMenu = (require "classes.titlemenu")()
  

end


function love.update(dt)
  Debugger.print("tick", TheWorld.Tick, 5)
  if OnTitleScreen then
    
    TitleMenu:update(dt)
    Debugger.draw()

    return
  end
  --menu:update()


  for _,item in pairs(CallbackItems.Update) do
    item:update(dt)
  end


end

function love.draw()
  if OnTitleScreen then
    TitleMenu:draw()
    return
  end

  for _,item in pairs(CallbackItems.Draw) do
    item:draw()
  end

  Debugger.draw()

end

function love.mousepressed(x,y,button,is_touch)
  for _,item in pairs(CallbackItems.Mouse) do
    item:mousepressed(x,y,button,is_touch)
  end
end

function love.mousereleased(x,y,button,is_touch)
  for _,item in pairs(CallbackItems.Mouse) do
    item:mousereleased(x,y,button,is_touch)
  end
end

function love.wheelmoved(x, y)
  for _,item in pairs(CallbackItems.Mouse) do
    item:wheelmoved(x, y)
  end
end

function love.keypressed(key, scan_code, is_repeat)
  for _,item in pairs(CallbackItems.Key) do
    item:keypressed(key, scan_code, is_repeat)
  end
end

function love.keyreleased(key,scan_code)
  for _,item in pairs(CallbackItems.Key) do
    if item.keyreleased ~= nil then
      item:keyreleased(key, scan_code)
    end
  end
end



function love.focus(f)
end
--e.g. function love.focus(f) gameIsPaused = not f end => in update: if gameIsPaused then return end

function love.quit()
end



local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end