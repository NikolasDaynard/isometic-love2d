local simplex = require("simplex")
require("helpers")

tileHolder = {
    tiles = {},
    tileMap = {}
}

function tileHolder:newTile(x, y, height, image, type)
    newTile = {x = x, y = y, height = height, image = image, structure = nil, type = type}
    table.insert(self.tiles, newTile)
    return newTile
end

function tileHolder:getTileAtPos(x, y)
    return self.tileMap[x .. "," .. y]
end
function tileHolder:getTileAtPosDumb(x, y)
    for _, tile in ipairs(self.tiles) do
        if tile.x == x and tile.y == y then
            return tile
        end
    end
end

function tileHolder:getTiles()
    return self.tiles
end

function tileHolder:createMap()
    local resolution = 100
    local noiseMap = createNoiseMap(resolution)
    for i = 0, 100 do
        for j = 0, 30 do
            local randHeight = math.random(0, 100) / 100
            local newTile = tileHolder:newTile(i, j, 0, "images/tiles/tilesmudge.png")
            newTile.height = 1
            if randHeight > .999 then
                local mineralImg = "images/resources/mineral.png"
                newTile.structure = {x = i, y = j, height = 1, image = mineralImg, structure = nil, type = "mineral"}
            end
            local slimeOdds = 3
            if randHeight < .1 / slimeOdds  then
                local oozeImg
                if randHeight < .03 / slimeOdds then
                    oozeImg = "images/resources/ooze1.png"
                elseif randHeight < .06 / slimeOdds then
                    oozeImg = "images/resources/ooze2.png"
                else
                    oozeImg = "images/resources/ooze3.png"
                end
                newTile.structure = {x = i, y = j, height = 1, image = oozeImg, structure = nil, type = "ooze"}
                newTile.control = nil
            end
            -- newTile.structure = {x = i, y = j, height = randHeight, image = "city.png", structure = nil}
        end
    end
    for _, tile in ipairs(self.tiles) do
        self.tileMap[tile.x .. "," .. tile.y] = tile
    end
    local mounds = 0
    for i = 0, 100 do
        for j = 0, 30 do
            local randHeight = math.random(0, 100) / 100
            if randHeight < .5 and randHeight > .46 then
                local bestDist = math.huge
                local tileFound = false
                for i2 = 0, 100 do
                    for j2 = 0, 30 do
                        local tile = tileHolder:getTileAtPos(i2, j2)
                        if tile ~= nil then
                            if tile.structure ~= nil then
                                if tile.structure.type == "mound" then
                                    tileFound = true
                                    if distance(tile.structure.x, tile.structure.y, i, j) < bestDist then -- finding the closest
                                        bestDist = distance(tile.structure.x, tile.structure.y, i, j)
                                    end
                                end
                            end
                        end
                    end
                end
                if bestDist > 5 or not tileFound then
                    local tile = tileHolder:getTileAtPos(i, j)
                    tile.structure = {x = i, y = j, height = 1, image = "images/slimeMound.png", structure = nil, type = "mound"}
                    tile.control = nil
                    mounds = mounds + 1
                end
            end
        end
    end
    local moundCount = 0
    for i = 1, 2 do
        moundCount = 0
        local randCity = math.random(mounds)
        print(randCity)
        for i2 = 0, 100 do
            for j = 0, 30 do
                local newTile = tileHolder:getTileAtPos(i2, j)
                if ((newTile or {}).structure or {}).type == "mound" then

                    moundCount = moundCount + 1
                    if moundCount == randCity then
                        mounds = mounds - 1
                        newTile.structure = {x = newTile.x, y = newTile.y, height = newTile.height, image = "images/player.png", structure = nil, health = 10, maxHp = 10}
                        newTile.structure.type = "city"
                        newTile.structure.destructionCallback = function()
                            print("destroyed :(")
                        end
                        newTile.insideCity = true
                        newTile.structure.level = 3
                        for  _, nearTiles in ipairs(tileHolder:getTiles()) do
                            if distance(nearTiles.x, nearTiles.y, newTile.x, newTile.y) < newTile.structure.level then
                                nearTiles.image = "images/tiles/cityTile.png"
                                nearTiles.insideCity = true
                                nearTiles.control = i
                            end
                        end
                    end
                end
            end
        end
    end
    local tile = tileHolder:getTileAtPos(3,3)
    tile.structure = {x = 3, y = 3, height = 1, image = "images/troops/lurker.png", structure = nil, type = "troop", moveSpeed = 1, health = 1, maxHp = 1}
    tile.control = 1
end
function createNoiseMap(resolution)
    local map = {}
    for i = 0, resolution do
        map[i] = {} -- Initialize inner table
        for j = 0, resolution do
            rand = simplex.Noise2D(i, j)
            if rand < .25 then
                map[i][j] = -1
            elseif rand > .75 then
                map[i][j] = 1
            else
                map[i][j] = 0
            end
        end
    end
    
    return map
end