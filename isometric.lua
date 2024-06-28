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

    if love.keyboard.isDown("e") then
        rotation = 90
    end
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

        if tile ~= selectedTile then
            imageLib:drawImage(y * 32 + ((math.abs(x) % 2) * 16), (x * 5) + (tile.height * 16), tile.image)
        else
            imageLib:drawImage(y * 32 + ((math.abs(x) % 2) * 16), (x * 5) + (tile.height * 16), "images/tiles/tileselected.png")
            if tile.structure ~= nil then
                love.graphics.setColor(0, .2, 1)
                isometricRenderer:renderTileBackground(tile.structure)
                love.graphics.setColor(1, 1, 1)
            end
        end
        if tile.structure ~= nil then
            isometricRenderer:renderTile(tile.structure)
        end
        if tile.insideCity then
            local x, y = tile.x, tile.y

            -- Check adjacent tiles THESE ARE RIGHT
            local down = tileHolder:getTileAtPos(x + 1, y) or {}
            local up = tileHolder:getTileAtPos(x - 1, y) or {}
            local left = tileHolder:getTileAtPos(x, y - 1) or {}
            local right = tileHolder:getTileAtPos(x, y + 1) or {}
            local left_down = tileHolder:getTileAtPos(x + 1, y - 1) or {}
            local right_down = tileHolder:getTileAtPos(x + 1, y + 1) or {}
            local left_up = tileHolder:getTileAtPos(x - 1, y - 1) or {}
            local right_up = tileHolder:getTileAtPos(x - 1, y + 1) or {}

            -- if not left.insideCity then
            --     isometricRenderer:renderTile({x = x, y = y, height = tile.height, image = "images/citywallLU.png", structure = nil})
            --     isometricRenderer:renderTile({x = x, y = y, height = tile.height, image = "images/citywallRU.png", structure = nil})
            -- end
            if not down.insideCity then
                if not left_down.insideCity then -- down right
                    isometricRenderer:renderTile({x = x, y = y, height = tile.height, image = "images/citywallLD.png", structure = nil})
                end
                if not right_down.insideCity then -- down right
                    isometricRenderer:renderTile({x = x, y = y, height = tile.height, image = "images/citywallRD.png", structure = nil})
                end
            end
            if not up.insideCity then
                if not left_up.insideCity then
                    isometricRenderer:renderTile({x = x, y = y, height = tile.height, image = "images/citywallLU.png", structure = nil})
                end
                if not right_up.insideCity then
                    isometricRenderer:renderTile({x = x, y = y, height = tile.height, image = "images/citywallRU.png", structure = nil})
                end
            end
            if not left.insideCity then
                if not left_up.insideCity then
                    isometricRenderer:renderTile({x = x, y = y, height = tile.height, image = "images/citywallLU.png", structure = nil})
                end
                if not left_down.insideCity then
                    isometricRenderer:renderTile({x = x, y = y, height = tile.height, image = "images/citywallLD.png", structure = nil})
                end
            end
            if not right.insideCity then
                if not right_up.insideCity then
                    isometricRenderer:renderTile({x = x, y = y, height = tile.height, image = "images/citywallRU.png", structure = nil})
                end
                if not right_down.insideCity then
                    isometricRenderer:renderTile({x = x, y = y, height = tile.height, image = "images/citywallRD.png", structure = nil})
                end
            end
        end
    end
end

function isometricRenderer:renderTile(tile)
    local x, y = isometricRenderer:rotateCoords(tile.x, tile.y, self.rotation)

    -- iteractable tiles go above
    imageLib:drawImage(y * 32 + ((x % 2) * 16), (x * 5) + (tile.height * 16) - 14, tile.image)
end

-- renders the gb for selected tiles these numbers aint right but whatever
function isometricRenderer:renderTileBackground(tile)
    local x, y = isometricRenderer:rotateCoords(tile.x, tile.y, self.rotation)

    local scaleX = 34 / 32
    local scaleY = 34 / 32

    imageLib:drawImage(
        y * 32 + ((x % 2) * 16) - 1, 
        (x * 5) + (tile.height * 16) - 15, 
        tile.image, 
        scaleX, 
        scaleY
    )
end


function isometricRenderer:whatTileClickHit(x, y)
    local bestTile = nil
    for  _, tile in ipairs(tileHolder:getTiles()) do
        local tileX = IsoCordToWorldSpace(tile.x, tile.y, tile.height, self.rotation).x
        local tileY = IsoCordToWorldSpace(tile.x, tile.y, tile.height, self.rotation).y
        if x > tileX and x < tileX + 32 and y > tileY and y < tileY + 32 then
            if bestTile == nil then
                bestTile = tile
            else
                local bestTileX = IsoCordToWorldSpace(bestTile.x, bestTile.y, bestTile.height, self.rotation).x
                local bestTileY = IsoCordToWorldSpace(bestTile.x, bestTile.y, bestTile.height, self.rotation).y
                if bestTileY > tileY then
                    bestTile = tile
                end
            end
        end
    end
    return bestTile
end