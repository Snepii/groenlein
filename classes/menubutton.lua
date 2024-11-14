local obj = require "libs.ext.classic"
local menubutton = obj:extend()
--local u = require "libs.util"
local element = Groenlein.Classes.MenuElement
--TODO: static id list?

function menubutton:new(id, style, main_color, hover_color, text_color, img_path, text, width, height, r)
    self.style = style
    self.id = id
    self.maincolor = main_color
    self.hovercolor = hover_color
    self.textcolor = text_color
    if img_path ~= nil then
        self.img = Groenlein.Image
        self.img:setImg(img_path)
    end
    self.x = 0
    self.y = 0

    self.r = r
    if style == "circular" then 
        self.width = 2*r
        self.height = 2*r
    else
        self.width = math.max(width,r)
        self.height = math.min(height,r)
    end 

    self.hovered = false
    self.elements = {}
    self.Click = function() end
    self.text = text
    self.font = love.graphics.newFont(24)
    self.increased = false

    
end

function menubutton:draw()
    --u.push("color", love.graphics.getColor())
    --u.pushColor()
        
        if self.hovered then
            love.graphics.setColor(self.hovercolor)
            if self.increased == false then
                self.increased = true
                if self.style == "circular" then 
                    self.elements[1].radius = self.r * 1.1
                end
            end
        else
            love.graphics.setColor(self.maincolor)
            if self.increased then
                self.increased = false
                if self.style == "circular" then
                    self.elements[1].radius = self.r
                end
            end
        end

        
        --[[for _,e in pairs(self.elements) do
            e:draw()
        end]]--

        --combine stencils of elements
        love.graphics.stencil(function() 
            for _,v in pairs(self.elements) do
                --print("stencel for " .. v.type)
                v:stencil()
                
            end
        end, "replace", 1) -- set property of stencil pixels


        --determine which stencil pixels to address
        love.graphics.setStencilTest("equal", 1)

        --draw "around" but only affect stencil pixels
        if self.style == "circular" then
            love.graphics.circle("fill", self.x, self.y, self.r * 1.1)
        else
            love.graphics.rectangle("fill", self.pts_outline[1][1], self.pts_outline[1][2],self.width + 2 * self.r, self.height + 2 * self.r)
        end

        

        if self.img ~= nil then
            --print("drawing image")
            love.graphics.draw(self.img.obj, self.x, self.y)
        end


        --reset stencil
        love.graphics.setStencilTest()

        PushColor()
       Groenlein.Util.push("font", love.graphics.getFont())

            love.graphics.setColor(self.textcolor)
            love.graphics.setFont(self.font)
            if self.style == "circular" then
                love.graphics.printf(self.text, self.x-self.r, self.y-self.font:getHeight()/2, self.r*2, "center")
            else
                love.graphics.printf(self.text, self.x, self.y + self.height/2 - self.font:getHeight()/2, self.width, "center")
            end
        PopColor()
        love.graphics.setFont(Groenlein.Util.pop("font")[1])

    --u.popColor()
end


local clickable = true
function menubutton:update(dt)

        self.elements = {}

        if self.style == "circular" then
            local circle = element("circle", self.x, self.y, self.r)
            table.insert(self.elements, circle)
            self.width = 2 * self.r
            self.height = 2 * self.r
        else 
            self.pts = {{self.x,self.y}, {self.x+self.width, self.y}, {self.x+self.width, self.y+self.height}, {self.x, self.y+self.height}}
            self.pts_outline = {{self.pts[1][1]-self.r,self.pts[1][2]-self.r}, {self.pts[2][1]+self.r,self.pts[2][2]-self.r}, {self.pts[3][1]+self.r, self.pts[3][2]+self.r}, {self.pts[4][1] - self.r, self.pts[4][2]+self.r}}

            local box1 = element("rect", self.pts[1][1], self.pts_outline[1][2], self.width , self.height + 2*self.r)
            table.insert(self.elements, box1)
            local box2 = element("rect", self.pts_outline[1][1], self.pts[1][2], self.width + 2*self.r, self.height)
            table.insert(self.elements, box2)
            for _,p in pairs(self.pts) do
                local circ = element("circle", p[1], p[2], self.r)
                table.insert(self.elements, circ)
        end
        
        
        end


    local cursorX, cursorY = love.mouse.getX(), love.mouse.getY()
        local bool = false
    for _,e in pairs(self.elements) do
        bool = bool or e:isHovered(cursorX, cursorY)
        --print("is hovered? " .. tostring(buf))
    end

    self.hovered = bool

    if self.hovered then 


        if clickable then
            if self.hovered and love.mouse.isDown(1) then
                clickable = false
                self.Click()
            end
        else
            if love.mouse.isDown(1) == false then
                clickable = true
            end
        end
    end

    --love.graphics.setColor(0.7, 0.2, 1)
    love.graphics.print(cursorX .. "\t" .. cursorY, 50, 50)
end


return menubutton