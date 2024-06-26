local simplex = require("simplex")

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
    function tileHolder:getTileAtPos(x, y)
        return self.tileMap[x .. "," .. y]
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
            local newTile = tileHolder:newTile(i, j, 0, "images/tilesmudge.png")
            if randHeight < .1 then
                local oozeImg
                if randHeight < .03 then
                    oozeImg = "images/resources/ooze1.png"
                elseif randHeight < .06 then
                    oozeImg = "images/resources/ooze2.png"
                else
                    oozeImg = "images/resources/ooze3.png"
                end
                newTile.structure = {x = i, y = j, height = 0, image = oozeImg, structure = nil, type = "ooze"}
            end
            -- newTile.structure = {x = i, y = j, height = randHeight, image = "city.png", structure = nil}
        end
    end
    for _, tile in ipairs(self.tiles) do
        self.tileMap[tile.x .. "," .. tile.y] = tile
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