local simplex = require("simplex")

isometricRenderer = {
    tiles = {}
}

-- tiles on the same level are y 5 diff
-- 32 between levels
-- 16 per x

function isometricRenderer:render()
    for _, tile in ipairs(self.tiles) do
        imageLib:drawImage(tile.x * 32 + ((tile.y % 2) * 16), (tile.y * 5) + (tile.height * 16), tile.image, -1)
    end
end

function isometricRenderer:renderTile(tile)
    -- iteractable tiles go above
    imageLib:drawImage(tile.y * 32 + ((tile.x % 2) * 16), (tile.x * 5) + (tile.height * 16) - 14, tile.image, -1)
end


function isometricRenderer:createMap()
    local resolution = 100
    local noiseMap = createNoiseMap(resolution)
    for i = 0, 100 do
        for j = 0, 30 do
            table.insert(self.tiles, {x = j, y = i, height = math.random(0, 1), image = "tilesmudge.png"})
        end
    end
end

function isometricRenderer:clickHitsTile(x, y, tile)
    local tileX = tile.y * 32 + ((tile.x % 2) * 16)
    local tileY = (tile.x * 5) + (tile.height * 16) - 16
    return x > tileX and x < tileX + 32 and y > tileY and y < tileY + 32
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