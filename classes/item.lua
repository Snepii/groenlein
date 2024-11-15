local Item = (require "libs.ext.classic"):extend()

function Item:new(name)
    self.name = name
    self.asset = Groenlein.AssetHandler.GetAll(name)
    self.stacksize = 30

end

---checks if two items are of the same kind
---@param item Groenlein.Classes.Item
function Item:equals(item)
    if self.name == item.name then
        return true
    else
        return false
    end
end

return Item