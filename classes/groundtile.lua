local GroundTile = (require "classes.abstracttile"):extend()
require "classes.types"

---creates a new ground object at the given game tile coordinate and given type (e.g. material) and variant (e.g. orientation)
---@param x number
---@param y number
---@param type any
---@param variant any
function GroundTile:new(x, y, type, variant)
    print("GroundTile()")
    GroundTile.super.new(self, x, y, GAMEPATH.GROUND_TEXTURES .. type .. ".png")


    if type == nil then
        self.type = Types.Ground.Grass
    else
        self.type = type
    end

    self.variant = variant
    --self.img = (require "classes.image")()

    self.scale = TheWorld.Tessellation/self.width
    self.drawable = true


    --[[Debugger.hl(self.y*TheWorld.tessellation)
    Debugger.hl(self.y*TheWorld.tessellation + TheWorld.tessellation)
    Debugger.vl(self.x*TheWorld.tessellation)
    Debugger.vl(self.x *TheWorld.tessellation+TheWorld.tessellation)]]--
end

return GroundTile