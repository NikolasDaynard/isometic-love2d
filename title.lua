require("ui")

title = {
    open = true,
    clicking = false,
    time = 0,
}

function title:render()
    self.time = self.time + 1
    if not title.open then
        return
    end
    if self.time < 320 then
        cam:zoomTo(math.min(((self.time / 30) ^ 2), .3))
    elseif self.time < 320 * 2 then
        cam:zoomTo(math.min(((self.time / 100) ^ 2), .5))
    elseif self.time < 320 * 3 then
        cam:zoomTo(math.min(((self.time / 800) ^ 1.2), .7))
    end
    cam:lookAt(1300 / 2, 600 / 2)
    love.graphics.setColor(0, 0, 0)
    local windowWidth, windowHeight, windowMode = love.window.getMode()
    love.graphics.rectangle("fill", 0, 0, windowWidth + cam:getX(), windowHeight + cam:getY())
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