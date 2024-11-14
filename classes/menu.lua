local obj = require "libs.ext.classic"
local Menu = obj:extend()
--local u = require "libs.util"

---comment
---@param id any
---@param header any
---@param layout any
---@param backcolor any
---@param x any
---@param y any
function Menu:new(id, header, layout, backcolor, x, y, textcolor)
    self.buttons = {}
    self.header = header
    self.x = x
    self.y = y
    self.shown = false
    self.width = 0
    self.height = 0
    self.layout = layout
    if textcolor == nil then
        self.textcolor = COLOR.Black
    else
        self.textcolor = textcolor
    end
    self.backcolor=backcolor
    self.margin = 10 -- included in width and height!
    self.font = love.graphics.newFont(30)

    print("setting up menu: " ..header .. "," .. layout .. "," .. #backcolor .. "," .. x..","..y..","..#textcolor)
end

function Menu:show()
    self.shown = true
end

function Menu:hide()
    self.shown = false
end

function Menu:addButton(btn)
    table.insert(self.buttons, btn)
end


function Menu:updateSize()
    local maxWidth = self.font:getWidth(self.header)
    --if self.width == 0 or self.height == 0 then
        self.height = self.margin * 2 + self.font:getHeight()
        for _,e in pairs(self.buttons) do
            maxWidth = math.max(maxWidth, e.width + 2 * e.r)
            --print("checking " .. maxWidth .. " vs " .. e.width)
            if e.style == "circular" then
                self.height = self.height + e.height + self.margin
            else
                self.height = self.height + e.height + 2* self.margin + 2 * e.r
            end
        end
    --end
    --print("menuwidth3 " .. self.width)
    self.width = maxWidth + 2*self.margin
    --print("menuwidth4 " .. self.width)
    --print(maxWidth .. ", " .. self.margin .. ", " .. self.font:getWidth(self.header))
end


function Menu:draw()
    if self.shown == false then
        return
    end

    PushColor()
        love.graphics.setColor(self.backcolor)
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
        
        PushColor()
            love.graphics.setColor(self.textcolor)
           Groenlein.Util.push("font", love.graphics.getFont())
                love.graphics.setFont(self.font)
                love.graphics.printf(self.header, self.x,self.y + self.margin, self.width, "center")
            love.graphics.setFont(Groenlein.Util.pop("font")[1])
        PopColor()


        if self.layout=="vertical" then
            self:updateSize()

            --love.graphics.circle("line", self.x, self.y + self.height+10, 3)
            --love.graphics.circle("line", self.x+self.margin, self.y + self.height+20, 3)
            --love.graphics.circle("line", self.x + maxWidth, self.y + self.height + 30, 3)
            --love.graphics.circle("line", self.x+self.width, self.y + self.height + 40, 3)




            
            for i,e in ipairs(self.buttons) do
                e.x = self.x + self.width/2 - e.width/2
                if e.style == "circular" then
                    e.x = e.x + e.r
                end
                --print(e.style .. ", e.x=" .. e.x .. "=" .. self.x .. "+" .. self.width/2 .. "-" .. e.width/2)
                
                if i > 1 then
                    if self.buttons[i-1].style == "circular" then 
                        e.y = self.buttons[i-1].y + self.buttons[i-1].height + self.margin
                    else
                        e.y = self.buttons[i-1].y + self.buttons[i-1].height + self.margin + e.r*2
                    end
                else
                    
                    e.y = self.y + self.margin * 2 + self.font:getHeight()  + e.height/2 + e.r

                end
                e:draw()
            end
    PopColor()
    end


    

--    u.popColor()
end

function Menu:update(dt)
    for _,e in pairs(self.buttons) do
        e:update()
    end
end

return Menu