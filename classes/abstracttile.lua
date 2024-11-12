local AbstractTile = (require "libs.ext.classic"):extend()
local u = require "libs.util"


---creates an abstract tile object (no default coordinates, type, contents)
function AbstractTile:new()
    print("AbstractTile()")
    self.id = 0

    --print("abstracttile")
    --print(self.tesselation)

    --whether the tile's draw function should be called
    self.drawable = false

    --the game x-coordinate
    self.x = nil

    --the fraction of the x-coordinate (0..tesselation)
    self.dx = nil

    --the game y-coordinate
    self.y = nil 

    --the fraction of the y-coordinate (0..tesselation)
    self.dy = nil

    --the scale factor given to the draw function based on image size and tesselation
    self.scale = 1

    print("is theworld there? " .. tostring(TheWorld ~= nil))
    print("is tesselation there? " .. tostring(TheWorld.tesselation ~= nil))

    --the mathematical position = coordinate * tesselation
    self.pos = function()
        return {self.x * TheWorld.tesselation, self.y * TheWorld.tesselation}
    end

    --other properties of the tile (e.g. type, content)
    self.properties = {}


end

---add game coordinates to a tile after creation
---@param x number
---@param y number
---@param dx number
---@param dy number
function AbstractTile:setup(id, x, y, dx, dy)
    self.id = id
    self.x = x
    self.y = y
    self.dx = dx
    self.dy = dy
end


function AbstractTile:draw()
    if not self.drawable then return end

    u.pushColor()
        love.graphics.draw(self.img.obj, self.pos()[1] + self.x, self.pos()[2] + self.y, 0, self.scale, self.scale)

    u.popColor()
end

function AbstractTile:update(dt)
end

return AbstractTile