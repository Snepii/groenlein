--local util = require "libs.util"
local Image = (require "libs.ext.classic"):extend()

function Image:new(path)
    self.path = path
    self.obj = love.graphics.newImage(Util.ifelsenil(path, GAMEPATH.TEXTURES .. "test.png"))
    self.width = self.obj:getWidth()
    self.height = self.obj:getHeight()

    print("Is self an instance of Image?", self:is(Image))

    -- Ensure 'is' is a function and returns expected results
    print("Type of self.is:", type(self.is))
    print("Self:is(Image):", self:is(Image))

    -- Optional: Assertion for automated feedback
    assert(self:is(Image), "Error: self should be an instance of Image")

    --self.updateImg(self, self.path)
end

--[[
function image:setImg(img_path)
    if img_path == nil then --img_path = "test.png" end
    print("no image path specified")
    else
        print("changing img from " .. util.ifelsenil(self.path, "nothing") .. " to " .. img_path)
        self.updatePath(self, img_path)
    end
end


function image:updatePath(img_path)
    --local ip = GAMEPATH.RES_PATH .. img_path

    local ip = img_path
    if util.file_exists(ip) then
        self.path = ip
        self.obj = love.graphics.newImage(ip)
        self.width = self.obj:getWidth()
        self.height = self.obj:getHeight()
    else
        error("img file doesnt exist: " .. ip, 2)
    end
end
]]--

return Image