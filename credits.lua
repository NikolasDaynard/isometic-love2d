credits = {
    open = false
}

function credits:render()
    if not self.open then
        return
    end

    love.graphics.setColor(0, 0, 0)
    local windowWidth, windowHeight, windowMode = love.window.getMode()
    love.graphics.rectangle("fill", 0, 0, windowWidth + cam:getX(), (windowHeight / cam:getScale()) + cam:getY())
    love.graphics.setColor(1, 1, 1)

    love.graphics.setFont(realbigfont)

    love.graphics.print("Credit to:", 1200 / 1.5 - 400, 600 / 2 - 200)
    love.graphics.print("Nikolas Daynard: Programmer", 1200 / 2 - 400, 600 / 2)
    love.graphics.print("Jayden Weng: Soundtrack", 1200 / 2 - 400, 600 / 2 + 200)
    -- love.graphics.setFont(font)
    love.graphics.print("Matthias Richter: Camera Library", 1200 / 2 - 400, 600 / 2 + 400)
    love.graphics.print("Shunsuke Shimizu: Json Library", 1200 / 2 - 400, 600 / 2 + 440)
    -- love.graphics.setFont(realbigfont)
    love.graphics.print("Special thanks to the people working on LOVE!", 1200 / 2 - 400, 600 / 2 + 480)
end