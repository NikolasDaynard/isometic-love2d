require("ui")

title = {
    open = true,
    clicking = false,
}

function title:render()
    if not title.open then
        return
    end
    cam:lookAt(1200 / 2, 600 / 2)
    love.graphics.setColor(0, 0, 0)
    local windowWidth, winodwHeight, windowMode = love.window.getMode()
    love.graphics.rectangle("fill", 0, 0, windowWidth + cam:getX(), winodwHeight + cam:getY())
    love.graphics.setColor(1, 1, 1)
    -- draw title
    imageLib:drawImage(0, 0, "images/ui/TitleStart.png")

end

function title:click(x, y)
    if clickHitRect(x, y, 100, 400, 900, 100) and love.mouse.isDown(1) then
        print("click")
        self.clicking = false
        self.open = false
    end
    if not love.mouse.isDown(1) then
        self.clicking = false
    end
end