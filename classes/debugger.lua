Debugger = {}

---draws everything stored in the debugger to the screen
Debugger.draw = function()
    PushColor()
    love.graphics.setColor(Debugger.color)
    local counter = 0
    local lastsize = 0

    Util.push("font", love.graphics.getFont())
    love.graphics.setNewFont(12)
        for k,text in pairs(Debugger.text) do
            counter = counter + 1
            love.graphics.print("["..counter.."]:" .. text.key .. ":" ..text.text, 20, 20  * counter)--, 0, text.size, text.size)
        end
    --todo@Snepii #6 ideally pop("...") should not have to be followed by [1]    
    love.graphics.setFont(Util.pop("font")[1])

    for _,e in pairs(Debugger.circle) do
        love.graphics.circle("line", e.x, e.y, 3)
    end

    for _,e in pairs(Debugger.hline) do
        love.graphics.line(0, e, love.graphics.getWidth(), e)
    end

    for _,e in pairs(Debugger.vline) do
        love.graphics.line(e, 0, e, love.graphics.getHeight())
    end
    PopColor()

end

---stores a text in the debugger. will replace another text with same id
---@param id string
---@param txt string
Debugger.print = function(id, txt)
    local idx = 0
    --print("checking for id ".. id)
    for k,v in pairs(Debugger.text) do
        idx = idx + 1
        if v.key == id then
            --print("found at " .. idx)
            table.remove(Debugger.text, idx)
            break
        end
    end
    --print("inserting ")

    table.insert(Debugger.text, {key=id, text=txt})
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

--when loaded, clear debugger => sets empty default variables
Debugger.cls()