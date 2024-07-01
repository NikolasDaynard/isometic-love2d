require("helpers")

isometricRenderer = {
    rotation = 0
}

-- tiles on the same level are y 5 diff
-- 32 between levels
-- 16 per x

local maxSizeX = 100 * 32

function isometricRenderer:rotateCoords(x, y, rotation)
    if rotation == 90 then
        return y + 30, -x + 50
    elseif rotation == 180 then
        return -x + 100, -y + 30
    elseif rotation == 270 then
        return -y + 50, x - 50
    else
        return x, y
    end
end

function isometricRenderer:render(rotation)
    rotation = rotation or 0

    self.rotation = rotation

    local tiles = tileHolder:getTiles()

    -- Sort tiles to ensure correct rendering order
    table.sort(tiles, function(a, b)
        local ax, ay = isometricRenderer:rotateCoords(a.x, a.y, rotation)
        local bx, by = isometricRenderer:rotateCoords(b.x, b.y, rotation)
        return (ax < bx) or (ax == bx and ay < by)
    end)

    for _, tile in ipairs(tiles) do
        local x, y = isometricRenderer:rotateCoords(tile.x, tile.y, rotation)
        love.graphics.setColor(1, 1, 1)
        if tile.control ~= currentPlayer and tile.control then
            love.graphics.setColor(.7, .6, .5)
        end
        if tile.wealth then
            r, g, b = love.graphics.getColor()
            love.graphics.setColor(r - .4, g - .3, b + .5)
        end

        if tile ~= selectedTile then
            imageLib:drawImage(y * 32 + ((math.abs(x) % 2) * 16), (x * 5) + (tile.height * 16), tile.image)
        else
            imageLib:drawImage(y * 32 + ((math.abs(x) % 2) * 16), (x * 5) + (tile.height * 16), "images/tiles/tileSelected.png")
            if tile.structure ~= nil then
                love.graphics.setColor(0, .2, 1)
                isometricRenderer:renderTileBackground(tile.structure)
                love.graphics.setColor(1, 1, 1)
            end
        end
        if tile.controlRender and tile.control == currentPlayer then
            tile.controlRender(tile)
        end
        if tile.structure ~= nil then
            isometricRenderer:renderTile(tile.structure)
            if tile.structure.controlRender and (tile.control == currentPlayer or tile.illuminated) then
                tile.structure.controlRender(tile)
            end
        end
        if tile.control == currentPlayer then
            -- isometricRenderer:renderTile({x = tile.x, y = tile.y, height = tile.height, image = "images/testing.png", structure = nil})
        end
    end
end

function isometricRenderer:renderTile(tile)
    if tile.moved == true then love.graphics.setColor(0.4, 0.4, 0.4) end -- grey out moved units

    local x, y = isometricRenderer:rotateCoords(tile.x, tile.y, self.rotation)

    -- iteractable tiles go above
    imageLib:drawImage(y * 32 + ((x % 2) * 16), (x * 5) + (tile.height * 16) - 14, tile.image)

    love.graphics.setColor(1, 1, 1)
end

-- renders the gb for selected tiles these numbers aint right but whatever
function isometricRenderer:renderTileBackground(tile)
    local x, y = isometricRenderer:rotateCoords(tile.x, tile.y, self.rotation)

    local scaleX = 34 / 32
    local scaleY = 34 / 32

    imageLib:drawImage(
        y * 32 + ((x % 2) * 16) - scaleX, (x * 5) + (tile.height * 16) - 14 - scaleY,
        tile.image, 
        scaleX, 
        scaleY
    )
end


function isometricRenderer:whatTileClickHit(x, y)
    local bestTile = nil
    local bestScore = math.huge  -- Initialize with a large number

    for _, tile in ipairs(tileHolder:getTiles()) do
        local tilePos = IsoCordToWorldSpace(tile.x, tile.y, tile.height, self.rotation)
        local tileX, tileY = tilePos.x, tilePos.y

        if x > tileX and x < tileX + 64 and y > tileY and y < tileY + 64 then
            local centerX = tileX + 16
            local centerY = tileY + 30
            local score = distance(centerX, centerY, x, y)

            if score < bestScore then
                bestScore = score
                bestTile = tile
            end
        end
    end

    return bestTile
end
