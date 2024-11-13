local GroundTile = (require "classes.abstracttile"):extend()
require "classes.types"

---creates a new ground object at the given game tile coordinate and given type (e.g. material) and variant (e.g. orientation)
---@param x number
---@param y number
---@param type any
---@param variant any
function GroundTile:new(x, y, type, variant)
    print("GroundTile()")
    --GroundTile.super.new(self, x, y, GAMEPATH.GROUND_TEXTURES .. type .. ".png")
    GroundTile.super.new(self, x, y, nil)

    self.width = 16
    AssetHandler.LoadSpriteImage(type, self.width)


    if type == nil then
        self.type = Types.Ground.Dirt
    else
        self.type = type
    end

    ---to pick the right quad
    self.variant = variant

    self.scale = TheWorld.Tessellation/self.width
    self.drawable = true


end

return GroundTile