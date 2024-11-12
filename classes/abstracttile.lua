--todo@Snepii #4 should this be entity?
local AbstractTile = (require "libs.ext.classic"):extend()
--local u = require "libs.util"


---creates an abstract tile object (no default coordinates, type, contents)
function AbstractTile:new()
    print("AbstractTile()")
    self.id = 0

    --print("abstracttile")
    --print(self.tessellation)

    --whether the tile's draw function should be called
    self.drawable = false

    --the game x-coordinate
    self.x = nil

    --the fraction of the x-coordinate (0..tessellation)
    self.dx = nil

    --the game y-coordinate
    self.y = nil 

    --the fraction of the y-coordinate (0..tessellation)
    self.dy = nil

    --the scale factor given to the draw function based on image size and tessellation
    self.scale = 1

    --whether the player can walk over the tile
    self.walkable = true

    --other properties of the tile (e.g. type, content)
    self.properties = {}

    --whether player collision should be checked
    self.checkCollisionPlayer = true

    --whether entity collision should be checked
    self.checkCollisionEntity = false

end

---the mathematical position = coordinate * tessellation
---@return table
function AbstractTile:getPos()
    return {x = self.x * TheWorld.tessellation, y= self.y * TheWorld.tessellation}
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

    PushColor()
        local p = self:getPos()
        love.graphics.draw(self.img.obj, p.x + self.x, p.y + self.y, 0, self.scale, self.scale)

    PopColor()
end

---checks if the coordinates fall within the bounding box of the tile
---@param x number
---@param y number
---@return boolean
function AbstractTile:boundingBox(x,y)
    local pos = self:getPos()
    if pos == nil or pos.x == nil or pos.y == nil then
        Debugger.print("pos", "nil.", 5)
        return false
    else
        Debugger.print("pos", pos.x .."," ..pos.y,5)
    end
    --todo@Snepii #5 revisit the collision resolver
    return (x>pos.x and x< pos.x + TheWorld.tessellation) ~= (y > pos.y and y < TheWorld.tessellation)
end

function AbstractTile:update(dt)
    if self.checkCollisionPlayer then
        local pX, pY = ThePlayer.pos.x, ThePlayer.pos.y
        local pW, pH = ThePlayer.img.width, ThePlayer.img.height

        if self:boundingBox(pX, pY) and self:boundingBox(pX + pW, pY + pH) then
            ThePlayer.pos.x = ThePlayer.pos.last.x
            ThePlayer.pos.y = ThePlayer.pos.last.y
        end
    end
end

return AbstractTile