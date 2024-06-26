local desktop = require("globalMouse")
local coordsys = desktop()
require("image")
require("isometric")
require("tiles")

player = tileHolder:newTile(5, 3, 1, "player.png")

function love.load()
    tileHolder:createMap()
end

local dragging = false
local drag_offset_x, drag_offset_y = 0, 0

function love.update(dt)
    if not love.window.hasFocus() then
        -- disabled for faster dev
        -- love.timer.sleep(1) -- .5 is less delay but .6 more cpu points
    end
    
    local mousex, mousey = love.mouse.getPosition()
    local hitTile = false
    for  _, tile in ipairs(tileHolder:getTiles()) do
        if isometricRenderer:clickHitsTile(mousex, mousey, tile) then
            drag_offset_x, drag_offset_y = love.mouse.getPosition() -- needs to stop snapping
            if love.mouse.isDown(1) and not dragging then
                -- hitTile = true
                -- dragging = true
                -- tile.structure = {x = tile.x, y = tile.y, height = tile.height, image = "player.png", structure = nil}
                actions = ui:tileLogic(tile)
                -- if actions.build
            else 
                dragging = false
            end
        end
    end
    if not hitTile then
        windowUpdate()
    end
end

function love.draw()
    love.graphics.clear()

    isometricRenderer:render()
    -- isometricRenderer:renderTile(player)
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