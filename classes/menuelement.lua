local obj = require "libs.ext.classic"

local MenuElement = obj:extend()

---creates a new menu element 
---@param type string "rect|circle"
---@param ... number "width, height OR radius"
function MenuElement:new(type, x, y, ...)
    self.type = type
    self.x = x
    self.y = y
    local args = {...}
    if type == "rect" then
        self.width = args[1]
        self.height = args[2]
    elseif type == "circle" then
        self.radius = args[1]
    end

    self.stencil = function() MenuElement.draw(self,true) end
end


function MenuElement:draw(b)
    

    if self.type == "rect" then
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
        --print("drawing rect " .. self.x .. "," .. self.y .. "," .. self.width .. "," .. self.height)
    elseif self.type == "circle" then
        love.graphics.circle("fill", self.x, self.y, self.radius)
        --print("draw circle")
        if b then
           -- print("stencil circle called!")
        end
    end
end

---checks if menu element is hovered by cursor
---@param cX number "cursor X position"
---@param cY number "cursor Y position"
---@return boolean
function MenuElement:isHovered(cX, cY)
    if self.type == "rect" then
        return cX > self.x and cX < self.x + self.width and cY > self.y and cY < self.y + self.height
    elseif self.type == "circle" then
        return math.sqrt((self.x - cX)^2 + (self.y - cY)^2) < self.radius
    else return false
    end
end


return MenuElement