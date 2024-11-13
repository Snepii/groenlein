local Player = (require "classes.entity"):extend()

function Player:new()
    print("Player()")
    Player.super.new(self, 5, 5, GAMEPATH.TEXTURES .. "player.png")
    self.move_up = false
    self.move_down = false
    self.move_left = false
    self.move_right = false

    --speed = pixels/second
    self.speed = TheWorld.tessellation * 2.5

end


local counter = 1
local triggered = false
function Player:update(dt)
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