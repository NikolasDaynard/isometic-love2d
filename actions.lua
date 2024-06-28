require("helpers")
require("menu")

actions = {
    foundCity = {
        tooltip = "Build a new slime city",
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
                    nearTiles.image = "images/tiles/cityTile.png"
                    nearTiles.insideCity = true
                    nearTiles.control = currentPlayer
                end
            end
        end
    },
    build = {
        tooltip = "Build a slime factory (-2 (+1))",
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
        tooltip = "Increace city radius (-${selectedTile.structure.level}",
        image = "images/icons/upgrade.png",
        check = function(tile)
            if tile.structure ~= nil then
                if tile.structure.type == "city" then
                    return oozeNum - tile.structure.level >= 0
                end
            end
            return false
        end,
        action = function()
            selectedTile.structure.level = selectedTile.structure.level + 1
            for  _, nearTiles in ipairs(tileHolder:getTiles()) do
                if distance(nearTiles.x, nearTiles.y, selectedTile.x, selectedTile.y) < selectedTile.structure.level then
                    nearTiles.image = "images/tiles/cityTile.png"
                    nearTiles.insideCity = true
                end
            end
            oozeNum = oozeNum - selectedTile.structure.level
        end
    },
    createSawSlime = {
        tooltip = "Create sawslime (-2)",
        image = "images/icons/createTroop.png",
        check = function(tile)
            if tile.structure ~= nil then
                if tile.structure.type == "city" and menu.skills.sawSlime.earned == true then
                    return findRandomOpenTileAdjacent(tile.x, tile.y) ~= nil and oozeNum - 2 >= 0
                end
            end
            return false
        end,
        action = function()
            oozeNum = oozeNum - 2
            local tile = findRandomOpenTileAdjacent(selectedTile.x, selectedTile.y)
            tile.structure = {x = tile.x, y = tile.y, height = tile.height, image = "images/troops/drillwarrior.png", structure = nil}
            tile.structure.type = "troop"
        end
    },
    create3Slime = {
        tooltip = "Create a Triple Slime (-3)",
        image = "images/icons/createTroop.png",
        check = function(tile)
            if tile.structure ~= nil then
                if tile.structure.type == "city" and menu.skills.slimes3.earned == true then
                    return findRandomOpenTileAdjacent(tile.x, tile.y) ~= nil and oozeNum - 3 >= 0
                end
            end
            return false
        end,
        action = function()
            oozeNum = oozeNum - 3
            local tile = findRandomOpenTileAdjacent(selectedTile.x, selectedTile.y)
            tile.structure = {x = tile.x, y = tile.y, height = tile.height, image = "images/troops/3warrior.png", structure = nil}
            tile.structure.type = "troop"
        end
    },
    createCrystalSlime = {
        tooltip = "Create a Crystal Slime (-3)",
        image = "images/icons/createTroop.png",
        check = function(tile)
            if tile.structure ~= nil then
                if tile.structure.type == "city" and menu.skills.crystalSlime.earned == true then
                    return findRandomOpenTileAdjacent(tile.x, tile.y) ~= nil and oozeNum - 3 >= 0
                end
            end
            return false
        end,
        action = function()
            oozeNum = oozeNum - 3
            local tile = findRandomOpenTileAdjacent(selectedTile.x, selectedTile.y)
            tile.structure = {x = tile.x, y = tile.y, height = tile.height, image = "images/troops/crystalwarrior.png", structure = nil}
            tile.structure.type = "troop"
        end
    },
    twistTroop = {
        tooltip = "Twists around the troop and alters it's type",
        image = "images/icons/createTroop.png", -- TODO: finish this
        check = function(tile)
            if tile.structure ~= nil then
                if tile.structure.type == "troop" and menu.skills.twist.earned == true then
                    return true
                end
            end
            return false
        end,
        action = function()
            selectedTile.structure = {x = selectedTile.x, y = selectedTile.y, height = selectedTile.height, image = "images/troops/3warrior.png", structure = nil}
        end
    },
    disguise = {
        tooltip = "Hides the troop to make it appear like a slime deposit",
        image = "images/icons/createTroop.png", -- TODO: finish this
        check = function(tile)
            if tile.structure ~= nil then
                if tile.structure.type == "troop" and menu.skills.disguise.earned == true then
                    return true
                end
            end
            return false
        end,
        action = function()
            selectedTile.structure.image = "images/resources/ooze3.png"
        end
    },
    dissolve = {
        tooltip = "Dissolve this unit and turn the current tile into a city tile",
        image = "images/icons/createTroop.png", -- TODO: finish this
        check = function(tile)
            if tile.structure ~= nil then
                if tile.structure.type == "troop" and menu.skills.dissolve.earned == true and selectedTile.insideCity == false then
                    return true
                end
            end
            return false
        end,
        action = function()
            selectedTile.insideCity = true
            selectedTile.image = "images/tiles/cityTile.png"
            selectedTile.structure = nil
        end
    },
    collect = {
        tooltip = "Collect slime (+1)",
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
    drill = {
        tooltip = "Collect minerals (+2)",
        image = "images/icons/drill.png",
        check = function(tile)
            if tile.structure ~= nil then
                return tile.structure.type == "mineral" and tile.insideCity == true and menu.skills.drilling.earned == true
            end
        end,
        action = function()
            selectedTile.structure = nil
            oozeNum = oozeNum + 2
        end
    },
    moveTroop = {
        check = function(tile)
            -- interactive tile here
            if tile.structure ~= nil then
                if tile.structure.type == "troop" then
                    if tile.structure.moved ~= true then
                        actions.moveTroop.action()
                    end
                end
            end
            return false
        end,
        action = function()
            directions = {{-1, 0}, {1, 0}, {-1, 1}, {-1, -1}, 
                {0, -1}, {0, 1}, {1, 1}, {1, -1}}

            for _, direction in ipairs(directions) do
                local dx, dy = direction[1], direction[2]
                local targetTile = tileHolder:getTileAtPos(selectedTile.x + dx, selectedTile.y + dy)
                if targetTile and targetTile.structure == nil then
                    local tileCopy = deepCopy(targetTile)
                    tileCopy.image = "images/move.png"
                    table.insert(interactibleTiles.tiles, tileCopy)
                    interactibleTiles.tiles[#interactibleTiles.tiles].callback = function(tile, newTile)
                        actions.moveTroop.moveTile(tile, newTile)
                    end
                end
            end
        end,
        moveTile = function(tile, newTile)
            newTile.structure = selectedTile.structure
            selectedTile.structure = nil
            newTile.structure.x = newTile.x
            newTile.structure.y = newTile.y
            newTile.structure.moved = true
        end
    }
}
