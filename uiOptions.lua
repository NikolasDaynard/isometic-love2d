-- So it's gonna be a bar like \
--                              0-0-0- with the options cuz thats cool

-- returns possible OLDACTIONS on the tile
require("image")
require("actions")

actionUi = {
    currentButton = -1
}

function moveTile(tile, newTile, movement)
    newTile.structure = tile.structure
    tile.structure = nil
    newTile.structure.x = newTile.x
    newTile.structure.y = newTile.y
end

function actionUi:tileLogic(tile)
    tiles = tileHolder:getTiles()
    OLDACTIONS = {}
    for _, action in pairs(actions) do
        if action.check(tile) then
            table.insert(OLDACTIONS, #OLDACTIONS + 1, action)
        end
    end

    -- OLDACTIONS.build = actions.build.check(tile)
    -- OLDACTIONS.collect = actions.collect.check(tile)
    -- OLDACTIONS.upgradeCity = actions.upgradeCity.check(tile)
    -- OLDACTIONS.upgradeCity = actions.upgradeCity.check(tile)
    -- OLDACTIONS.createTroop = actions.createTroop.check(tile)
    -- OLDACTIONS.foundCity = actions.foundCity.check(tile)
    if tile.structure ~= nil then
        if tile.structure.type == "troop" then
            if tile.structure.moved ~= true then
                if tileHolder:getTileAtPos(selectedTile.x, selectedTile.y + 1).structure == nil then -- right
                    OLDACTIONS.moveRight = true
                    table.insert(interactibleTiles.tiles, tileHolder:getTileAtPos(selectedTile.x, selectedTile.y + 1))
                    interactibleTiles.tiles[#interactibleTiles.tiles].callback = function(tile, newTile)
                        moveTile(tile, newTile, "right")
                    end
                end
                if tileHolder:getTileAtPos(selectedTile.x, selectedTile.y - 1).structure == nil then -- left
                    OLDACTIONS.moveLeft = true
                    table.insert(interactibleTiles.tiles, tileHolder:getTileAtPos(selectedTile.x, selectedTile.y - 1))
                    interactibleTiles.tiles[#interactibleTiles.tiles].callback = function(tile, newTile)
                        moveTile(tile, newTile, "left")
                    end
                end
                if tileHolder:getTileAtPos(selectedTile.x + 1, selectedTile.y).structure == nil then -- dow
                    OLDACTIONS.moveDown = true
                    table.insert(interactibleTiles.tiles, tileHolder:getTileAtPos(selectedTile.x + 1, selectedTile.y))
                    interactibleTiles.tiles[#interactibleTiles.tiles].callback = function(tile, newTile)
                        moveTile(tile, newTile, "down")
                    end
                end
                if tileHolder:getTileAtPos(selectedTile.x - 1, selectedTile.y).structure == nil then -- up
                    OLDACTIONS.moveUp = true
                    table.insert(interactibleTiles.tiles, tileHolder:getTileAtPos(selectedTile.x - 1, selectedTile.y))
                    interactibleTiles.tiles[#interactibleTiles.tiles].callback = function(tile, newTile)
                        moveTile(tile, newTile, "up")
                    end
                end
            end
        end
    end
    return OLDACTIONS
end

function actionUi:click(mouseX, mouseY)
    self.currentButton = -1
    if selectedTile ~= nil then
        OLDACTIONS = actionUi:tileLogic(selectedTile)
        local x = IsoCordToWorldSpace(selectedTile.x, selectedTile.y, selectedTile.height, isometricRenderer.rotation).x
        local y = IsoCordToWorldSpace(selectedTile.x, selectedTile.y, selectedTile.height, isometricRenderer.rotation).y

        local i = 1

        for action, _ in pairs(OLDACTIONS) do
            if clickHitButton(mouseX, mouseY, x + 40 + ((i - 1) * 18), y + 64 + 20 + 2, 6) then
                self.currentButton = i
                break
            end
            i = i + 1
        end

        if self.currentButton ~= -1 then
            return true
        end
        if clickHitRect(mouseX, mouseY, x + 40, y + 64 + 16, 320, 16) then
            return true
        end
    else
        return false -- no ui to click if ytou aint hit the thnnd
    end
end

function actionUi:renderActions(tile) 
    OLDACTIONS = actionUi:tileLogic(tile)
    local x = IsoCordToWorldSpace(tile.x, tile.y, tile.height, isometricRenderer.rotation).x
    local y = IsoCordToWorldSpace(tile.x, tile.y, tile.height, isometricRenderer.rotation).y
    
    imageLib:drawImage(x + 16, y + 16 + 20, "images/uiactions.png") -- it's 64x64

    local currentButton = 1
    print(#OLDACTIONS)
    for _, action in ipairs(OLDACTIONS) do
        print("render")
        imageLib:drawImage(x + 32 + ((currentButton - 1) * 18), y + 64 + 12 + 1, "images/actionCont.png")
        imageLib:drawImage(x + 32 + ((currentButton - 1) * 18), y + 64 + 12 + 2, action.image)
        currentButton = currentButton + 1
    end
    imageLib:drawImage(x + 32 + ((currentButton - 1) * 18), y + 64 + 13, "images/actionCap.png")
    -- love.graphics.rectangle("fill", x, y, 300, 30)
end

function actionUi:execute()
    if self.currentButton == -1 or selectedTile == nil then
        return
    end

    OLDACTIONS = actionUi:tileLogic(selectedTile)
    buttons = {}
    buttonNum = 1
    for _, action in ipairs(OLDACTIONS) do
        if buttonNum == self.currentButton then
            action.action()
            break
        end

        buttonNum = buttonNum + 1
    end

    self.currentButton = -1
end