local desktop = require("globalMouse")
local coordsys = desktop()
require("image")
require("isometric")
require("tiles")

isometricRenderer:createMap()

player = tiles:newTile(5, 3, 1, "player.png")

function love.load()end

local dragging = false
local drag_offset_x, drag_offset_y = 0, 0

function love.update(dt)
    if not love.window.hasFocus() then
        love.timer.sleep(1) -- .5 is less delay but .6 more cpu points
    end
    
    local mousex, mousey = love.mouse.getPosition()
    if isometricRenderer:clickHitsTile(mousex, mousey, player) then
        drag_offset_x, drag_offset_y = love.mouse.getPosition() -- needs to stop snapping
        if love.mouse.isDown(1) then
            print("playa")
            player.x = player.x + 1
            print(player.x)
        end
    else
        windowUpdate()
    end
end

function love.draw()
    love.graphics.clear()

    isometricRenderer:render()
    isometricRenderer:renderTile(player)
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