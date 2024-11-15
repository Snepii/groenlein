local ItemEntity = Groenlein.Classes.Entity:extend()

---when an item is dropped to the ground
---@param item Groenlein.Classes.Item
---@param amount integer
function ItemEntity:new(item, amount, x, y)
    assert(amount > 0)
    self.super.new(self, "entity " ..item.id, x, y, GAMEPATH.TEXTURES .. item.id  .. ".png")
    self.item = item
    self.amount = amount
    self.setTile(self, x, y)
    self.pickUpDistance = Groenlein.TheWorld.Tessellation/2
end

function ItemEntity:update()
    ItemEntity.super.update(self)
    if Groenlein.ThePlayer:checkDistance(self, self.pickUpDistance) then
        Groenlein.ThePlayer:pickUp(self)
        print("marking " .. self.id .. " for deletion")
        self.markedForDeletion = true
    end
end

function ItemEntity:draw()
    --idk why but calling the super any other way doesnt have img 
    --self.super.draw(self)
    love.graphics.draw(self.img.obj, self.pos.x - self.width/2, self.pos.y-self.height/2)
    Groenlein.Debugger.circ(self.pos.x, self.pos.y, self.pickUpDistance)
end

return ItemEntity