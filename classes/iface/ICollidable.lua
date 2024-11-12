local ICollidable = (require "libs.ext.classic"):extend()

function ICollidable:implement(obj)
    self.obj = obj
end

function ICollidable:checkCollision(e)
end

function ICollidable:resolveCollision(e)
end

return ICollidable