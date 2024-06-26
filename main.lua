local desktop = require("globalMouse")
local coordsys = desktop()
require("image")
require("isometric")
require("tiles")
require("actionUi")
require("audio")
require("ui")
require("title")
require("helpers")
require("menu")
lunajson = require("libs.lunajson")
Camera = require 'camera'

font = love.graphics.newFont("images/Volter__28Goldfish_29.ttf", 18)
font:setFilter("nearest", "nearest")
smallfont = love.graphics.newFont("images/Volter__28Goldfish_29.ttf", 9)
smallfont:setFilter("nearest", "nearest")
realbigfont = love.graphics.newFont("images/Volter__28Goldfish_29.ttf", 45)
realbigfont:setFilter("nearest", "nearest")

-- playerStat[currentPlayer].oozeNum = 10
-- playerStat[currentPlayer].oozesPerTurn = 1
currentPlayer = 1
playerStat = {{id = 1, oozesPerTurn = 1, oozeNum = 10, crystalNum = 0, skills = deepCopy(menu.skills)},
    {id = 2, oozesPerTurn = 1, oozeNum = 10, crystalNum = 0, skills = deepCopy(menu.skills)}}

local dragging = false
local clickedRotate = false
local drag_offset_x, drag_offset_y = 0, 0
local zoomIntertiaX, zoomIntertiaY = 0, 0
local mouseDeltaX, mouseDeltaY = 0, 0
local mousex, mousey = 0, 0
local absmousex, absmousey = 0, 0
selectedTile = nil
interactibleTiles = {
    tiles = {{x = 3, y = 3, height = 1, image = "images/testing.png", structure = nil, type = "interact"}}
} -- basically if one gets hit it calls interactibleTiles.callback(tile)

local currentRot = 0


function love.load()
    if love.filesystem.getInfo("settings.json") ~= nil then
        settings:loadSettings()
    end
    love.graphics.setFont(font)
    math.randomseed(os.time())
    tileHolder:createMap()
    cam = Camera(0, 0, 1, 0, Camera.smooth.damped(.9))
    audio:playSound("audio/City of Gelatin.mp3", 1, true)
    
    -- audio:playSound("audio/distortion.wav", 1, true)
end



function love.update(dt)
    if not love.window.hasFocus() then
        -- disabled for faster dev
        love.timer.sleep(1) -- .5 is less delay but .6 more cpu points
    end
    menu:update()
    audio:update()
    local x, y = love.mouse.getPosition()
    mouseDeltaX = absmousex - x
    mouseDeltaY = absmousey - y
    absmousex, absmousey = love.mouse.getPosition()
    mousex = cam:mousePosition().x
    mousey = cam:mousePosition().y
    local hitTile = false
    local hitUi = false
    if settings.open then
        if settings:click(mousex, mousey) then
            hitUi = true
            dragging = true
        end
    end
    if not dragging then
        if ui:click(love.mouse.getX(), love.mouse.getY()) then
            hitUi = true
            dragging = true
        end
        if menu.open then
            menu:click(mousex, mousey)
        elseif title.open then
            title:click(mousex, mousey)
        elseif actionUi:click(mousex, mousey) then
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
                        local interactiveTileTile = tileHolder:getTileAtPos(interactiveTile.x, interactiveTile.y)
                        interactiveTile.callback(selectedTile, interactiveTileTile) -- this, what click
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
            interactibleTiles.tiles = {}
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
    if not menu.open then
        isometricRenderer:render(currentRot)
        if selectedTile then
            actionUi:renderActions(selectedTile)
        end
        if interactibleTiles.tiles and next(interactibleTiles.tiles) then
            for _, interactiveTile in ipairs(interactibleTiles.tiles) do
                isometricRenderer:renderTile({x = interactiveTile.x, y = interactiveTile.y, height = interactiveTile.height, image = interactiveTile.image or "images/testing.png", structure = nil, type = "interact"})
            end
        end
    end
    menu:render()
    title:render()
    settings:render()

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
        if love.keyboard.isDown("lctrl") or love.keyboard.isDown("lgui") or love.keyboard.isDown("rgui") then
            cam:zoom(1.01)
        else
            cam:move(0, (-1 / (cam:getScale() / 2))) -- scale is zoom
        end
    end
    if love.keyboard.isDown("down") then
        if love.keyboard.isDown("lctrl") or love.keyboard.isDown("lgui") or love.keyboard.isDown("rgui") then
            cam:zoom(.99)
        else
            cam:move(0, 1 / (cam:getScale() / 2))
        end
    end
    if love.mouse.isDown(3) then
        cam:move(lerp(0, mouseDeltaX, 1) / (cam:getScale()), lerp(0, mouseDeltaY, 1) / (cam:getScale()))
    end

    cam:move(zoomIntertiaX, 0)
    if cam:getScale() < 1 then
        cam:zoom(((zoomIntertiaY / 10) / (3 / cam:getScale())) + 1)
    else
        cam:zoom(((zoomIntertiaY / 10) / (cam:getScale())) + 1)
    end

    zoomIntertiaY = zoomIntertiaY / 2
    zoomIntertiaX = zoomIntertiaX / 1.1

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
function love.wheelmoved(x, y)
    zoomIntertiaY = zoomIntertiaY + y
    zoomIntertiaX = zoomIntertiaX + x * 8
end
