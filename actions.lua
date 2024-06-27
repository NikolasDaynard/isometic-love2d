actions = {
    foundCity = {
        name = "foundCity",
        image = "images/icons/foundCity.png",
        check = function(tile)
            return tile.insideCity ~= true and tile.structure == nil and oozeNum - 3 >= 0
        end,
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
    },
    build = {
        name = "build",
        image = "images/icons/build.png",
        check = function(tile)
            return tile.structure == nil and oozeNum - 2 >= 0
        end,
        action = function()
            oozeNum = oozeNum - 2
            oozesPerTurn = oozesPerTurn + 1
            selectedTile.structure = {x = selectedTile.x, y = selectedTile.y, height = selectedTile.height, image = "images/refinery.png", structure = nil}
        end
    },
    upgradeCity = {
        name = "upgradeCity",
        image = "images/icons/upgrade.png",
        check = function(tile)
            if tile.structure ~= nil then
                if tile.structure.type == "city" then
                    return oozeNum - tile.structure.level > 0
                end
            end
            return false
        end,
        action = function()
            selectedTile.structure.level = selectedTile.structure.level + 1
            for  _, nearTiles in ipairs(tileHolder:getTiles()) do
                if distance(nearTiles.x, nearTiles.y, selectedTile.x, selectedTile.y) < selectedTile.structure.level then
                    nearTiles.image = "images/cityTile.png"
                    nearTiles.insideCity = true
                end
            end
            oozeNum = oozeNum - selectedTile.structure.level
        end
    },
    createTroop = {
        name = "createTroop",
        image = "images/icons/createTroop.png",
        check = function(tile)
            if tile.structure ~= nil then
                if tile.structure.type == "city" then
                    return findRandomOpenTileAdjacent(tile.x, tile.y) ~= nil and oozeNum - 2 >= 0
                end
            end
            return false
        end,
        action = function()
            oozeNum = oozeNum - 2
            local tile = findRandomOpenTileAdjacent(selectedTile.x, selectedTile.y)
            tile.structure = {x = tile.x, y = tile.y, height = tile.height, image = "images/drillwarriorTile.png", structure = nil}
            tile.structure.type = "troop"
        end
    },
    collect = {
        name = "collect",
        image = "images/icons/collect.png",
        check = function(tile)
            if tile.structure ~= nil then
                return tile.structure.type == "ooze" and tile.insideCity == true
            end
        end,
        action = function()
            selectedTile.structure = nil
            oozeNum = oozeNum + 1
        end
    },
}
