-- this is for static ui :)
require("image")
ui = {}

function ui:render() 
    width, height, flags = love.window.getMode()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, width, 20)
    love.graphics.setColor(1, 1, 1)

    imageLib:drawImage(2, 2, "images/icons/build.png")
end

function ui:click(x, y) 

end