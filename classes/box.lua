local Box = Groenlein.Classes.Entity:extend()

function Box:new(x, y, capacity)
    Box.super.new(self, x, y, nil)

    self.asset = Groenlein.AssetHandler.GetAll("chest")
    self.opened = false
    self.variant = Groenlein.TypeSystem.Variants.Chest.Closed
    self.scale = 2
end

function Box:draw()
    PushColor()
        --local ass = Groenlein.AssetHandler.GetQuad(self.type, self.variant)  
        love.graphics.draw(self.asset.img, self.asset.quads[self.variant], self.pos.x, self.pos.y, 0,self.scale,self.scale)
    PopColor()
end

function Box:update()
    if self.opened then
        self.variant = Groenlein.TypeSystem.Variants.Chest.Opened
    else
        self.variant = Groenlein.TypeSystem.Variants.Chest.Closed
    end
end

function Box:keyreleased(key)
    if key == "e" and Groenlein.ThePlayer:checkDistance(self, self.scale * Groenlein.TheWorld.Tessellation) then
        self.opened = not self.opened
    end
end


return Box