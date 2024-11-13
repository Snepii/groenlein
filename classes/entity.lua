local object = require "libs.ext.classic"
local entity = object:extend()

function entity:new(x, y, img_path)
    print("Entity()")

    --todo@Snepii #8 is this a sensible default?
    self.width = 0
    self.height = 0

    if img_path then
        print("fetching image " .. img_path)
        self.img = (require "classes.image")(img_path)
        print("done")
        self.width = self.img.width
        self.height = self.img.height
    end

    self.pos = {
        x = x,
        y = y,
        last = { x = x, y = y }
    }
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
    if self.pos then
        print("pos!")
    end

    if self.width then
        print("self width")
    end

    if e.width then
        print("e width")
    end

    return self.pos.x + self.width > e.pos.x
    and self.pos.x < e.pos.x + e.width
    and self.pos.y + self.height > e.pos.y
    and self.pos.y < e.pos.y + e.height
end

---how to handle collision
---@param e any
function entity:resolveCollision(e)
    if self.checkCollision then
        print("self!")
    end

    if entity.checkCollision then
        print("entity!")
    end

    if e.checkCollision then
        print("e!")
    end

    if self:checkCollision(e) then
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