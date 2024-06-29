-- this is for static ui :)
require("image")
require("helpers")
ui = {}

function ui:render()
    width, height, flags = love.window.getMode()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, width, 20)
    love.graphics.setColor(1, 1, 1)

    imageLib:drawImage(width - 30, 2, "images/icons/turnpass.png")
    love.graphics.setFont(font)
    local oozeString = "Ooze: " .. playerStat[currentPlayer].oozeNum .. " + (" .. playerStat[currentPlayer].oozesPerTurn .. ")"
    local mineralString = "Crystal: " .. playerStat[currentPlayer].crystalNum
    local oozeStringOffset = font:getWidth(oozeString)

    if oozeStringOffset + font:getWidth(mineralString) + 80 > width then
        oozeString = playerStat[currentPlayer].oozeNum .. " + (" .. playerStat[currentPlayer].oozesPerTurn .. ")"
        mineralString = playerStat[currentPlayer].crystalNum .. "" -- wow the jank
        oozeStringOffset = font:getWidth(oozeString)

        if oozeStringOffset + font:getWidth(mineralString) + 80 > width then
            oozeString = playerStat[currentPlayer].oozeNum .. ""
            mineralString = playerStat[currentPlayer].crystalNum .. ""
            oozeStringOffset = font:getWidth(oozeString)

            if oozeStringOffset + font:getWidth(mineralString) + 80 > width then
                oozeString = ""
                mineralString = "" 
                oozeStringOffset = font:getWidth(oozeString)
            end
        end
    end

    imageLib:drawImage(2, 2, "images/icons/collect.png")
    love.graphics.print(oozeString, 23, 1)
    imageLib:drawImage(32 + oozeStringOffset, 2, "images/icons/crystal.png")
    love.graphics.print(mineralString, 32 + 21 + oozeStringOffset, 2)

    if clickHitButton(love.mouse.getX(), love.mouse.getY(), 32 + oozeStringOffset + 8, 2 + 8, 8) then
        ui:renderTooltip("crystal", 32 + oozeStringOffset + 8, 2 + 18)
        love.graphics.setFont(font)
    elseif clickHitButton(love.mouse.getX(), love.mouse.getY(), 2 + 8, 2 + 8, 8) then
        ui:renderTooltip("ooze", 2 + 8, 2 + 18)
        love.graphics.setFont(font)
    elseif clickHitButton(love.mouse.getX(), love.mouse.getY(), width - 30 + 8, 2 + 8, 8) then
        ui:renderTooltip("pass turn", width - 70 + 8, 2 + 18)
        love.graphics.setFont(font)
    end
end

function ui:click(x, y)
    if love.mouse.isDown(1) then
        if clickHitButton(x, y, width - 20, 2, 16) then
            interactibleTiles.tiles = {}
            for _, tile in ipairs(tileHolder:getTiles()) do
                if tile.structure and tile.control == currentPlayer then
                    tile.structure.moved = false
                end
            end
            playerStat[currentPlayer].oozeNum = playerStat[currentPlayer].oozeNum + playerStat[currentPlayer].oozesPerTurn
            currentPlayer = currentPlayer + 1
            if currentPlayer > 2 then
                currentPlayer = 1
            end
            return true
        end
    end
    return false
end

function ui:renderTooltip(text, x, y)
    if text == nil then
        text = "nil"
    end
    text = interpolate(text)
    love.graphics.setFont(smallfont)
    love.graphics.print(text, x, y)
end