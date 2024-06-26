-- So it's gonna be a bar like \
--                              0-0-0- with the options cuz thats cool

-- returns possible actions on the tile
require("image")

actionUi = {
    currentButton = -1
}

function actionUi:tileLogic(tile)
    tiles = tileHolder:getTiles()
    actions = {}
    if tile.structure == nil then
        actions.build = true
    else
        if tile.structure.type == "ooze" then
            actions.collect = true
        end
    end
    if tile.insideCity ~= true and tile.structure == nil then
        actions.foundCity = true
    end
    return actions
end

function actionUi:click(mouseX, mouseY)
    self.currentButton = -1
    if selectedTile ~= nil then
        actions = actionUi:tileLogic(selectedTile)
        local x = IsoCordToWorldSpace(selectedTile.x, selectedTile.y, selectedTile.height).x
        local y = IsoCordToWorldSpace(selectedTile.x, selectedTile.y, selectedTile.height).y

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
        if clickHitRect(mouseX, mouseY, x + 40, y + 64 + 16, 32, 16) then
            return true
        end
    else
        return false -- no ui to click if ytou aint hit the thnnd
    end
end

function actionUi:renderActions(tile) 
    actions = actionUi:tileLogic(tile)
    local x = IsoCordToWorldSpace(tile.x, tile.y, tile.height).x
    local y = IsoCordToWorldSpace(tile.x, tile.y, tile.height).y
    if not(next(actions) == nil) then
        imageLib:drawImage(x + 16, y + 16 + 20, "images/uiActions.png") -- it's 64x64
        imageLib:drawImage(x + 74, y + 64 + 13, "images/actionCap.png")

        local currentButton = 1
        
        if actions.foundCity == true then
            imageLib:drawImage(x + 32 + ((currentButton - 1) * 18), y + 64 + 12 + 2, "images/icons/foundCity.png")
            currentButton = currentButton + 1
        end
        if actions.build == true then
            imageLib:drawImage(x + 32 + ((currentButton - 1) * 18), y + 64 + 12 + 2, "images/icons/build.png")
            currentButton = currentButton + 1
        end
        if actions.collect == true then
            imageLib:drawImage(x + 32 + ((currentButton - 1) * 18), y + 64 + 12 + 2, "images/icons/collect.png")
            currentButton = currentButton + 1
        end
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

    print(buttons[self.currentButton])

    if buttons[self.currentButton] == "foundCity" then
        selectedTile.structure = {x = selectedTile.x, y = selectedTile.y, height = selectedTile.height, image = "images/player.png", structure = nil}
        selectedTile.insideCity = true
        for  _, nearTiles in ipairs(tileHolder:getTiles()) do
            if distance(nearTiles.x, nearTiles.y, selectedTile.x, selectedTile.y) < 10 then
                if nearTiles.structure == nil then
                    nearTiles.structure = {x = nearTiles.x, y = nearTiles.y, height = selectedTile.height, image = "images/testing.png", structure = nil}
                end
                nearTiles.insideCity = true
            end
        end
    elseif buttons[self.currentButton] == "collect" then
        selectedTile.structure = nil
        -- iterate ooze score here ig
    end
    

    self.currentButton = -1
end