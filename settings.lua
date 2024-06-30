settings = {
    open = false
}

function settings:render()
    if not settings.open then
        return
    end
    cam:lookAt(1200 / 2, 600 / 2)
    love.graphics.setColor(0, 0, 0)
    local windowWidth, windowHeight, windowMode = love.window.getMode()
    love.graphics.rectangle("fill", 0, 0, windowWidth + cam:getX(), windowHeight + cam:getY())
    love.graphics.setColor(1, 1, 1)
end

function settings:click(x, y)

end