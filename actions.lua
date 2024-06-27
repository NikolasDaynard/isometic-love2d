actions = {
    foundCity = {
        image = "images/icons/foundCity.png"
        check = function(tile)
            return tile.insideCity ~= true and tile.structure == nil and oozeNum - 3 >= 0 then
        end
        action = function()
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
        end
    }
    build = {
        image = "images/icons/build.png"
        check = function(tile)
            return tile.structure == nil and oozeNum - 2 >= 0
        end
        action = function()
            oozeNum = oozeNum - 2
            oozesPerTurn = oozesPerTurn + 1
            selectedTile.structure = {x = selectedTile.x, y = selectedTile.y, height = selectedTile.height, image = "images/refinery.png", structure = nil}
        end
    }
}