local MiniLevel = (require "libs.ext.classic"):extend()


--todo@Snepii #11 change the signature, still have to look up that | stuff

---creates a new MiniLevel Object that will be rendered within the given size
---everything outside of it will be rendered with either a background color or image
---@param id string
---@param width integer
---@param height integer
---@param ... table "either Image object or background color as {r,g,b,a}"
function MiniLevel:new(id,width,height, ...)
    self.id = id
    self.width = width
    self.height = height
    local args = {...}
    if args.is and args:is(Image) then
        self.background = args
    elseif args.r and args.g and args.b and args.a then
        self.background = args
    else
        error("no background specified", 2)
    end

end

return MiniLevel