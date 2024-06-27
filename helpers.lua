function distance(x1, y1, x2, y2)
  return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end
function IsoCordToWorldSpace(x, y, height)
    height = height or 1
    local tileX = y * 32 + ((x % 2) * 16)
    local tileY = (x * 5) + (height * 16) - 24

    return {x = tileX, y = tileY}
end
function clickHitButton(x, y, buttonX, buttonY, buttonRadius)
    return distance(x, y, buttonX, buttonY) < buttonRadius
end
function clickHitRect(x, y, buttonX, buttonY, buttonW, buttonH)
    return x >= buttonX and x <= buttonX + buttonW and y >= buttonY and y <= buttonY + buttonH
end

function findRandomOpenTileAdjacent(x, y)
    local possibleOffsets = {
        {0, 1}, {0, -1}, {1, 1}, {1, -1}, 
        {-1, 1}, {-1, -1}, {-1, 0}, {1, 0}
    }
    local openTiles = {}

    for _, offset in ipairs(possibleOffsets) do
        local newX, newY = x + offset[1], y + offset[2]
        if (tileHolder:getTileAtPos(newX, newY)) ~= nil then
            if (tileHolder:getTileAtPos(newX, newY).structure) == nil then
                table.insert(openTiles, {newX, newY})
            end
        end
    end

    if #openTiles == 0 then
        return nil  -- No open adjacent tiles
    end

    local rand = math.random(1, #openTiles)
    return tileHolder:getTileAtPos(openTiles[rand][1], openTiles[rand][2])
end
