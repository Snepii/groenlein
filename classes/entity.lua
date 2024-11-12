local object = require "libs.ext.classic"
local util = require "libs.util"
local entity = object:extend()

function entity:new(x, y, img_path)
    self.img = (require "classes.image")(img_path)

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


    

return entity