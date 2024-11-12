

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
    --todo@Snepii #1 check out the tick library
    self.PreciseTick = (self.PreciseTick + dt)%60

    --todo@Snepii #3 defining tick like that is just seconds
    self.Tick = math.floor(self.PreciseTick)

    for _,g in pairs(self.Ground) do
        g:update(dt)
    end
end

--todo@Snepii #2 figure out how to generate the world
---just for the time being to see some world drawn
function World:populate()
    local groundTile = require "classes.groundtile"

    local count = 0
    for y=0,10 do
        for x=0,1 do
            local tile = groundTile(count, x+3, y+3, Util.ifelse(y==0, Types.Ground.Grass,Types.Ground.Rock))
            tile.walkable = Util.ifelse(y==0, true, false)
            tile.checkCollisionPlayer = Util.ifelse(y==0, true, false)
            table.insert(self.Ground, tile)
            count = count + 1
        end
    end
end

return World