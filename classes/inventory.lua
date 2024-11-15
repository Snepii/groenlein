local Inventory = (require "libs.ext.classic"):extend()

---creates an inventory object to store items 
---@param capacity integer
function Inventory:new(capacity)
    assert(capacity>=1, "inventory must be able to contain something")
    self.capacity = capacity
    self.storage = { }
    ---whether a single slot can hold multiple items of the same kind
    self.stackable = true
    self.empty = true
end

---tries to add an item to an inventory
---@param item Groenlein.classes.Item
---@return boolean "whether the item was added"
function Inventory:addItem(item)
    print("trying to add " .. item.name .. " to: ")
    self:print()
    if item == nil then
        print("item is nil")
        return false
    end

    if self.empty then
        print("inventory was empty")
        table.insert(self.storage, {item = item, amount = 1})
        self.empty = false
        return true
    end

    print("inventory was not empty")


    if self.stackable then
        print("inventory is stackable")
        for i,v in ipairs(self.storage) do
            if v.item:equals(item) then
                if v.amount < v.item.stacksize then
                    v.amount = v.amount + 1
                    return true
                end 
            end
        end
    end

    print("not stackable, stacks filled, or first of its kind")

    for i=1,self.capacity do
        if self.storage[i] == nil then
            self.storage[i] = {item=item,amount=1}
            return true
        end
    end

    print("found no empty slot")
    return false
end

---adds an item to a specified slot
---@param item Groenlein.classes.Item
---@param pos integer
---@return boolean
function Inventory:addItemPos(item, pos)
    if pos <1 or pos > self.capacity or item == nil then return false end

    if self.storage[pos] then
        if self.storage[pos].item:equals(item) then
            if not self.stackable then return false end

            if self.storage[pos].amount < item.stacksize then
                self.storage[pos].amount = self.storage[pos].amount + 1
                print("stack + 1")
                return false
            end
        else
            print("cannot stack " .. item.name .. " onto " .. self.storage[pos].item.name)
            return false
        end
    else
        self.storage[pos] = {item=item,amount=1}
        print("added new item")
        return true
    end

end

function Inventory:print()
    local s = ""

    for i=1,self.capacity do
        s = s .. "\n[" .. i .. "]: "

        if self.storage[i] then
             s = s .. self.storage[i].item.name .. " (" .. self.storage[i].amount .. "/"..self.storage[i].item.stacksize .. ")"
        else
            s = s .. "--"
        end
    end
    print(s)
end

function Inventory:takeItemPos(pos)
    if pos < 1 or pos > self.capacity then
        error("this shouldnt happen")
    end

    if self.storage[pos] then
        local itm = self.storage[pos].item
        if self.storage[pos].amount > 1 then
            self.storage[pos].amount = self.storage[pos].amount - 1
        else
            self.storage[pos] = nil
            --table.remove(self.storage, pos)
        end
        return itm
    else
        return nil
    end
end

function Inventory:takeItem(item)
    if not item:is(Groenlein.Classes.Item) then
        error("not an item")
    end

    local pos = 0
    for i,v in pairs(self.storage) do
        if v.item:equals(item) then
            pos = i
            break
        end
    end

    local itm = nil
    if pos ~= 0 then
        itm = self.storage[pos].item
        if self.storage[pos].amount > 1 then
            self.storage[pos].amount = self.storage[pos].amount - 1
        else
            table.remove(self.storage, pos)
        end
    end
    return itm
end


return Inventory