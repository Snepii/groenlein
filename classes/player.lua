local Player = (require "classes.entity"):extend()

function Player:new()
    print("Player()")
    Player.super.new(self, 5, 5, GAMEPATH.TEXTURES .. "player.png")
    self.move_up = false
    self.move_down = false
    self.move_left = false
    self.move_right = false

    self.currentFrame = 1

    --speed = pixels/second
    self.speed = TheWorld.Tessellation * 2.5

    self.asset = AssetHandler.GetAll("Run-Sheet")

    print("finished player")
end

function Player:draw()

    print("getting player assets")
    local frame = self.asset.quads[tostring(math.floor(self.currentFrame))]
    print("got player assets")
    local flip = Util.ifelse(self.pos.x > self.pos.last.x, 1, -1)
    love.graphics.draw(self.asset.img, frame, self.pos.x, self.pos.y, 0, 2*flip, 2, 32, 0)

end

local counter = 1
local triggered = false
function Player:update(dt)



    if self.pos.x - self.pos.last.x ~= 0 or self.pos.y - self.pos.last.y ~= 0 then
        print("!!!")
        self.currentFrame = self.currentFrame + 10*dt
    else
        print("???? " .. self.pos.x .. "/" .. self.pos.last.x .. ", " .. self.pos.y.. "/"..self.pos.last.y)
    end 
    if self.currentFrame >= 6 then
        self.currentFrame = 1
    end
    self.super.update(self, dt)
    
    

    if counter == TheWorld.Tick and not triggered then
        Debugger.circ(self.pos.x, self.pos.y)
        counter = counter+1
        triggered = true
    else 
        triggered = false
    end


    if self.move_up ~= self.move_down then
        self.pos.y = self.pos.y + Util.ifelse(self.move_up, -1, 1) * self.speed * dt
    end

    if self.move_left ~= self.move_right then
        self.pos.x = self.pos.x + Util.ifelse(self.move_left, -1, 1) * self.speed * dt
    end
end



function Player:keypressed(key, scan_code, is_repeat)
    if key == "w" then
        self.move_up = true
    elseif key == "s" then
        self.move_down = true
    elseif key == "a" then
        self.move_left = true
    elseif key == "d" then
        self.move_right = true
    end
end

function Player:keyreleased(key)
    if key == "w" then
        self.move_up = false
    elseif key == "s" then
        self.move_down = false
    elseif key == "a" then
        self.move_left = false
    elseif key == "d" then
        self.move_right = false
    end
end
return Player