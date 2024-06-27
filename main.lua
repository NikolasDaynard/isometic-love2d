local desktop = require("globalMouse")
local coordsys = desktop()
require("image")
require("isometric")
require("tiles")
require("uiOptions")
require("ui")
require("helpers")
Camera = require 'camera' 

font = love.graphics.newFont("images/Volter__28Goldfish_29.ttf", 20)

player = tileHolder:newTile(5, 3, 1, "images/player.png")
oozeNum = 10
oozesPerTurn = 1

function love.load()
    love.graphics.setFont(font)
    tileHolder:createMap()
    cam = Camera()
    -- table.insert(interactibleTiles.tiles, #interactibleTiles.tiles + 1, tileHolder:getTileAtPos(1, 1))
end

local dragging = false
local clickedRotate = false
local drag_offset_x, drag_offset_y = 0, 0
selectedTile = nil
interactibleTiles = {
    tiles = {{x = 3, y = 3, height = 1, image = "images/testing.png", structure = nil, type = "interact"}}
} -- basically if one gets hit it calls interactibleTiles.callback(tile)

local currentRot = 0

function love.update(dt)
    if not love.window.hasFocus() then
        -- disabled for faster dev
        -- love.timer.sleep(1) -- .5 is less delay but .6 more cpu points
    end
    
    local mousex = cam:mousePosition().x
    local mousey = cam:mousePosition().y
    local hitTile = false
    local hitUi = false
    if love.mouse.isDown(1) and not dragging then
        if actionUi:click(mousex, mousey) or ui:click(love.mouse.getX(), love.mouse.getY()) then
            hitUi = true
            dragging = true
        end
    elseif not love.mouse.isDown(1) then
        dragging = false
    end
    actionUi:execute()

    local tile = isometricRenderer:whatTileClickHit(mousex, mousey)
    if tile ~= nil and hitUi == false then -- window movement code
        if interactibleTiles.tiles and next(interactibleTiles.tiles) then
            if love.mouse.isDown(1) then
                for _, interactiveTile in ipairs(interactibleTiles.tiles) do
                    if tile.x == interactiveTile.x and tile.y == interactiveTile.y then
                        -- interactibleTiles.callback(interactiveTile)
                        interactibleTiles.tiles = {}
                        break
                    end
                end
            end
        end
        drag_offset_x, drag_offset_y = love.mouse.getPosition() -- needs to stop snapping
        if love.mouse.isDown(1) then
            if not dragging then
                if selectedTile ~= tile then
                    hitTile = true
                    dragging = true
                    selectedTile = tile
                else
                    dragging = true
                    selectedTile = nil
                end
            end
        else 
            dragging = false
        end
    end

    updateCamPosition()

    if not hitTile and not hitUi then
        windowUpdate()
    end
end

function love.draw()
    love.graphics.clear()
    cam:attach()
    isometricRenderer:render(currentRot)
    if selectedTile then
        actionUi:renderActions(selectedTile)
    end
    if interactibleTiles.tiles and next(interactibleTiles.tiles) then
        for _, interactiveTile in ipairs(interactibleTiles.tiles) do
            isometricRenderer:renderTile({x = interactiveTile.x, y = interactiveTile.y, height = interactiveTile.height, image = "images/testing.png", structure = nil, type = "interact"})
        end
    end
    -- isometricRenderer:renderTile(player)
    cam:detach()

    ui:render()
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

function updateCamPosition()
    if love.keyboard.isDown("left") then
        cam:move(-1 / (cam:getScale() / 2), 0)
    end
    if love.keyboard.isDown("right") then
        cam:move(1 / (cam:getScale() / 2), 0)
    end
    if love.keyboard.isDown("up") then
        if love.keyboard.isDown("lctrl") or love.keyboard.isDown("lgui") then
            cam:zoom(1.01)
        else
            cam:move(0, (-1 / (cam:getScale() / 2))) -- scale is zoom
        end
    end
    if love.keyboard.isDown("down") then
        if love.keyboard.isDown("lctrl") or love.keyboard.isDown("lgui") then
            cam:zoom(.99)
        else
            cam:move(0, 1 / (cam:getScale() / 2))
        end
    end

    if love.keyboard.isDown("1") then
        if not clickedRotate then
            currentRot = 0
            clickedRotate = true
        end
    elseif love.keyboard.isDown("2") then
        if not clickedRotate then
            currentRot = 90
            clickedRotate = true
        end
    elseif love.keyboard.isDown("3") then
        if not clickedRotate then
            currentRot = 180
            clickedRotate = true
        end
    elseif love.keyboard.isDown("4") then
        if not clickedRotate then
            currentRot = 270
            clickedRotate = true
        end
    else
        clickedRotate = false
    end
    if clickedRotate and selectedTile then
        local newCamPos = IsoCordToWorldSpace(selectedTile.x, selectedTile.y, selectedTile.height, currentRot)
        cam:lookAt(newCamPos.x, newCamPos.y)
    end
end