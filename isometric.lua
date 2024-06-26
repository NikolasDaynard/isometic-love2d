require("helpers")

isometricRenderer = {
    -- tiles = {}
}

-- tiles on the same level are y 5 diff
-- 32 between levels
-- 16 per x

function isometricRenderer:render()
    for _, tile in ipairs(tileHolder:getTiles()) do
        if tile ~= selectedTile then
            imageLib:drawImage(tile.y * 32 + ((tile.x % 2) * 16), (tile.x * 5) + (tile.height * 16), tile.image)
        else
            imageLib:drawImage(tile.y * 32 + ((tile.x % 2) * 16), (tile.x * 5) + (tile.height * 16), "tileselected.png")
        end
        if tile.structure ~= nil then
            isometricRenderer:renderTile(tile.structure, (tile.height * 16))
        end
    end
end

function isometricRenderer:renderTile(tile)
    -- iteractable tiles go above
    imageLib:drawImage(tile.y * 32 + ((tile.x % 2) * 16), (tile.x * 5) + (tile.height * 16) - 14, tile.image)
end

function isometricRenderer:clickHitsTile(x, y, tile)
    local tileX = tile.y * 32 + ((tile.x % 2) * 16)
    local tileY = (tile.x * 5) + (tile.height * 16) - 28
    -- print("tilex: ".. tileX)
    -- print("tiley: ".. tileY)
    -- print("mousex: ".. x)
    -- print("mousey: ".. y)
    return x > tileX and x < tileX + 32 and y > tileY and y < tileY + 32
end

function isometricRenderer:whatTileClickHit(x, y, tile)
    local bestTile = nil
    for  _, tile in ipairs(tileHolder:getTiles()) do
        local tileX = tile.y * 32 + ((tile.x % 2) * 16)
        local tileY = (tile.x * 5) + (tile.height * 16) - 28
        if x > tileX and x < tileX + 32 and y > tileY and y < tileY + 32 then
            if bestTile == nil then
                bestTile = tile
            else
                local bestTileX = bestTile.y * 32 + ((bestTile.x % 2) * 16)
                local bestTileY = (bestTile.x * 5) + (bestTile.height * 16) - 28
                if distance(x, y, bestTileX, bestTileY) > distance(x, y, tileX, tileY) then
                    bestTile = tile
                end
            end
        end
    end
    return bestTile
end