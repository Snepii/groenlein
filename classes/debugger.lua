Debugger = {}
local u = require "libs.util"

Debugger.draw = function()
    u.pushColor()
    love.graphics.setColor(Debugger.color)
    local counter = 0
    for k,text in pairs(Debugger.text) do
        counter = counter + 1
        love.graphics.print(text.key .. ":" ..text.text, 20, 20 + text.size * counter, 0, text.size, text.size)
    end


    for _,e in pairs(Debugger.circle) do
        love.graphics.circle("line", e.x, e.y, 3)
    end

    for _,e in pairs(Debugger.hline) do
        love.graphics.line(0, e, love.graphics.getWidth(), e)
    end

    for _,e in pairs(Debugger.vline) do
        love.graphics.line(e, 0, e, love.graphics.getHeight())
    end
    u.popColor()

end

Debugger.print = function(id, txt, s)
    local idx = 0
    print("checking for id ".. id)
    for k,v in pairs(Debugger.text) do
        idx = idx + 1
        if v.key == id then
            print("found at " .. idx)
            table.remove(Debugger.text, idx)
            break
        end
    end
    print("inserting ")


    table.insert(Debugger.text, {key=id, text=txt, size=s})
end

Debugger.circ = function(x,y)
    table.insert(Debugger.circle, {x=x,y=y})
end

Debugger.hl = function(y)
    table.insert(Debugger.hline, y)
end

Debugger.vl = function(x)
    table.insert(Debugger.vline, x)
end

Debugger.cls = function()
    Debugger.color = {1,0,0,1}
    Debugger.circle = {}
    Debugger.text = {}
    Debugger.hline = {}
    Debugger.vline = {}
end