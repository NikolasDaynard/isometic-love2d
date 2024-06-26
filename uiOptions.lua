-- So it's gonna be a bar like \
--                              0-0-0- with the options cuz thats cool

-- returns possible actions on the tile

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

function ui:render() 

end