-- ctrl shift b to run build task

-- love.math.random is better seeded than luas
-- camera libs: Gamera, Stalker-X
-- better collision handling: Bump, HC
-- serialization and other stuff: lume


io.stdout:setvbuf("no")

if arg[2] == "debug" then
    require("lldebugger").start()
end

-- global loads & fields
Groenlein = {}
Groenlein.StaticValues = require "classes.staticvalues"
Groenlein.TypeSystem = require "classes.typesystem"
Groenlein.Util = require "libs.util"
Groenlein.UpdateView = require "updateview"
Groenlein.Debugger = require "classes.debugger"
Groenlein.JSON = require "libs.ext.json"
Groenlein.Image = require "classes.image"

Groenlein.AssetHandler = require "classes.assethandler"

Groenlein.Classes = {}
Groenlein.Classes.Menu = require "classes.menu"
Groenlein.Classes.MenuElement = require "classes.menuelement"
Groenlein.Classes.MenuButton = require "classes.menubutton"
Groenlein.Classes.TitleMenu = require "classes.titlemenu"

Groenlein.Classes.Entity = require "classes.entity"


Groenlein.Classes.AbstractTile = require "classes.abstracttile"
Groenlein.Classes.GroundTile = require "classes.groundtile"
Groenlein.Classes.MiniLevel = require "classes.minilevel"


Groenlein.TheWorld = (require "classes.world")()
Groenlein.ThePlayer = (require "classes.player")()





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

  AddCallback(Groenlein.TheWorld, true, true, false, false)
  AddCallback(Groenlein.ThePlayer, true, true, true, false)


  --todo@Snepii #7 change
  Groenlein.TheWorld:populate()

  OnTitleScreen = true


  -- do NOT add TitleMenu to Callback Table
  TitleMenu = Groenlein.Classes.TitleMenu()
  
  print("load sprite in main")
  Groenlein.AssetHandler.LoadSpriteImage("Run-Sheet", 64)
  print("after loadsprite in main")



  --local level = (require "classes.minilevel")("test", 200, 200, {0.5,0.2,0.5,1})
  --local level2 = (require "classes.minilevel")("test2", 200, 200, (require "classes.image")(GAMEPATH.TEXTURES .. "undef.png"))
  local level3 = Groenlein.Classes.MiniLevel("test3", 200, 200)
end


function love.update(dt)
  Debugger.print("tick", Groenlein.TheWorld.Tick)

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