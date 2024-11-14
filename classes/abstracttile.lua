--todo@Snepii #4 should this be entity? for collision
local Tile = Groenlein.Classes.Entity:extend()
--local u = require "libs.util"


function Tile:new(x, y, img_path)
    Tile.super.new(self, x*Groenlein.TheWorld.Tessellation, y*Groenlein.TheWorld.Tessellation, img_path)

    --whether the tile's draw function should be called
    self.drawable = false

    --the scale factor given to the draw function based on image size and tessellation
    self.scale = 1

    --whether the player can walk over the tile
    self.walkable = true

    --other properties of the tile (e.g. type, content)
    self.properties = {}

    --whether player collision should be checked
    self.checkCollisionPlayer = false

    --whether entity collision should be checked
    self.checkCollisionEntity = false

end



function Tile:draw()
    if not self.drawable then return end

    PushColor()
        --love.graphics.draw(self.img.obj, self.pos.x, self.pos.y, 0, self.scale, self.scale)
      --love.graphics.draw(AssetHandler.Assets[self.type].img, AssetHandler.Assets[self.type].quads[0][self.variant], self.pos.x, self.pos.y, 0,self.scale,self.scale)
      local ass = Groenlein.AssetHandler.GetQuad(self.type, self.variant)  
      love.graphics.draw(ass.img, ass.quad, self.pos.x, self.pos.y, 0,self.scale,self.scale)
    PopColor()
end

---checks if the coordinates fall within the bounding box of the tile
---@param x number
---@param y number
---@return boolean
function Tile:boundingBox(x,y)
    local pos = self:getDrawPos()
    if pos == nil or pos.x == nil or pos.y == nil then
        Debugger.print("pos", "nil.", 5)
        return false
    else
        Debugger.print("pos", pos.x .."," ..pos.y,5)
    end
    --todo@Snepii #5 revisit the collision resolver
    return (x>pos.x and x< pos.x + Groenlein.TheWorld.Tessellation) ~= (y > pos.y and y < Groenlein.TheWorld.Tessellation)
end

function Tile:update(dt)
    if not self.walkable then
        return
    end
    if self.checkCollisionPlayer then
        local pX, pY = Groenlein.ThePlayer.pos.x, Groenlein.ThePlayer.pos.y
        local pW, pH = Groenlein.ThePlayer.width, Groenlein.ThePlayer.height


        print("self.width = " .. self.width)
        Groenlein.ThePlayer:resolveCollision(self)
        --[[if self:boundingBox(pX, pY) and self:boundingBox(pX + pW, pY + pH) then
            Groenlein.ThePlayer.pos.x = Groenlein.ThePlayer.pos.last.x
            Groenlein.ThePlayer.pos.y = Groenlein.ThePlayer.pos.last.y
        end]]--
    end

end

return Tile