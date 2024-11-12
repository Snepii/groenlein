

local World = (require "libs.ext.classic"):extend()

function World:new()
    print("World()")
    self.Ground = {}
    self.PreciseTick = 0
    self.Tick = 0
    --the size of a tile in pixel
    self.tessellation = 64

    
end

function World:draw()
    for _,g in pairs(self.Ground) do
        g:draw()
    end
end

function World:update(dt)
    self.PreciseTick = self.PreciseTick + dt
    self.Tick = math.floor(self.PreciseTick)

    for _,g in pairs(self.Ground) do
        g:update(dt)
    end
end

function World:populate()
    local groundTile = require "classes.groundtile"

    local count = 0
    for y=0,10 do
        for x=0,10 do
            table.insert(self.Ground, groundTile(count, x, y, Types.Ground.Grass))
            count = count + 1
        end
    end
end

return World