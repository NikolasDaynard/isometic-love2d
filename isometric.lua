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
        if tile.insideCity then
            if tileHolder:getTileAtPos(tile.x + 1, tile.y).insideCity ~= true then
                isometricRenderer:renderTile({x = tile.x, y = tile.y, height = tile.height, image = "citywallD.png", structure = nil})
            end
            if tileHolder:getTileAtPos(tile.x - 1, tile.y).insideCity ~= true then
                isometricRenderer:renderTile({x = tile.x, y = tile.y, height = tile.height, image = "citywallU.png", structure = nil})
            end
            if tileHolder:getTileAtPos(tile.x, tile.y - 1).insideCity ~= true then
                isometricRenderer:renderTile({x = tile.x, y = tile.y, height = tile.height, image = "citywallL.png", structure = nil})
            end
            if tileHolder:getTileAtPos(tile.x, tile.y + 1).insideCity ~= true then
                isometricRenderer:renderTile({x = tile.x, y = tile.y, height = tile.height, image = "citywallR.png", structure = nil})
            end
        end
    end
end

function isometricRenderer:renderTile(tile)
    -- iteractable tiles go above
    imageLib:drawImage(tile.y * 32 + ((tile.x % 2) * 16), (tile.x * 5) + (tile.height * 16) - 14, tile.image)
end

function isometricRenderer:whatTileClickHit(x, y)
    local bestTile = nil
    for  _, tile in ipairs(tileHolder:getTiles()) do
        local tileX = IsoCordToWorldSpace(tile.x, tile.y, tile.height).x
        local tileY = IsoCordToWorldSpace(tile.x, tile.y, tile.height).y
        if x > tileX and x < tileX + 32 and y > tileY and y < tileY + 32 then
            if bestTile == nil then
                bestTile = tile
            else
                local bestTileX = bestTile.y * 32 + ((bestTile.x % 2) * 16)
                local bestTileY = (bestTile.x * 5) + (bestTile.height * 16) - 24
                if bestTileY > tileY then
                    bestTile = tile
                end
            end
        end
    end
    return bestTile
end