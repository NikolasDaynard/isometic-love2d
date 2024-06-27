require("helpers")

isometricRenderer = {
    rotation = 0
}

-- tiles on the same level are y 5 diff
-- 32 between levels
-- 16 per x

local function rotateCoords(x, y, rotation)
    if rotation == 90 then
        return y, -x
    elseif rotation == 180 then
        return -x, -y
    elseif rotation == 270 then
        return -y, x
    else
        return x, y
    end
end

function isometricRenderer:render(rotation)
    rotation = rotation or 0

    if love.keyboard.isDown("e") then
        rotation = 90
    end
    self.rotation = rotation

    local tiles = tileHolder:getTiles()

    -- Sort tiles to ensure correct rendering order
    table.sort(tiles, function(a, b)
        local ax, ay = rotateCoords(a.x, a.y, rotation)
        local bx, by = rotateCoords(b.x, b.y, rotation)
        return (ax < bx) or (ax == bx and ay < by)
    end)

    for _, tile in ipairs(tiles) do
        local x, y = rotateCoords(tile.x, tile.y, rotation)

        if tile ~= selectedTile then
            imageLib:drawImage(y * 32 + ((math.abs(x) % 2) * 16), (x * 5) + (tile.height * 16), tile.image)
        else
            imageLib:drawImage(y * 32 + ((math.abs(x) % 2) * 16), (x * 5) + (tile.height * 16), "images/tileselected.png")
        end
        if tile.structure ~= nil then
            isometricRenderer:renderTile(tile.structure, (tile.height * 16))
        end
    end
end

-- if tile.insideCity then
    -- -- if tile.x % 2 == 1 then
    -- --     isometricRenderer:renderTile({x = tile.x, y = tile.y, height = tile.height, image = "player.png", structure = nil})
    -- -- end
    -- if (tileHolder:getTileAtPos(tile.x + 1, tile.y + 1) or {}).insideCity ~= true then
    --     isometricRenderer:renderTile({x = tile.x, y = tile.y, height = tile.height, image = "citywallRD.png", structure = nil})
    -- end
    -- if (tileHolder:getTileAtPos(tile.x + 1, tile.y) or {}).insideCity ~= true and (tileHolder:getTileAtPos(tile.x + 1, tile.y - 1) or {}).insideCity ~= true then
    --     isometricRenderer:renderTile({x = tile.x, y = tile.y, height = tile.height, image = "citywallLD.png", structure = nil})
    -- end
    -- if (tileHolder:getTileAtPos(tile.x - 1, tile.y) or {}).insideCity ~= true and (tileHolder:getTileAtPos(tile.x - 1, tile.y - 1) or {}).insideCity ~= true then
    --     isometricRenderer:renderTile({x = tile.x, y = tile.y, height = tile.height, image = "citywallLU.png", structure = nil})
    -- end
    -- -- if tileHolder:getTileAtPos(tile.x + 1, tile.y - 1).insideCity ~= true then
    -- --     isometricRenderer:renderTile({x = tile.x, y = tile.y, height = tile.height, image = "citywallLD.png", structure = nil})
    -- -- end
    -- if (tileHolder:getTileAtPos(tile.x, tile.y + 1) or {}).insideCity ~= true then
    --     isometricRenderer:renderTile({x = tile.x, y = tile.y, height = tile.height, image = "citywallRU.png", structure = nil})
    -- end
-- end
function isometricRenderer:renderTile(tile)
    local x, y = rotateCoords(tile.x, tile.y, self.rotation)

    -- iteractable tiles go above
    imageLib:drawImage(y * 32 + ((x % 2) * 16), (x * 5) + (tile.height * 16) - 14, tile.image)
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