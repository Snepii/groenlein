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
Groenlein.Lume = require "libs.ext.lume"
Groenlein.Image = require "libs.image"

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
Groenlein.Classes.Box = require "classes.box"

Groenlein.Classes.Inventory = require "classes.inventory"
Groenlein.Classes.Item = require "classes.item"
Groenlein.Classes.ItemEntity = require "classes.itementity"



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


  --todo@Snepii #7 change
  --Groenlein.TheWorld:populate()

  OnTitleScreen = true


  -- do NOT add TitleMenu to Callback Table
  TitleMenu = Groenlein.Classes.TitleMenu()
  
  print("load sprite in main")
  Groenlein.AssetHandler.LoadSpriteImage("Run-Sheet")
  print("after loadsprite in main")



  --local level = (require "classes.minilevel")("test", 200, 200, {0.5,0.2,0.5,1})
  --local level2 = (require "classes.minilevel")("test2", 200, 200, (require "classes.image")(GAMEPATH.TEXTURES .. "undef.png"))
  local level3 = Groenlein.Classes.MiniLevel("test3", 3,3)
  AddCallback(level3, false, true, false, false)
  AddCallback(Groenlein.ThePlayer, true, true, true, false)

  level3:setSpawn(3,0)

  Groenlein.ThePlayer:travel(level3)

  Groenlein.AssetHandler.LoadSpriteImage("chest", 32)
  --Groenlein.AssetHandler.LoadSpriteImage("pickaxe", 32)
 -- Groenlein.AssetHandler.LoadSpriteImage("fishbone", 32)


  local chest = Groenlein.Classes.Box(5,10)
  AddCallback(chest, true, true,true, false)

  local inv = Groenlein.Classes.Inventory(2)
  inv.stackable = true
  inv:print()

  local itm = Groenlein.Classes.Item("fishbone")

  local itement = Groenlein.Classes.ItemEntity(itm, 1, 15, 10)

  AddCallback(itement, true, true, false, false)

end

local gc_draw = {}
local gc_update = {}

function gc()
  local idx = #gc_update
  if idx > 0 then
    for i=#CallbackItems.Update,1,-1 do
      if gc_update[idx] == i then
        table.remove(CallbackItems.Update, i)
        idx = idx-1
        if idx == 0 then break end
      end
    end
  end

  idx = #gc_draw
  if idx > 0 then
    for i=#CallbackItems.Draw,1,-1 do
      if gc_update[idx] == i then
        table.remove(CallbackItems.Draw, i)
        idx = idx-1
        if idx == 0 then break end
      end
    end
  end

  
end

function love.update(dt)
  Groenlein.Debugger.print("tick", Groenlein.TheWorld.Tick)

  if OnTitleScreen then    
    TitleMenu:update(dt)
    Groenlein.Debugger.draw()
    return
  end
  --menu:update()

  for _,item in pairs(CallbackItems.Update) do
    item:update(dt)
    if item.markedForDeletion then
      print("item marked for update deletion at pos " .. _)
      table.insert(gc_update, _)
    end
  end


  gc()


end


function love.draw()





  if OnTitleScreen then
    TitleMenu:draw()
    return
  end

  for _,item in pairs(CallbackItems.Draw) do
      if item.draw then
        item:draw()
        if item.id == "entity fishbone" then
          print("stop")
        end
        if item.markedForDeletion then
          table.insert(gc_draw, _)
      print("item marked for draw deletion at pos " .. _)

        end
      else
        print(item.name .. " doesnt have a draw function")
      end
  end
  gc()

  Groenlein.Debugger.draw()

end

function love.mousepressed(x,y,button,is_touch)
  for _,item in pairs(CallbackItems.Mouse) do
    if item.mousepressed then
      item:mousepressed(x,y,button,is_touch)
    end
  end
end

function love.mousereleased(x,y,button,is_touch)
  for _,item in pairs(CallbackItems.Mouse) do
    if item.mousereleased then
      item:mousereleased(x,y,button,is_touch)
    end
  end
end

function love.wheelmoved(x, y)
  for _,item in pairs(CallbackItems.Mouse) do
    if item.wheelmoved then
      item:wheelmoved(x, y)
    end
  end
end

function love.keypressed(key, scan_code, is_repeat)
  for _,item in pairs(CallbackItems.Key) do
    if item.keypressed then
      item:keypressed(key, scan_code, is_repeat)
    end
  end
end

function love.keyreleased(key,scan_code)
  if key == "f" then
    Groenlein.Debugger.Enabled = not Groenlein.Debugger.Enabled
    --print("debug: " .. tostring(Groenlein.Debugger.Enabled))
  end

  for _,item in pairs(CallbackItems.Key) do
    if item.keyreleased then
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