-- So it's gonna be a bar like \
--                              0-0-0- with the options cuz thats cool

-- returns possible actions on the tile
require("image")

ui = {
    currentButton = -1
}

function ui:tileLogic(tile)
    tiles = tileHolder:getTiles()
    actions = {}
    if tile.structure == nil then
        actions.build = true
    end
    if tile.insideCity == false and tile.structure == nil then
        actions.foundCity = true
    end
    return actions
end

function ui:click(mouseX, mouseY)
    self.currentButton = -1
    if selectedTile ~= nil then
        actions = ui:tileLogic(selectedTile)
        local x = IsoCordToWorldSpace(selectedTile.x, selectedTile.y, selectedTile.height).x
        local y = IsoCordToWorldSpace(selectedTile.x, selectedTile.y, selectedTile.height).y

        if clickHitButton(mouseX, mouseY, x + 40, y + 64 + 20 + 2, 5) then-- first button
            self.currentButton = 1
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

function ui:renderActions(tile) 
    actions = ui:tileLogic(tile)
    local x = IsoCordToWorldSpace(tile.x, tile.y, tile.height).x
    local y = IsoCordToWorldSpace(tile.x, tile.y, tile.height).y
    if not(next(actions) == nil) then
        imageLib:drawImage(x + 16, y + 16 + 20, "uiActions.png") -- it's 64x64
        imageLib:drawImage(x + 74, y + 64 + 13, "actionCap.png")
        
        if actions.build == true then
            imageLib:drawImage(x + 32, y + 64 + 12 + 2, "build.png")
        end
        -- love.graphics.rectangle("fill", x, y, 300, 30)
    end
end

function ui:execute()
    if self.currentButton == -1 or selectedTile == nil then
        return
    end

    actions = ui:tileLogic(selectedTile)
    buttons = {}
    if actions.build then
        table.insert(buttons, "build")
    end

    print(buttons[self.currentButton])

    if buttons[self.currentButton] == "build" then
        selectedTile.structure = {x = selectedTile.x, y = selectedTile.y, height = selectedTile.height, image = "player.png", structure = nil}
        for  _, nearTiles in ipairs(tileHolder:getTiles()) do
            if distance(nearTiles.x, nearTiles.y, selectedTile.x, selectedTile.y) < 10 then
                if nearTiles.structure == nil then
                    nearTiles.structure = {x = nearTiles.x, y = nearTiles.y, height = selectedTile.height, image = "testing.png", structure = nil}
                    nearTiles.insideCity = true
                end
            end
        end
    end

    self.currentButton = -1
end