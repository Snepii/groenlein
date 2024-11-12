local GroundTile = (require "classes.abstracttile"):extend()
require "classes.types"

---creates a new ground object at the given game coordinate and given type (e.g. material) and variant (e.g. orientation)
---@param x number
---@param y number
---@param type any
---@param variant any
function GroundTile:new(id, x, y, type, variant)
    self.super.new(self)
    self.super.setup(self,id,x,y)
    

    if type == nil then
        self.type = Types.Ground.Grass
    else
        self.type = type
    end

    self.variant = variant
    self.img = (require "classes.image")(GAMEPATH.GROUND_TEXTURES .. type .. ".png")

    self.scale = TheWorld.tessellation/self.img.width
    self.drawable = true

    --[[Debugger.hl(self.y*TheWorld.tessellation)
    Debugger.hl(self.y*TheWorld.tessellation + TheWorld.tessellation)
    Debugger.vl(self.x*TheWorld.tessellation)
    Debugger.vl(self.x *TheWorld.tessellation+TheWorld.tessellation)]]--
end

return GroundTile