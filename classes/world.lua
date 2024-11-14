

local World = (require "libs.ext.classic"):extend()

function World:new()
    print("World()")
    self.Ground = {}
    self.PreciseTick = 0
    self.Tick = 0
    --the size of a tile in pixel
    self.Tessellation = 64

    
end

function World:draw()
    --print("World:draw()")
    for _,g in pairs(self.Ground) do
        g:draw()
    end
end

function World:update(dt)
    --print("World:update()")
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
    print("World:populate()")
    local groundTile = Groenlein.Classes.GroundTile

    
    local count = 0
    for y=0,3 do
        for x=0,10 do
            local var = Groenlein.Util.ifelse(y==0, Groenlein.TypeSystem.Variants.Top, Groenlein.Util.ifelse(y==3, Groenlein.TypeSystem.Variants.Bottom, Groenlein.TypeSystem.Variants.Middle))
            var = Groenlein.Util.ifelse(x==0, var.Left, Groenlein.Util.ifelse(x==10, var.Right, var.Middle))
            local tile = groundTile(x+3, y+3, Groenlein.TypeSystem.Types.Ground.Dirt, var)
            --tile.walkable = false --Util.ifelse(y==1, true, false)
            tile.checkCollisionPlayer = Groenlein.Util.ifelse(y==0, true, false)
            table.insert(self.Ground, tile)
            count = count + 1
        end
    end
end

return World