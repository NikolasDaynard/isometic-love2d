local simplex = require("simplex")

tileHolder = {
    tiles = {}
}

function tileHolder:newTile(x, y, height, image)
    newTile = {x = x, y = y, height = height, image = image, structure = nil}
    table.insert(self.tiles, newTile)
    return newTile
end

function tileHolder:getTileAtPos(x, y)
    for _, tile in ipairs(tileHolder:getTiles()) do
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
            local randHeight = simplex.Noise2D(i, j)
            randHeight = 0
            local newTile = tileHolder:newTile(i, j, randHeight, "tilesmudge.png")
            -- newTile.structure = {x = i, y = j, height = randHeight, image = "city.png", structure = nil}
        end
    end
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