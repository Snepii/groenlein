AssetHandler = { }

AssetHandler.Assets = {}


AssetHandler.LoadSpriteImage = function(asset_name, tile_size)
    ---load an asset by name only once
    if AssetHandler.Assets[asset_name] ~= nil then return end

    local img = love.graphics.newImage(GAMEPATH.TEXTURES .. asset_name .. ".png") --(require "classes.image")(GAMEPATH.TEXTURES .. asset_name)

    local quads = {}

    for y=0,img:getHeight()/tile_size-1 do
        quads[y] = {}
    for x=0,img:getWidth()/tile_size-1 do
            quads[y][x] = love.graphics.newQuad(x*tile_size,y*tile_size, tile_size, tile_size, img:getWidth(), img:getHeight())
        end
    end

    AssetHandler.Assets[asset_name] = {img = img, quads = quads}

    

end
--[[
AssetHandler.Test = function()
    local image = love.graphics.newImage(GAMEPATH.TEXTURES .. "testassets.png")
    for i=0,5 do
        for j=0,5 do
            table.insert(AssetHandler.Quads, i*)
        end
    end
end]]--