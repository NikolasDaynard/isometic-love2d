-- So it's gonna be a bar like \
--                              0-0-0- with the options cuz thats cool

-- returns possible actions on the tile
require("image")

ui = {}

function ui:tileLogic(tile)
    tiles = tileHolder:getTiles()
    actions = {}
    if tile.structure == nil then
        actions.build = true
    end
    if tile.insideCity == false and tile.structure == nil then
        tile.foundCity = true
    end
    return actions
end

function ui:click(mouseX, mouseY, selectedTile)
    if selectedTile ~= nil then
        actions = ui:tileLogic(selectedTile)
        local x = IsoCordToWorldSpace(selectedTile.x, selectedTile.y, selectedTile.height).x
        local y = IsoCordToWorldSpace(selectedTile.x, selectedTile.y, selectedTile.height).y

        if clickHitButton(mouseX, mouseY, x + 40, y + 64 + 20 + 2, 5) then-- first button
            print("clicked!")
        end
    else
        return false -- no ui to click if ytou aint hit the thnnd
    end
end

function ui:renderActions(tile) 
    actions = ui:tileLogic(tile)
    local x = IsoCordToWorldSpace(tile.x, tile.y, tile.height).x
    local y = IsoCordToWorldSpace(tile.x, tile.y, tile.height).y
    imageLib:drawImage(x + 16, y + 16 + 20, "uiActions.png") -- it's 64x64
    
    if actions.build == true then
        love.graphics.setColor(0, 40, 255)
        
        love.graphics.circle("fill", x + 40, y + 64 + 20 + 2, 5) -- literally just numbers idek where they came from
        love.graphics.setColor(1, 1, 1)
    end
    -- love.graphics.rectangle("fill", x, y, 300, 30)
end