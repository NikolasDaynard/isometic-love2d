-- returns possible actions on the tile

function tileLogic(tiles)
    actions = {}
    if tile.structure == nil then
        actions.build = true
    end
    if tile.insideCity == false and tile.structure == nil then
        tile.foundCity = true
    end
end