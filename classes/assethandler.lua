local AssetHandler = { }

AssetHandler.Assets = {
    undefined = {
        img = love.graphics.newImage(GAMEPATH.TEXTURES .. "undef.png"),
        tile_size = 16,
        quad = love.graphics.newQuad(0, 0, 16, 16, 0, 0)
    }
}


---
---Asset Structure:
---Assets = {
---     Type = {
---         img,
---         quads = {
---             Variant = quad
---         }
---     }
---
---}
---
---


---this will only be used for creation of helper asset.json and asset_grid.png
---files and not in release
---as release will readily use those files
---@param name string
---@param tile_size number
local function createAssetJson(name, tile_size)
    local qds = {}
    local asset_obj = AssetHandler.Assets[name]

    ---creating a canvas to copy the asset image and apply grid
    local canvas = love.graphics.newCanvas(asset_obj.img:getWidth(), asset_obj.img:getHeight())
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    love.graphics.draw(asset_obj.img, 0, 0)

    PushColor()
        ---red grid lines
        love.graphics.setColor(1,0,0,1)
        for y=0,asset_obj.img:getHeight()/tile_size-1 do
            for x=0,asset_obj.img:getWidth()/tile_size-1 do
                ---creates a table that assigns tile (x,y) the
                ---default variant
                table.insert(qds, {y=y,x=x,var=Variants.Default})

                if x == 0 then
                    love.graphics.print(y, tile_size/2, tile_size/2 + tile_size * y)
                elseif y == 0 then
                    love.graphics.print(x, tile_size/2 + tile_size * x, tile_size/2)
                end
                    love.graphics.line(x*tile_size, 0, x*tile_size, asset_obj.img:getHeight())

            end
            love.graphics.line(0, y*tile_size, asset_obj.img:getWidth(), y*tile_size)
        end
    PopColor()

    ---draw the image and save to file
    love.graphics.setCanvas()
    local imgData = canvas:newImageData()
    local fileData = imgData:encode("png"):getString()
    Groenlein.Util.writeFile(GAMEPATH.TEXTURES .. name .. "_grid.png", fileData, "wb")

    ---write the json file
    local out = Groenlein.JSON.encode({quads=qds,tile_size=tile_size})
    Groenlein.Util.writeFile(GAMEPATH.TEXTURES .. name .. ".json", out)
end

---loads asset.json and assigns variants to coordinates
---removes undefined types
local function loadAssetJson(asset_name)


    local js = Groenlein.Util.readFile(GAMEPATH.TEXTURES .. asset_name .. ".json")
    local t = Groenlein.JSON.decode(js)
    local asset = {tile_size = t.tile_size}

    for i,p in ipairs(t.quads) do
        if p.var ~= Groenlein.TypeSystem.Variants.Default then
            if not asset[p.y] then 
                asset[p.y] = {}
            end
            asset[p.y][p.x] = p.var
            --table.insert(asset, {x=p.x,y=p.y,var=p.var})
        end
    end

    return asset
end


AssetHandler.LoadSpriteImage = function(asset_name, none, debug_tile_size)
    ---load an asset by name only once
    if AssetHandler.Assets[asset_name] ~= nil then return end

    local img = love.graphics.newImage(GAMEPATH.TEXTURES .. asset_name .. ".png") --(require "classes.image")(GAMEPATH.TEXTURES .. asset_name)
    AssetHandler.Assets[asset_name] = {img = img}

    local quadMetaData = {}
    
    ---check for asset.json and load or create
    if Groenlein.Util.file_exists(GAMEPATH.TEXTURES .. asset_name .. ".json") then
        quadMetaData = loadAssetJson(asset_name)
    else
        createAssetJson(asset_name, debug_tile_size)
    end
    
    --todo@Snepii #10 texture bleeding?

    local quads = {}
    local tile_size =quadMetaData.tile_size
    for y=0,img:getHeight()/tile_size-1 do
        --quads[y] = {}
        local quadY = quadMetaData[y] or Groenlein.TypeSystem.Variants.Default
        for x=0,img:getWidth()/tile_size-1 do
            local var = quadY[x] or Groenlein.TypeSystem.Variants.Default
            quads[var] =love.graphics.newQuad(x*tile_size,y*tile_size, tile_size, tile_size, img:getWidth(), img:getHeight())
        end
    end


    --AssetHandler.Assets[asset_name] = {img = img, quads = quads}
    AssetHandler.Assets[asset_name].quads = quads
    --createAssetJson(asset_name, tile_size)
    

end

---returns all quads of an asset
---@param asset_name any "can be for example tile.type or character"
---@return table "{img, quads = {var1, var2, ...}}"
AssetHandler.GetAll = function(asset_name)
    local obj = AssetHandler.Assets[asset_name]

    if obj then
        return obj
    else
        print("asset " .. asset_name .. " doesnt exist, trying to load..")
        AssetHandler.LoadSpriteImage(asset_name)
    end
    local obj2 = obj or AssetHandler.Assets[asset_name]
    if obj2 then
        return obj2
    else 
        print("asset " .. asset_name .. " isnt loaded")
        return AssetHandler.Assets.undefined

    end
end

---returns a single quad selected by asset_name.variant
---@param asset_name string "can be for example tile.type or character"
---@param variant string "either of Types.Variant or frames for animation (like character)"
---@return table "{img, quad} the original image and the assigned quad"
AssetHandler.GetQuad = function(asset_name, variant)
    if asset_name == "dirt" then
        print("pause")
    end
    ---check if asset exists, if not try to load
    local obj = AssetHandler.Assets[asset_name]
    if obj == nil then
        print("asset " .. asset_name .. " doesnt exist, trying to load..")
        AssetHandler.LoadSpriteImage(asset_name)
        ---could return Get(asset_name, variant) here
        ---in hopes that the asset now exists,
        ---but could result in infinite loop
    end
    
    ---check again if it now exists
    local obj2 = obj or AssetHandler.Assets[asset_name]

    if obj2 then
        local qd = obj2.quads
        if qd then
            local vr = qd[variant]
            if vr then
                return {img = obj2.img, quad = vr}
            else
                print("variant " .. variant .. " doesnt exist for asset " .. asset_name)
            end
        else
            print("quadds dont exist for asset " .. asset_name)
        end
    end

    return AssetHandler.Assets.undefined
    --error("fucky",2)
end

return AssetHandler