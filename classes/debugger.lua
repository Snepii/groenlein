local Debugger = {}

--todo@Snepii #13 debugger needs its own canvas


---function to only run test code and stop after;
---@param fct function
Debugger.intercept = function(fct, quit)
    print("intercepting")

    fct()

    print("intercept finished")

    if quit then
        print("quitting")
        love.event.quit()
    else
        print("continuing")
    end
end

---draws everything stored in the debugger to the screen
Debugger.draw = function()
    if not Debugger.Enabled then return end

    PushColor()
    love.graphics.setColor(Debugger.color)
    local counter = 0
    local lastsize = 0

   Groenlein.Util.push("font", love.graphics.getFont())
    love.graphics.setNewFont(12)
        for k,text in pairs(Debugger.text) do
            counter = counter + 1
            love.graphics.print("["..counter.."]:" .. text.key .. ":" ..text.text, 20, 20  * counter)--, 0, text.size, text.size)
        end
    --todo@Snepii #6 ideally pop("...") should not have to be followed by [1]    
    love.graphics.setFont(Groenlein.Util.pop("font")[1])

    for _,e in pairs(Debugger.circle) do
        if e.r then
            love.graphics.circle("line", e.x, e.y, e.r)
        else
            love.graphics.circle("line", e.x, e.y, 3)
        end
    end

    for _,e in pairs(Debugger.hline) do
        love.graphics.line(0, e, love.graphics.getWidth(), e)
    end

    for _,e in pairs(Debugger.vline) do
        love.graphics.line(e, 0, e, love.graphics.getHeight())
    end

    for _,e in pairs(Debugger.ticks.circs) do
        love.graphics.circle("line", e.x, e.y, 3)
    end
    PopColor()

    Debugger.clearTicks()
end


---enter a draw function that only draws when the game loop ticks
Debugger.tickCirc = function(x,y)
    table.insert(Debugger.ticks.circs,{x=x,y=y})
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

Debugger.pt = function(x,y)
    Debugger.circ(x,y,3)
end

Debugger.circ = function(x,y,r)
    table.insert(Debugger.circle,{x=x,y=y,r=r})
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
    Debugger.clearTicks()

end

Debugger.clearTicks = function()
    Debugger.ticks = {circs = {}}
end

--when loaded, clear debugger => sets empty default variables
Debugger.cls()


Debugger.Enabled = false
return Debugger