-- this is for static ui :)
require("image")
require("helpers")
ui = {}

function ui:render() 
    width, height, flags = love.window.getMode()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, width, 20)
    love.graphics.setColor(1, 1, 1)

    imageLib:drawImage(2, 2, "images/icons/collect.png")
    imageLib:drawImage(width - 20, 2, "images/icons/turnpass.png")
    love.graphics.setFont(font)
    love.graphics.print("Ooze: " .. oozeNum .. " + (" .. oozesPerTurn .. ")", 23, 1)
end

function ui:click(x, y) 
    if love.mouse.isDown(1) then
        if clickHitButton(x, y, width - 20, 2, 16) then
            oozeNum = oozeNum + oozesPerTurn
            for _, tile in ipairs(tileHolder:getTiles()) do 
                if tile.structure then
                    tile.structure.moved = false
                end
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