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
            selectedTile.structure = {x = selectedTile.x, y = selectedTile.y, height = selectedTile.height, image = "images/player.png", structure = nil, health = 10, maxHp = 10}
            selectedTile.structure.type = "city"
            selectedTile.structure.destructionCallback = function()
                print("destroyed :(")
            end
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
            return tile.control == currentPlayer and tile.structure == nil and playerStat[currentPlayer].oozeNum - 2 >= 0
        end,
        action = function()
            playerStat[currentPlayer].oozeNum = playerStat[currentPlayer].oozeNum - 2
            playerStat[currentPlayer].oozesPerTurn = playerStat[currentPlayer].oozesPerTurn + 1
            selectedTile.structure = {x = selectedTile.x, y = selectedTile.y, height = selectedTile.height, image = "images/refinery.png", structure = nil}
        end
    },
    buildSlimescraper = {
        tooltip = "Build a slimescraper (-5 (+3))",
        image = "images/icons/build.png",
        check = function(tile)
            return tile.control == currentPlayer and tile.structure == nil and playerStat[currentPlayer].oozeNum - 5 >= 0
        end,
        action = function()
            playerStat[currentPlayer].oozeNum = playerStat[currentPlayer].oozeNum - 5
            playerStat[currentPlayer].oozesPerTurn = playerStat[currentPlayer].oozesPerTurn + 3
            selectedTile.structure = {x = selectedTile.x, y = selectedTile.y, height = selectedTile.height, image = "images/slimescraper.png", structure = nil}
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
                    nearTiles.control = currentPlayer
                end
            end
            playerStat[currentPlayer].oozeNum = playerStat[currentPlayer].oozeNum - selectedTile.structure.level
        end
    },
    createDefaultSlime = {
        tooltip = "Create slime (-1)",
        image = "images/icons/createTroop.png",
        check = function(tile)
            if tile.structure ~= nil then
                if tile.structure.type == "city" then
                    return findRandomOpenTileAdjacent(tile.x, tile.y) ~= nil and playerStat[currentPlayer].oozeNum - 1 >= 0
                end
            end
            return false
        end,
        action = function()
            playerStat[currentPlayer].oozeNum = playerStat[currentPlayer].oozeNum - 1
            local tile = findRandomOpenTileAdjacent(selectedTile.x, selectedTile.y)
            tile.structure = {x = tile.x, y = tile.y, height = tile.height, image = "images/troops/defaultSlime.png", structure = nil, health = 1, maxHp = 1}
            tile.structure.type = "troop"
            tile.control = currentPlayer
        end
    },
    createReincarnate = {
        tooltip = "Build a slime with two lives (-2)",
        image = "images/icons/build.png",
        check = function(tile)
            if tile.structure ~= nil then
                return findRandomOpenTileAdjacent(tile.x, tile.y) ~= nil and playerStat[currentPlayer].oozeNum - 2 >= 0 and tile.structure.type == "city"and playerStat[currentPlayer].skills.reincarnate.earned == true
            end
        end,
        action = function()
            playerStat[currentPlayer].oozeNum = playerStat[currentPlayer].oozeNum - 2
            local tile = findRandomOpenTileAdjacent(selectedTile.x, selectedTile.y)
            tile.structure = {x = tile.x, y = tile.y, height = tile.height, image = "images/troops/defaultSlime.png", structure = nil, health = 1, maxHp = 1}
            tile.structure.type = "troop"
            tile.control = currentPlayer
            tile.structure.controlRender = function(tile)
                local x = IsoCordToWorldSpace(tile.x, tile.y, tile.height, isometricRenderer.rotation).x
                local y = IsoCordToWorldSpace(tile.x, tile.y, tile.height, isometricRenderer.rotation).y
                imageLib:drawImage(x, y, "images/extraLife.png")
            end
            tile.structure.destructionCallback = function(thisTile)
                local tile = findRandomOpenTileAdjacent(selectedTile.x, selectedTile.y)
                tile.structure = {x = tile.x, y = tile.y, height = tile.height, image = "images/troops/defaultSlime.png", structure = nil, health = 1, maxHp = 1}
                tile.structure.type = "troop"
                tile.control = thisTile.control
            end
        end
    },
    createGiant = {
        tooltip = "Build a Giant Slime (-5)",
        image = "images/icons/build.png",
        check = function(tile)
            if tile.structure ~= nil then
                return findRandomOpenTileAdjacent(tile.x, tile.y) ~= nil and playerStat[currentPlayer].oozeNum - 2 >= 0 and tile.structure.type == "city" and playerStat[currentPlayer].skills.giant.earned == true
            end
        end,
        action = function()
            playerStat[currentPlayer].oozeNum = playerStat[currentPlayer].oozeNum - 2
            local tile = findRandomOpenTileAdjacent(selectedTile.x, selectedTile.y)
            tile.structure = {x = tile.x, y = tile.y, height = tile.height, image = "images/troops/giant.png", structure = nil, health = 5, maxHp = 5}
            tile.structure.type = "troop"
            tile.control = currentPlayer
        end
    },
    createSpirit = {
        tooltip = "Build a ghost of a slime (-2)",
        image = "images/icons/build.png",
        check = function(tile)
            if tile.structure ~= nil then
                return findRandomOpenTileAdjacent(tile.x, tile.y) ~= nil and playerStat[currentPlayer].oozeNum - 2 >= 0 and tile.structure.type == "city" and playerStat[currentPlayer].skills.spirit.earned == true
            end
        end,
        action = function()
            playerStat[currentPlayer].oozeNum = playerStat[currentPlayer].oozeNum - 2
            local tile = findRandomOpenTileAdjacent(selectedTile.x, selectedTile.y)
            tile.structure = {x = tile.x, y = tile.y, height = tile.height, image = "images/troops/spirit.png", structure = nil, health = 1, maxHp = 1}
            tile.structure.type = "troop"
            tile.control = currentPlayer
        end
    },
    fly = {
        tooltip = "Make the slime fly",
        image = "images/icons/upgrade.png",
        check = function(tile)
            if tile.structure ~= nil then
                return tile.structure.type == "troop" and playerStat[currentPlayer].skills.fly.earned == true
            end
        end,
        action = function()
            selectedTile.structure.height = selectedTile.structure.height - 1
        end
    },
    createArcher = {
        tooltip = "Create archer (-3)",
        image = "images/icons/createTroop.png",
        check = function(tile)
            if tile.structure ~= nil then
                if tile.structure.type == "city" and playerStat[currentPlayer].skills.slimeArrowSkill.earned == true then
                    return findRandomOpenTileAdjacent(tile.x, tile.y) ~= nil and playerStat[currentPlayer].oozeNum - 3 >= 0
                end
            end
            return false
        end,
        action = function()
            playerStat[currentPlayer].oozeNum = playerStat[currentPlayer].oozeNum - 3
            local tile = findRandomOpenTileAdjacent(selectedTile.x, selectedTile.y)
            tile.structure = {x = tile.x, y = tile.y, height = tile.height, image = "images/troops/archer.png", structure = nil, health = 1, maxHp = 1}
            tile.structure.type = "troop"
            tile.control = currentPlayer
        end
    },
    createSawSlime = {
        tooltip = "Create sawslime (-2)",
        image = "images/icons/createTroop.png",
        check = function(tile)
            if tile.structure ~= nil then
                if tile.structure.type == "city" and playerStat[currentPlayer].skills.sawSlime.earned == true then
                    return findRandomOpenTileAdjacent(tile.x, tile.y) ~= nil and playerStat[currentPlayer].oozeNum - 2 >= 0
                end
            end
            return false
        end,
        action = function()
            playerStat[currentPlayer].oozeNum = playerStat[currentPlayer].oozeNum - 2
            local tile = findRandomOpenTileAdjacent(selectedTile.x, selectedTile.y)
            tile.structure = {x = tile.x, y = tile.y, height = tile.height, image = "images/troops/drillwarrior.png", structure = nil, health = 2, maxHp = 2}
            tile.structure.type = "troop"
            tile.control = currentPlayer
        end
    },
    create3Slime = {
        tooltip = "Create a Triple Slime (-3)",
        image = "images/icons/createTroop.png",
        check = function(tile)
            if tile.structure ~= nil then
                if tile.structure.type == "city" and playerStat[currentPlayer].skills.slimes3.earned == true then
                    return findRandomOpenTileAdjacent(tile.x, tile.y) ~= nil and playerStat[currentPlayer].oozeNum - 3 >= 0
                end
            end
            return false
        end,
        action = function()
            playerStat[currentPlayer].oozeNum = playerStat[currentPlayer].oozeNum - 3
            local tile = findRandomOpenTileAdjacent(selectedTile.x, selectedTile.y)
            tile.structure = {x = tile.x, y = tile.y, height = tile.height, image = "images/troops/3warrior.png", structure = nil, health = 3, maxHp = 3}
            tile.structure.type = "fastTroop"
            tile.control = currentPlayer
        end
    },
    createLurker = {
        tooltip = "Create a Lurker (-10)",
        image = "images/icons/createTroop.png",
        check = function(tile)
            if tile.structure ~= nil then
                if tile.structure.type == "city" and playerStat[currentPlayer].skills.lurker.earned == true then
                    return findRandomOpenTileAdjacent(tile.x, tile.y) ~= nil and playerStat[currentPlayer].oozeNum - 10 >= 0
                end
            end
            return false
        end,
        action = function()
            playerStat[currentPlayer].oozeNum = playerStat[currentPlayer].oozeNum - 10
            local tile = findRandomOpenTileAdjacent(selectedTile.x, selectedTile.y)
            tile.structure = {x = tile.x, y = tile.y, height = tile.height, image = "images/troops/lurker.png", structure = nil, health = 30, maxHp = 30}
            tile.structure.type = "fastTroop"
            tile.control = currentPlayer
        end
    },
    createHammerSlime = {
        tooltip = "Create a Hammer Slime (-3)",
        image = "images/icons/createTroop.png",
        check = function(tile)
            if tile.structure ~= nil then
                if tile.structure.type == "city" and playerStat[currentPlayer].skills.hammer.earned == true then
                    return findRandomOpenTileAdjacent(tile.x, tile.y) ~= nil and playerStat[currentPlayer].oozeNum - 3 >= 0
                end
            end
            return false
        end,
        action = function()
            playerStat[currentPlayer].oozeNum = playerStat[currentPlayer].oozeNum - 3
            local tile = findRandomOpenTileAdjacent(selectedTile.x, selectedTile.y)
            tile.structure = {x = tile.x, y = tile.y, height = tile.height, image = "images/troops/hammerSlime.png", structure = nil, health = 5, maxHp = 5, crystal = 1}
            tile.structure.type = "troop"
            tile.control = currentPlayer
        end
    },
    createNetworkSlime = {
        tooltip = "Create a Network Slime (-3)",
        image = "images/icons/createTroop.png",
        check = function(tile)
            if tile.structure ~= nil then
                if tile.structure.type == "city" and playerStat[currentPlayer].skills.networkSlime.earned == true then
                    return findRandomOpenTileAdjacent(tile.x, tile.y) ~= nil and playerStat[currentPlayer].oozeNum - 3 >= 0
                end
            end
            return false
        end,
        action = function()
            playerStat[currentPlayer].oozeNum = playerStat[currentPlayer].oozeNum - 3
            local tile = findRandomOpenTileAdjacent(selectedTile.x, selectedTile.y)
            tile.structure = {x = tile.x, y = tile.y, height = tile.height, image = "images/troops/networkSlime.png", structure = nil, health = 5, maxHp = 5}
            tile.structure.type = "troop"
            tile.control = currentPlayer
        end
    },
    buildTile = {
        tooltip = "Raise tile (-5)",
        image = "images/icons/upgrade.png",
        check = function(tile)
            if (tile.structure or {}).type == "city" then
                return false
            end
            return true
        end,
        action = function()
            selectedTile.height = selectedTile.height - 1
            if selectedTile.structure then
                selectedTile.structure.height = selectedTile.structure.height - 1
            end
        end
    },
    createCrystalSlime = {
        tooltip = "Create a Crystal Slime (-3)",
        image = "images/icons/createTroop.png",
        check = function(tile)
            if tile.structure ~= nil then
                if tile.structure.type == "city" and playerStat[currentPlayer].skills.crystalSlime.earned == true then
                    return findRandomOpenTileAdjacent(tile.x, tile.y) ~= nil and playerStat[currentPlayer].oozeNum - 3 >= 0
                end
            end
            return false
        end,
        action = function()
            playerStat[currentPlayer].oozeNum = playerStat[currentPlayer].oozeNum - 3
            local tile = findRandomOpenTileAdjacent(selectedTile.x, selectedTile.y)
            tile.structure = {x = tile.x, y = tile.y, height = tile.height, image = "images/troops/crystalwarrior.png", structure = nil, health = 5, maxHp = 5, crystal = 1}
            tile.structure.type = "troop"
            tile.control = currentPlayer
        end
    },
    crystalize = {
        tooltip = "Crystalize (-1 crystal)",
        image = "images/icons/crystal.png",
        check = function(tile)
            if tile.structure ~= nil then
                return tile.structure.type == "troop" and tile.structure.crystal and playerStat[currentPlayer].skills.crystalize and playerStat[currentPlayer].crystalNum - 1 >= 0
            end
        end,
        action = function()
            playerStat[currentPlayer].crystalNum = playerStat[currentPlayer].crystalNum - 1
            if selectedTile.structure.crystal + 1 == 2 then -- level 2
                selectedTile.structure = {x = selectedTile.x, y = selectedTile.y, height = selectedTile.height, image = "images/troops/crystalizedwarrior.png", structure = nil, health = 5, maxHp = 5, crystal = selectedTile.structure.crystal + 1}
            else -- final level
                selectedTile.structure = {x = selectedTile.x, y = selectedTile.y, height = selectedTile.height, image = "images/troops/crystalguardian.png", structure = nil, health = 5, maxHp = 5, crystal = selectedTile.structure.crystal + 1}
            end
            selectedTile.structure.type = "troop"
            selectedTile.control = currentPlayer
        end
    },
    createRain = {
        tooltip = "Create a localized downpour of slime (-3)",
        image = "images/icons/rain.png",
        check = function(tile)
            if tile.structure == nil then
                if playerStat[currentPlayer].skills.rain.earned == true then
                    return true
                end
            end
            return false
        end,
        action = function()
            playerStat[currentPlayer].oozeNum = playerStat[currentPlayer].oozeNum - 3
            selectedTile.structure = {x = selectedTile.x, y = selectedTile.y, height = selectedTile.height - 1, image = "images/troops/rain.png", structure = nil}
        end
    },
    twistTroop = {
        tooltip = "Twists around the troop and alters it's type",
        image = "images/icons/createTroop.png", -- TODO: finish this
        check = function(tile)
            if tile.structure ~= nil then
                if tile.structure.type == "troop" and playerStat[currentPlayer].skills.twist.earned == true then
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
                if tile.structure.type == "troop" and playerStat[currentPlayer].skills.disguise.earned == true then
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
                if tile.structure.type == "troop" and playerStat[currentPlayer].skills.dissolve.earned == true and selectedTile.insideCity == false then
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
    slimeTrap = {
        tooltip = "Destroys slime that steps on it (-3)",
        image = "images/icons/sleep.png", -- TODO: finish this
        check = function(tile)
            if tile.structure ~= nil then
                if tile.structure.type == "troop" and playerStat[currentPlayer].skills.slimeTrap.earned == true then
                    if tile.structure.trap then
                        for _, newTile in ipairs(tileHolder:getTiles()) do
                            if newTile.structure == nil then
                                if distance(newTile.x, newTile.y, tile.x, tile.y) < 4 then
                                    local tileCopy = deepCopy(newTile)
                                    tileCopy.image = "images/attack.png"
                                    table.insert(interactibleTiles.tiles, tileCopy)
                                    interactibleTiles.tiles[#interactibleTiles.tiles].callback = function(tile, newTile)
                                        selectedTile.structure.trap = false
                                        newTile.controlRender = function(tile)
                                            local x = IsoCordToWorldSpace(tile.x, tile.y, tile.height, isometricRenderer.rotation).x
                                            local y = IsoCordToWorldSpace(tile.x, tile.y, tile.height, isometricRenderer.rotation).y
                                            imageLib:drawImage(x, y + 8, "images/troops/spikeTrap.png")
                                        end
                                        newTile.moveCallback = function(tile, newTile)
                                            tile.structure.health = tile.structure.health - 1
                                            newTile.controlRender = nil
                                            if tile.structure.health <= 0 then
                                                tile.structure = nil
                                            end
                                            newTile.moveCallback = nil
                                        end
                                    end
                                end
                            end
                        end
                    end
                    return true
                end
            end
        end,
        action = function()
            selectedTile.structure.trap = true
        end
    },
    sleep = {
        tooltip = "Puts slime to sleep in close range (-3)",
        image = "images/icons/sleep.png", -- TODO: finish this
        check = function(tile)
            if tile.structure ~= nil then
                if tile.structure.type == "troop" and playerStat[currentPlayer].skills.sleep.earned == true then
                    if tile.structure.sleep then
                        for _, newTile in ipairs(tileHolder:getTiles()) do
                            if newTile.structure ~= nil and newTile.control ~= currentPlayer then
                                if string.find(newTile.structure.type, "troop") ~= nil then
                                    if distance(newTile.x, newTile.y, tile.x, tile.y) < 4 then
                                        local tileCopy = deepCopy(newTile)
                                        tileCopy.image = "images/attack.png"
                                        table.insert(interactibleTiles.tiles, tileCopy)
                                        interactibleTiles.tiles[#interactibleTiles.tiles].callback = function(tile, newTile)
                                            selectedTile.structure.sleep = false
                                            selectedTile.structure.moved = true
                                            newTile.structure.moved = true
                                            if newTile.structure.health <= 0 then
                                                newTile.structure = nil
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    return true
                end
            end
        end,
        action = function()
            selectedTile.structure.sleep = true
        end
    },
    shred = {
        tooltip = "Evicerates a slime in close range (-3)",
        image = "images/icons/swap.png", -- TODO: finish this
        check = function(tile)
            if tile.structure ~= nil then
                if tile.structure.type == "troop" and playerStat[currentPlayer].skills.shred.earned == true then
                    if tile.structure.shred then
                        for _, newTile in ipairs(tileHolder:getTiles()) do
                            if newTile.structure ~= nil then
                                if string.find(newTile.structure.type, "troop") ~= nil then
                                    if distance(newTile.x, newTile.y, tile.x, tile.y) < 4 then
                                        local tileCopy = deepCopy(newTile)
                                        tileCopy.image = "images/attack.png"
                                        table.insert(interactibleTiles.tiles, tileCopy)
                                        interactibleTiles.tiles[#interactibleTiles.tiles].callback = function(tile, newTile)
                                            selectedTile.structure.shred = false
                                            selectedTile.structure.moved = true
                                            newTile.structure.health = newTile.structure.health - 10
                                            if newTile.structure.health <= 0 then
                                                newTile.structure = nil
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    return true
                end
            end
        end,
        action = function()
            selectedTile.structure.shred = true
        end
    },
    telekinisis = {
        tooltip = "Harms a slime far away (-3)",
        image = "images/icons/swap.png", -- TODO: finish this
        check = function(tile)
            if tile.structure ~= nil then
                if tile.structure.type == "troop" and playerStat[currentPlayer].skills.telekinisis.earned == true then
                    if tile.structure.kinisis then
                        for _, tile in ipairs(tileHolder:getTiles()) do
                            if tile.structure ~= nil and tile.control ~= currentPlayer then
                                if string.find(tile.structure.type, "troop") ~= nil then
                                    local tileCopy = deepCopy(tile)
                                    tileCopy.image = "images/move.png"
                                    table.insert(interactibleTiles.tiles, tileCopy)
                                    interactibleTiles.tiles[#interactibleTiles.tiles].callback = function(tile, newTile)
                                        selectedTile.structure.kinisis = false
                                        selectedTile.structure.moved = true
                                        newTile.structure.health = newTile.structure.health - 1
                                        if newTile.structure.health <= 0 then
                                            newTile.structure = nil
                                        end
                                    end
                                end
                            end
                        end
                    end
                    return true
                end
            end
        end,
        action = function()
            selectedTile.structure.kinisis = true
        end
    },
    whirlwind = { -- range of 10
        tooltip = "Harms a slime far away (-3)",
        image = "images/icons/swap.png", -- TODO: finish this
        check = function(tile)
            if tile.structure ~= nil then
                if tile.structure.type == "troop" and playerStat[currentPlayer].skills.whirlwind.earned == true then
                    if tile.structure.kinisis then
                        for _, newTile in ipairs(tileHolder:getTiles()) do
                            if newTile.structure ~= nil then
                                if string.find(newTile.structure.type, "troop") ~= nil then
                                    if distance(newTile.x, newTile.y, tile.x, tile.y) < 10 then
                                        local tileCopy = deepCopy(newTile)
                                        tileCopy.image = "images/move.png"
                                        table.insert(interactibleTiles.tiles, tileCopy)
                                        interactibleTiles.tiles[#interactibleTiles.tiles].callback = function(tile, newTile)
                                            selectedTile.structure.kinisis = false
                                            selectedTile.structure.moved = true
                                            newTile.structure.health = newTile.structure.health - 1
                                            if newTile.structure.health <= 0 then
                                                newTile.structure = nil
                                            end

                                            local distance = 3

                                            local directions = {}
                                            for dx = -distance, distance do
                                                for dy = -distance, distance do
                                                    if math.abs(dx) + math.abs(dy) <= distance and (dx ~= 0 or dy ~= 0) then
                                                        table.insert(directions, {dx, dy})
                                                    end
                                                end
                                            end
                                            updates = {}

                                            for _, direction in ipairs(directions) do
                                                local dx, dy = direction[1], direction[2]
                                                local targetTile = tileHolder:getTileAtPos(newTile.x + dx, newTile.y + dy)
                                                if targetTile and targetTile.structure ~= nil then
                                                    if string.find(targetTile.structure.type, "troop") ~= nil then
                                                        if tileHolder:getTileAtPos(targetTile.x + dx, targetTile.y + dy).structure == nil then
                                                            targetTile.structure.x = targetTile.x + dx
                                                            targetTile.structure.y = targetTile.y + dy
                                                            tileHolder:getTileAtPos(targetTile.x + dx, targetTile.y + dy).structure = deepCopy(targetTile.structure)
                                                            targetTile.structure = nil
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    return true
                end
            end
        end,
        action = function()
            selectedTile.structure.kinisis = true
        end
    },
    swap = {
        tooltip = "Swaps two units you control (-2)",
        image = "images/icons/swap.png", -- TODO: finish this
        check = function(tile)
            if tile.structure ~= nil then
                if tile.structure.type == "troop" and playerStat[currentPlayer].skills.swap.earned == true then
                    if tile.structure.swapping then
                        for _, tile in ipairs(tileHolder:getTiles()) do
                            if tile.structure ~= nil and tile.control == currentPlayer then
                                if string.find(tile.structure.type, "troop") ~= nil then
                                    local tileCopy = deepCopy(tile)
                                    tileCopy.image = "images/move.png"
                                    table.insert(interactibleTiles.tiles, tileCopy)
                                    interactibleTiles.tiles[#interactibleTiles.tiles].callback = function(tile, newTile)
                                        selectedTile.structure.swapping = false

                                        local temp = deepCopy(newTile.structure)
                                        newTile.structure = selectedTile.structure
                                        newTile.structure.x = newTile.x
                                        newTile.structure.y = newTile.y
                                        newTile.structure.moved = true
                                        newTile.control = selectedTile.control

                                        selectedTile.structure = temp
                                        selectedTile.structure.x = selectedTile.x
                                        selectedTile.structure.y = selectedTile.y
                                        selectedTile.structure.moved = true
                                        selectedTile.control = temp.control
                                    end
                                end
                            end
                        end
                    end
                    return true
                end
            end
        end,
        action = function()
            selectedTile.structure.swapping = true
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
        tooltip = "Collect minerals (+1)",
        image = "images/icons/drill.png",
        check = function(tile)
            if tile.structure ~= nil then
                return tile.structure.type == "mineral" and tile.insideCity == true and playerStat[currentPlayer].skills.drilling.earned == true
            end
        end,
        action = function()
            selectedTile.structure = nil
            playerStat[currentPlayer].crystalNum = playerStat[currentPlayer].crystalNum + 1
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
        if selectedTile.structure ~= nil then
            if newTile.moveCallback then
                newTile.moveCallback(tile, newTile)
                if selectedTile.structure == nil then
                    return
                end
            end
            if newTile.structure ~= nil then
                newTile.structure.health = newTile.structure.health - 1
                if newTile.structure.health > 0 then
                    newTile.structure.moved = true
                    return
                end
                -- live tiles would have returned already
                if newTile.structure.destructionCallback ~= nil then
                    ---@diagnostic disable-next-line: redundant-parameter
                    newTile.structure.destructionCallback(newTile)
                end
            end
            newTile.structure = selectedTile.structure
            newTile.structure.x = newTile.x
            newTile.structure.y = newTile.y
            newTile.structure.moved = true
            newTile.control = selectedTile.control
            selectedTile.structure = nil
            if not selectedTile.insideCity then
                selectedTile.control = nil
            end
        end
    end

    local directions = {}
    for dx = -distance, distance do
        for dy = -distance, distance do
            if math.abs(dx) + math.abs(dy) <= distance and (dx ~= 0 or dy ~= 0) then
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
        elseif targetTile then
            if targetTile.structure ~= nil and targetTile.control ~= currentPlayer then
                if targetTile.structure.health ~= nil then -- if it has health you can hit it (true)
                    local tileCopy = deepCopy(targetTile)
                    tileCopy.image = "images/attack.png"
                    table.insert(interactibleTiles.tiles, tileCopy)
                    interactibleTiles.tiles[#interactibleTiles.tiles].callback = function(tile, newTile)
                        moveTile(tile, newTile)
                    end
                end
            end
        end
    end
end