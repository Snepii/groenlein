local Item = (require "libs.ext.classic"):extend()

function Item:new(id, debug_tile_size)
    self.id = id
    self.asset = Groenlein.AssetHandler.GetAll(id, debug_tile_size)
    self.stacksize = 30

end

---checks if two items are of the same kind
---@param item Groenlein.Classes.Item
function Item:equals(item)
    if self.id == item.id then
        return true
    else
        return false
    end
end

return Item