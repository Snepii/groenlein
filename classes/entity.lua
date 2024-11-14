local object = require "libs.ext.classic"
local entity = object:extend()

function entity:new(x, y, img_path)
    print("Entity()")

    --todo@Snepii #8 is this a sensible default?
    self.width = 0
    self.height = 0

    --todo@Snepii #9 see if theres a point in picking one over the other here
    if img_path ~= nil and Groenlein.AssetHandler.Assets[string.gsub(img_path, "/", ".")] ~= nil then
        
    else

        if img_path then
            print("fetching image " .. img_path)
            self.img = Groenlein.Image(img_path)
            print("done")
            self.width = self.img.width
            self.height = self.img.height
        end
    end

    self.pos = {
        x = x,
        y = y,
        last = { x = x, y = y }
        --tile = { x = function() return x / Groenlein.TheWorld.Tesselation end,
           --      y = function() return y / Groenlein.TheWorld.Tesselation end}
    }

    self.variant = Groenlein.TypeSystem.Variants.Default

    self.collisionStrength = 0

    print("finished Entity()")
end

function entity:setTile(x,y)
    self.pos.x = (x + 0.5) * Groenlein.TheWorld.Tessellation
    self.pos.y = (y + 0.5) * Groenlein.TheWorld.Tessellation
end

function entity:getTile()
    return {x=math.floor(self.pos.x/Groenlein.TheWorld.Tessellation), y=math.floor(self.pos.y/Groenlein.TheWorld.Tessellation)}
end

function entity:update(dt)
    self.pos.last.x = self.pos.x
    self.pos.last.y = self.pos.y

end

function entity:draw()
    love.graphics.draw(self.img.obj, self.pos.x, self.pos.y)
end



---basic rectangular collision check
---@param e any
---@return boolean
function entity:checkCollision(e)

    return self.pos.x + self.width > e.pos.x
    and self.pos.x < e.pos.x + e.width
    and self.pos.y + self.height > e.pos.y
    and self.pos.y < e.pos.y + e.height
end

---how to handle collision
---@param e any
function entity:resolveCollision(e)
    if self.collisionStrength > e.collisionStrength then
        e:resolveCollision(self)
        return
    end

    --print("checking collision: " .. tostring(check))
    if self:checkCollision(e) then
        --print("pushing back")
        if self:wasVerticallyAligned(e) then
            if self.pos.x + self.width/2 < e.pos.x + e.width/2  then
                -- pusback = the right side of the player - the left side of the wall
                local pushback = self.pos.x + self.width - e.pos.x
                self.pos.x = self.pos.x - pushback
            else
                -- pusback = the right side of the wall - the left side of the player
                local pushback = e.pos.x + e.width - self.pos.x
                self.pos.x = self.pos.x + pushback
            end
        elseif self:wasHorizontallyAligned(e) then
            if self.pos.y + self.height/2 < e.pos.y + e.height/2 then
                -- pusback = the bottom side of the player - the top side of the wall
                local pushback = self.pos.y + self.height - e.pos.y
                self.pos.y = self.pos.y - pushback
            else
                -- pusback = the bottom side of the wall - the top side of the player
                local pushback = e.pos.y + e.height - self.pos.y
                self.pos.y = self.pos.y + pushback
            end
        end
    end
end


function entity:wasVerticallyAligned(e)
    return self.pos.last.y < e.pos.last.y + e.height and self.pos.last.y + self.height > e.pos.last.y
end

function entity:wasHorizontallyAligned(e)
    return self.pos.last.x < e.pos.last.x + e.width and self.pos.last.x + self.width > e.pos.last.x
end

return entity