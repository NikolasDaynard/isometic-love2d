-- So it's gonna be a bar like \
--                              0-0-0- with the options cuz thats cool

-- returns possible actions on the tile
require("image")

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
    actions = {}
    if tile.structure == nil then
        if oozeNum - 2 >= 0 then
            actions.build = true
        end
    else
        if tile.structure.type == "ooze" and tile.insideCity == true then
            actions.collect = true
        elseif tile.structure.type == "troop" then
            if tile.structure.moved ~= true then
                if tileHolder:getTileAtPos(selectedTile.x, selectedTile.y + 1).structure == nil then -- right
                    actions.moveRight = true
                    table.insert(interactibleTiles.tiles, tileHolder:getTileAtPos(selectedTile.x, selectedTile.y + 1))
                    interactibleTiles.tiles[#interactibleTiles.tiles].callback = function(tile, newTile)
                        moveTile(tile, newTile, "right")
                    end
                end
                if tileHolder:getTileAtPos(selectedTile.x, selectedTile.y - 1).structure == nil then -- left
                    actions.moveLeft = true
                    table.insert(interactibleTiles.tiles, tileHolder:getTileAtPos(selectedTile.x, selectedTile.y - 1))
                    interactibleTiles.tiles[#interactibleTiles.tiles].callback = function(tile, newTile)
                        moveTile(tile, newTile, "left")
                    end
                end
                if tileHolder:getTileAtPos(selectedTile.x + 1, selectedTile.y).structure == nil then -- dow
                    actions.moveDown = true
                    table.insert(interactibleTiles.tiles, tileHolder:getTileAtPos(selectedTile.x + 1, selectedTile.y))
                    interactibleTiles.tiles[#interactibleTiles.tiles].callback = function(tile, newTile)
                        moveTile(tile, newTile, "down")
                    end
                end
                if tileHolder:getTileAtPos(selectedTile.x - 1, selectedTile.y).structure == nil then -- up
                    actions.moveUp = true
                    table.insert(interactibleTiles.tiles, tileHolder:getTileAtPos(selectedTile.x - 1, selectedTile.y))
                    interactibleTiles.tiles[#interactibleTiles.tiles].callback = function(tile, newTile)
                        moveTile(tile, newTile, "up")
                    end
                end
            end
            
        elseif tile.structure.type == "city" then
            if oozeNum - tile.structure.level > 0 then -- this is right I promise
                actions.upgradeCity = true
            end
            if findRandomOpenTileAdjacent(tile.x, tile.y) ~= nil and oozeNum - 2 >= 0 then
                actions.createTroop = true
            end
        end
    end
    if tile.insideCity ~= true and tile.structure == nil and oozeNum - 3 >= 0 then
        actions.foundCity = true
    end
    return actions
end

function actionUi:click(mouseX, mouseY)
    self.currentButton = -1
    if selectedTile ~= nil then
        actions = actionUi:tileLogic(selectedTile)
        local x = IsoCordToWorldSpace(selectedTile.x, selectedTile.y, selectedTile.height, isometricRenderer.rotation).x
        local y = IsoCordToWorldSpace(selectedTile.x, selectedTile.y, selectedTile.height, isometricRenderer.rotation).y

        local i = 1
        for action, _ in pairs(actions) do
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
    actions = actionUi:tileLogic(tile)
    local x = IsoCordToWorldSpace(tile.x, tile.y, tile.height, isometricRenderer.rotation).x
    local y = IsoCordToWorldSpace(tile.x, tile.y, tile.height, isometricRenderer.rotation).y
    if not(next(actions) == nil) then
        imageLib:drawImage(x + 16, y + 16 + 20, "images/uiActions.png") -- it's 64x64

        local currentButton = 1
        
        if actions.foundCity == true then
            imageLib:drawImage(x + 31 + ((currentButton - 1) * 18), y + 64 + 12 + 1, "images/actionCont.png")
            imageLib:drawImage(x + 32 + ((currentButton - 1) * 18), y + 64 + 12 + 2, "images/icons/foundCity.png")
            currentButton = currentButton + 1
        end
        if actions.build == true then
            imageLib:drawImage(x + 31 + ((currentButton - 1) * 18), y + 64 + 12 + 1, "images/actionCont.png")
            imageLib:drawImage(x + 32 + ((currentButton - 1) * 18), y + 64 + 12 + 2, "images/icons/build.png")
            currentButton = currentButton + 1
        end
        if actions.collect == true then
            imageLib:drawImage(x + 31 + ((currentButton - 1) * 18), y + 64 + 12 + 1, "images/actionCont.png")
            imageLib:drawImage(x + 32 + ((currentButton - 1) * 18), y + 64 + 12 + 2, "images/icons/collect.png")
            currentButton = currentButton + 1
        end
        if actions.upgradeCity == true then
            imageLib:drawImage(x + 32 + ((currentButton - 1) * 18), y + 64 + 12 + 1, "images/actionCont.png")
            imageLib:drawImage(x + 32 + ((currentButton - 1) * 18), y + 64 + 12 + 2, "images/icons/upgrade.png")
            currentButton = currentButton + 1
        end
        if actions.createTroop == true then
            imageLib:drawImage(x + 32 + ((currentButton - 1) * 18), y + 64 + 12 + 1, "images/actionCont.png")
            imageLib:drawImage(x + 32 + ((currentButton - 1) * 18), y + 64 + 12 + 2, "images/icons/createTroop.png")
            currentButton = currentButton + 1
        end
        imageLib:drawImage(x + 32 + ((currentButton - 1) * 18), y + 64 + 13, "images/actionCap.png")
        -- love.graphics.rectangle("fill", x, y, 300, 30)
    end
end

function actionUi:execute()
    if self.currentButton == -1 or selectedTile == nil then
        return
    end

    actions = actionUi:tileLogic(selectedTile)
    buttons = {}
    if actions.foundCity then
        table.insert(buttons, "foundCity")
    end
    if actions.build then
        table.insert(buttons, "build")
    end
    if actions.collect then
        table.insert(buttons, "collect")
    end

    if actions.upgradeCity then
        table.insert(buttons, "upgrade")
    end
    if actions.createTroop then
        table.insert(buttons, "createTroop")
    end

    print(buttons[self.currentButton])

    if buttons[self.currentButton] == "build" then
        oozeNum = oozeNum - 2
        oozesPerTurn = oozesPerTurn + 1
        selectedTile.structure = {x = selectedTile.x, y = selectedTile.y, height = selectedTile.height, image = "images/refinery.png", structure = nil}
    elseif buttons[self.currentButton] == "foundCity" then
        selectedTile.structure = {x = selectedTile.x, y = selectedTile.y, height = selectedTile.height, image = "images/player.png", structure = nil}
        selectedTile.structure.type = "city"
        selectedTile.insideCity = true
        selectedTile.structure.level = 3
        oozeNum = oozeNum - 3
        for  _, nearTiles in ipairs(tileHolder:getTiles()) do
            if distance(nearTiles.x, nearTiles.y, selectedTile.x, selectedTile.y) < selectedTile.structure.level then
                nearTiles.image = "images/cityTile.png"
                nearTiles.insideCity = true
            end
        end
    elseif buttons[self.currentButton] == "collect" then
        selectedTile.structure = nil
        oozeNum = oozeNum + 1
    elseif buttons[self.currentButton] == "upgrade" then
        selectedTile.structure.level = selectedTile.structure.level + 1
        for  _, nearTiles in ipairs(tileHolder:getTiles()) do
            if distance(nearTiles.x, nearTiles.y, selectedTile.x, selectedTile.y) < selectedTile.structure.level then
                nearTiles.image = "images/cityTile.png"
                nearTiles.insideCity = true
            end
        end
        oozeNum = oozeNum - selectedTile.structure.level
    elseif buttons[self.currentButton] == "createTroop" then
        oozeNum = oozeNum - 2
        local tile = findRandomOpenTileAdjacent(selectedTile.x, selectedTile.y)
        tile.structure = {x = tile.x, y = tile.y, height = tile.height, image = "images/drillwarriorTile.png", structure = nil}
        tile.structure.type = "troop"
    end
    

    self.currentButton = -1
end