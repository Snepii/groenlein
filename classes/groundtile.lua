local GroundTile = Groenlein.Classes.AbstractTile:extend()
--require "classes.types"

---creates a new ground object at the given game tile coordinate and given type (e.g. material) and variant (e.g. orientation)
---@param x number
---@param y number
---@param type any
---@param variant any
function GroundTile:new(x, y, type, variant)
    print("GroundTile()")
    --GroundTile.super.new(self, x, y, GAMEPATH.GROUND_TEXTURES .. type .. ".png")
    GroundTile.super.new(self, x, y, nil)

    self.width = 32
    --AssetHandler.LoadSpriteImage(type, self.width)


    if type == nil then
        self.type = Groenlein.TypeSystem.Types.Ground.Dirt
    else
        self.type = type
    end

    ---to pick the right quad
    self.variant = variant

    self.asset = Groenlein.AssetHandler.GetQuad(self.type, self.variant)

    self.scale = Groenlein.TheWorld.Tessellation/self.width
    self.drawable = true


end

return GroundTile