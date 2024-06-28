require("helpers")
require("menu")

actions = {
    foundCity = {
        tooltip = "Build a new slime city",
        image = "images/icons/foundCity.png",
        check = function(tile)
            return tile.insideCity ~= true and tile.structure == nil and playerStat[currentPlayer].oozeNum - 3 >= 0
        end,
        action = function()
            selectedTile.structure = {x = selectedTile.x, y = selectedTile.y, height = selectedTile.height, image = "images/player.png", structure = nil}
            selectedTile.structure.type = "city"
            selectedTile.insideCity = true
            selectedTile.structure.level = 3
            playerStat[currentPlayer].oozeNum = playerStat[currentPlayer].oozeNum - 3
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
            return tile.structure == nil and playerStat[currentPlayer].oozeNum - 2 >= 0
        end,
        action = function()
            playerStat[currentPlayer].oozeNum = playerStat[currentPlayer].oozeNum - 2
            playerStat[currentPlayer].oozesPerTurn = playerStat[currentPlayer].oozesPerTurn + 1
            selectedTile.structure = {x = selectedTile.x, y = selectedTile.y, height = selectedTile.height, image = "images/refinery.png", structure = nil}
        end
    },
    upgradeCity = {
        tooltip = "Increace city radius (-${selectedTile.structure.level}",
        image = "images/icons/upgrade.png",
        check = function(tile)
            if tile.structure ~= nil then
                if tile.structure.type == "city" then
                    return playerStat[currentPlayer].oozeNum - tile.structure.level >= 0
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
                    selectedTile.control = currentPlayer
                end
            end
            playerStat[currentPlayer].oozeNum = playerStat[currentPlayer].oozeNum - selectedTile.structure.level
        end
    },
    createSawSlime = {
        tooltip = "Create sawslime (-2)",
        image = "images/icons/createTroop.png",
        check = function(tile)
            if tile.structure ~= nil then
                if tile.structure.type == "city" and menu.skills.sawSlime.earned == true then
                    return findRandomOpenTileAdjacent(tile.x, tile.y) ~= nil and playerStat[currentPlayer].oozeNum - 2 >= 0
                end
            end
            return false
        end,
        action = function()
            playerStat[currentPlayer].oozeNum = playerStat[currentPlayer].oozeNum - 2
            local tile = findRandomOpenTileAdjacent(selectedTile.x, selectedTile.y)
            tile.structure = {x = tile.x, y = tile.y, height = tile.height, image = "images/troops/drillwarrior.png", structure = nil}
            tile.structure.type = "troop"
            tile.control = currentPlayer
        end
    },
    create3Slime = {
        tooltip = "Create a Triple Slime (-3)",
        image = "images/icons/createTroop.png",
        check = function(tile)
            if tile.structure ~= nil then
                if tile.structure.type == "city" and menu.skills.slimes3.earned == true then
                    return findRandomOpenTileAdjacent(tile.x, tile.y) ~= nil and playerStat[currentPlayer].oozeNum - 3 >= 0
                end
            end
            return false
        end,
        action = function()
            playerStat[currentPlayer].oozeNum = playerStat[currentPlayer].oozeNum - 3
            local tile = findRandomOpenTileAdjacent(selectedTile.x, selectedTile.y)
            tile.structure = {x = tile.x, y = tile.y, height = tile.height, image = "images/troops/3warrior.png", structure = nil}
            tile.structure.type = "fastTroop"
            tile.control = currentPlayer
        end
    },
    createCrystalSlime = {
        tooltip = "Create a Crystal Slime (-3)",
        image = "images/icons/createTroop.png",
        check = function(tile)
            if tile.structure ~= nil then
                if tile.structure.type == "city" and menu.skills.crystalSlime.earned == true then
                    return findRandomOpenTileAdjacent(tile.x, tile.y) ~= nil and playerStat[currentPlayer].oozeNum - 3 >= 0
                end
            end
            return false
        end,
        action = function()
            playerStat[currentPlayer].oozeNum = playerStat[currentPlayer].oozeNum - 3
            local tile = findRandomOpenTileAdjacent(selectedTile.x, selectedTile.y)
            tile.structure = {x = tile.x, y = tile.y, height = tile.height, image = "images/troops/crystalwarrior.png", structure = nil}
            tile.structure.type = "troop"
            tile.control = currentPlayer
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
            playerStat[currentPlayer].oozeNum = playerStat[currentPlayer].oozeNum + 1
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
            playerStat[currentPlayer].oozeNum = playerStat[currentPlayer].oozeNum + 2
        end
    },
    moveTroop = {
        check = function(tile)
            -- interactive tile here
            if tile.structure ~= nil then
                if tile.structure.type == "troop" then
                    if tile.structure.moved ~= true then
                        moveTroopDist(1)
                    end
                end
            end
            return false
        end,
    },
    moveTroopFast = {
        check = function(tile)
            -- interactive tile here
            if tile.structure ~= nil then
                if tile.structure.type == "fastTroop" then
                    if tile.structure.moved ~= true then
                        moveTroopDist(2)
                    end
                end
            end
            return false
        end,
    }
}
function moveTroopDist(distance)
    local moveTile = function(tile, newTile)
        newTile.structure = selectedTile.structure
        selectedTile.structure = nil
        newTile.structure.x = newTile.x
        newTile.structure.y = newTile.y
        newTile.structure.moved = true
        newTile.control = selectedTile.control
        if not selectedTile.insideCity then
            selectedTile.control = nil
        end
        print(newTile.control)
    end

    local directions = {}
    for dx = -distance, distance do
        for dy = -distance, distance do
            if math.abs(dx) <= distance and math.abs(dy) <= distance then
                table.insert(directions, {dx, dy})
            end
        end
    end

    for _, direction in ipairs(directions) do
        local dx, dy = direction[1], direction[2]
        local targetTile = tileHolder:getTileAtPos(selectedTile.x + dx, selectedTile.y + dy)
        if targetTile and targetTile.structure == nil then
            local tileCopy = deepCopy(targetTile)
            tileCopy.image = "images/move.png"
            table.insert(interactibleTiles.tiles, tileCopy)
            interactibleTiles.tiles[#interactibleTiles.tiles].callback = function(tile, newTile)
                moveTile(tile, newTile)
            end
        end
    end
end