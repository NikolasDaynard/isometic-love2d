isometricRenderer = {
    -- tiles = {}
}

-- tiles on the same level are y 5 diff
-- 32 between levels
-- 16 per x

function isometricRenderer:render()
    for _, tile in ipairs(tileHolder:getTiles()) do
        imageLib:drawImage(tile.y * 32 + ((tile.x % 2) * 16), (tile.x * 5) + (tile.height * 16), tile.image, -1)
        if tile.structure ~= nil then
            isometricRenderer:renderTile(tile.structure, (tile.height * 16))
        end
    end
end

function isometricRenderer:renderTile(tile)
    -- iteractable tiles go above
    imageLib:drawImage(tile.y * 32 + ((tile.x % 2) * 16), (tile.x * 5) + (tile.height * 16) - 14, tile.image, -1)
end

function isometricRenderer:clickHitsTile(x, y, tile)
    local tileX = tile.y * 32 + ((tile.x % 2) * 16)
    local tileY = (tile.x * 5) + (tile.height * 16) - 16
    -- print("tilex: ".. tileX)
    -- print("tiley: ".. tileY)
    -- print("mousex: ".. x)
    -- print("mousey: ".. y)
    return x > tileX and x < tileX + 32 and y > tileY and y < tileY + 32
end