require "classes.world"



GAMEPATH = {
    RES_PATH = "res/",
    TEXTURES=nil,
    GROUND_TEXTURES=nil,
    FONTS=nil
}

GAMEPATH.TEXTURES = GAMEPATH.RES_PATH .. "textures/"
GAMEPATH.GROUND_TEXTURES = GAMEPATH.TEXTURES .. "ground/"
GAMEPATH.FONTS = GAMEPATH.RES_PATH .. "fonts/"



COLOR = {
    Black = {0,0,0},
    White = {1,1,1},
    TitleMenuBackground = {38/255, 143/255, 209/255},
    TitleMenuButtonBackground = {50/255, 132/255, 138/255},
    TitleMenuButtonText = {188/255, 222/255, 224/255},
    TitleMenuButtonHoverColor = {67/255, 157/255, 163/255}

}

local _fonts = {
    Sizes = { 10, 20, 25, 30, 40, 50, 60 },
    Files = { "ITCBLKAD", "CURLZ", "FREESCPT", "FRSCRIPT", "HARNGTON", "ITCEDSCR"},
}


for __,file in ipairs(_fonts.Files) do
    _fonts[file] = {}
    --print("for file " .. file .. " create sizes")
    for _,s in pairs(_fonts.Sizes) do
        --print(file .. ", " .. s)
        
        _fonts[file][s] = love.graphics.newFont(GAMEPATH.FONTS .. file .. ".ttf", s)
    end
end

FONT = {
    DEFAULT = love.graphics.newFont(12),
    TitleScreen = _fonts["ITCBLKAD"][30],
    TitleScreen2 = _fonts["CURLZ"][30],
    MainMenuButton = _fonts["FREESCPT"][25],
    MainMenuButton2 = _fonts["FRSCRIPT"][25],
    MenuButton3 = _fonts["HARNGTON"][25],
    MenuButton4 = _fonts["ITCEDSCR"][25]

}