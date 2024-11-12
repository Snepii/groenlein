--0. window settings
function love.conf(t)
    print("Loading config: ")
    t.window.title = "game dev era"
    print("\ttitle:" .. t.window.title)
   -- t.window.icon = "grass_texture_32x32.png"
    t.window.width = 1200
    t.window.height = 1000
    print("\tsize:" .. t.window.width .. "x" .. t.window.height)
end

