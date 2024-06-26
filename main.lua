local desktop = require("globalMouse")
local coordsys = desktop()
require("image")
require("isometric")
isometricRenderer:createMap()

function love.load()
    
end
local dragging = false
local drag_offset_x, drag_offset_y = 0, 0

function love.update(dt)
    windowUpdate()
    if not love.window.hasFocus() then
        love.timer.sleep(1)
    end
end

function love.draw()
    love.graphics.clear()

    love.graphics.rectangle("fill", 100, 100, 20, 20)
    isometricRenderer:render(3, 3, "ground.png")
end

function windowUpdate()
    if love.mouse.isDown(1) and not dragging then
        dragging = true
    elseif not love.mouse.isDown(1) then
        dragging = false
        drag_offset_x, drag_offset_y = love.mouse.getPosition()
    end
    if dragging then
        local x, y = coordsys:getGlobalMousePosition()
        if x and y then
            love.window.setPosition(x - drag_offset_x, y - drag_offset_y)
        end
    end
end