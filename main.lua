local desktop = require("globalMouse")
local coordsys = desktop()
require("image")
require("isometric")
require("tiles")
require("uiOptions")
require("helpers")
Camera = require 'camera' 

player = tileHolder:newTile(5, 3, 1, "player.png")

function love.load()
    tileHolder:createMap()
    cam = Camera()
end

local dragging = false
local drag_offset_x, drag_offset_y = 0, 0
selectedTile = nil

function love.update(dt)
    if not love.window.hasFocus() then
        -- disabled for faster dev
        -- love.timer.sleep(1) -- .5 is less delay but .6 more cpu points
    end
    
    local mousex = cam:mousePosition().x
    local mousey = cam:mousePosition().y
    local hitTile = false
    local tile = isometricRenderer:whatTileClickHit(mousex, mousey)
    if tile ~= nil then
        drag_offset_x, drag_offset_y = love.mouse.getPosition() -- needs to stop snapping
        if love.mouse.isDown(1) then
            if not dragging then
                hitTile = true
                dragging = true
                selectedTile = tile
                -- actions = ui:tileLogic(tile)
                -- if actions.build == true then
                --     tile.structure = {x = tile.x, y = tile.y, height = tile.height, image = "player.png", structure = nil}
                --     for  _, nearTiles in ipairs(tileHolder:getTiles()) do
                --         if distance(nearTiles.x, nearTiles.y, tile.x, tile.y) < 10 then
                --             if nearTiles.structure == nil then
                --                 nearTiles.structure = {x = nearTiles.x, y = nearTiles.y, height = tile.height, image = "testing.png", structure = nil}
                --             end
                --         end
                --     end
                -- end
            end
        else 
            dragging = false
        end
    end
    if love.keyboard.isDown("left") then
        cam:move(-1, 0)
    elseif love.keyboard.isDown("right") then
        cam:move(1, 0)
    elseif love.keyboard.isDown("up") then
        if love.keyboard.isDown("lctrl") or love.keyboard.isDown("lgui") then
            cam:zoom(1.01)
        else
            cam:move(0, -1)
        end
    elseif love.keyboard.isDown("down") then
        if love.keyboard.isDown("lctrl") or love.keyboard.isDown("lgui") then
            cam:zoom(.99)
        else
            cam:move(0, 1)
        end
    end



    if not hitTile then
        windowUpdate()
    end
end

function love.draw()
    love.graphics.clear()
    cam:attach()
    isometricRenderer:render()
    -- ui:renderActions(selectedTile)
    -- isometricRenderer:renderTile(player)
    cam:detach()
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