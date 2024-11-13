local TitleMenu = (require "classes.menu"):extend()

require "classes.staticvalues"

function TitleMenu:new()
    TitleMenu.super.new(self, 0, "GROENLEIN", "vertical", COLOR.TitleMenuBackground, 0, 0, COLOR.White)


    local btnStart = (require "classes.menubutton")(1, "default", COLOR.TitleMenuButtonBackground, COLOR.TitleMenuButtonHoverColor, COLOR.TitleMenuButtonText, nil, "START",400,200, 50)
    btnStart.Click = function()
        GameStart()
    end
    self.addButton(self, btnStart)

    local btnQuit = (require "classes.menubutton")(2, "default", COLOR.TitleMenuButtonBackground, COLOR.TitleMenuButtonHoverColor, COLOR.TitleMenuButtonText, nil, "QUIT", 400, 200, 50)
    btnQuit.Click = function()
        love.event.quit()
    end

    self.addButton(self,btnQuit)


    self.font = FONT.MenuButton3
    btnStart.font = FONT.TitleScreen2
    btnQuit.font = FONT.MainMenuButton
    
    local btn3 = (require "classes.menubutton")(2, "default", COLOR.TitleMenuButtonBackground, COLOR.TitleMenuButtonHoverColor, COLOR.TitleMenuButtonText, nil, "QUIT", 400, 200, 50)
    btn3.font = FONT.MainMenuButton2
    if btn3.font == nil then
        error("???")
    end


    local btn4 = (require "classes.menubutton")(2, "default", COLOR.TitleMenuButtonBackground, COLOR.TitleMenuButtonHoverColor, COLOR.TitleMenuButtonText, nil, "QUIT", 400, 200, 50)
    btn4.font = FONT.MenuButton3

    if btn4.font == nil then
        error("????")
    end


    local btn5 = (require "classes.menubutton")(2, "default", COLOR.TitleMenuButtonBackground, COLOR.TitleMenuButtonHoverColor, COLOR.TitleMenuButtonText, nil, "QUIT", 400, 200, 50)
    btn5.font = FONT.MenuButton4

    if btn5.font == nil then
        error("5?")
    end

    self.addButton(self, btn3)
    self.addButton(self, btn4)
    self.addButton(self, btn5)

    self.shown = true

    self.updateSize(self)
    self.x = love.graphics.getWidth()/2 - self.width/2

end

return TitleMenu