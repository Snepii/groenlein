local MiniLevel = (require "libs.ext.classic"):extend()
--local Image = require "classes.image"

--todo@Snepii #11 change the signature, still have to look up that | stuff

---creates a new MiniLevel Object that will be rendered within the given size
---everything outside of it will be rendered with either a background color or image
---@param id string
---@param width integer
---@param height integer
---@param ... table "either Image object or background color as {r,g,b,{a}}; default is COLOR.Black"
function MiniLevel:new(id,width,height, ...)
    self.id = id
    
    assert(width ~= nil and width > 0 and height ~= nil and height>0, "no size specified")
    self.width = width
    self.height = height
    local args = {...}

    for _,p in pairs(args) do
        print(_,p)
    end

    if #args == 0 then
        args = COLOR.Black
    else
        args = args[1]
    end

    if args.is and args:is(Groenlein.Image) then
        self.background = args
        print("img")
    elseif type(args[1] == "number") and type(args[2]) == "number" 
                                     and type(args[3] == "number") then
        print("color")
        if #args == 3 then
            self.background = {args[1], args[2], args[3], 1}
        elseif #args == 4 and type(args[4]) == "number" then
            self.background = args
            error("no background specified", 3)

        end
    else
        error("no background specified", 3)
    end

    self.spawnpoint = {x=0,y=0}

    self.ground = { }

    local var, var2
    for y=0,self.height do
        if y == 0 then
            var = Groenlein.TypeSystem.Variants.Outer.Top
        elseif y == self.height then
            var = Groenlein.TypeSystem.Variants.Outer.Bottom
        else
            var = Groenlein.TypeSystem.Variants.Outer.Middle
        end

        for x=0,self.width do
            if x == 0 then
                var2 = var.Left
            elseif x==self.width then
                var2 = var.Right
            else
                var2 = var.Middle
            end
            table.insert(self.ground, Groenlein.Classes.GroundTile(x,y,Groenlein.TypeSystem.Types.Ground.Dirt, var2))
        end
    end

    print("finished MiniLevel()")
end

function MiniLevel:setSpawn(x,y)
    self.spawnpoint = {x=x,y=y}
end

function MiniLevel:draw()
    for _,g in pairs(self.ground) do
        g:draw()
    end
end


function MiniLevel:update()
end

return MiniLevel