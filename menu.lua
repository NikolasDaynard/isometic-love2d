menu = {
    open = false,
    holdingEsc = false,
    skills = {
        sawSlime = {x = .5, y = .5, earned = false, image = "images/drillwarrior.png"}
        -- sawSlime = {x = 100, y = 100, earned = false, image = "images/drillwarrior.png"}
    },
    scrollOffset = 0
}

local function menuToScreen(x, y)
    return {x = (ui.x * width) - 16, y = (ui.y * height) - 16}
end

function menu:update()
    if love.keyboard.isDown("escape") then
        if not self.holdingEsc then
            self.open = not self.open
            self.holdingEsc = true
        end
    else
        self.holdingEsc = false
    end
end

function menu:render()
    local width, height = love.window.getMode()
    if menu.open then
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", 0, 0, width, height)
        love.graphics.setColor(1, 1, 1)
    end

    for _, ui in pairs(menu.skills) do
        imageLib:drawImage((ui.x * width) - 32, (ui.y * height) - 32, "images/skillTree/skillUnearnedUi.png")
        imageLib:drawCircleClipped((ui.x * width) - 16, (ui.y * height) - 16, ui.image, 32)
    end

end

function menu:click(x, y)
    for _, ui in pairs(menu.skills) do
        if clickHitButton(x, y, menuToScreen(ui.x).x, menuToScreen(ui.y).y, 32) then
            print("yass")
        end
    end
end