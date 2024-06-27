require("ui")

menu = {
    open = false,
    holdingEsc = false,
    skills = {
        sawSlime = {x = .5, y = .5, earned = false, image = "images/drillwarrior.png", text = "sawslime"},
        slimes3 = {x = .6, y = .5, earned = false, image = "images/3warrior.png", text = "sawslime"},
        -- sawSlime = {x = 100, y = 100, earned = false, image = "images/drillwarrior.png"}
    },
    scrollOffset = 0,
    tooltip = nil,
    selectedSkill = nil,
}

local function menuToScreen(x, y)
    return {x = (x * width) - 16, y = (y * height) - 16}
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
    if not menu.open then
        return
    end

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
    if self.tooltip then
        ui:renderTooltip(self.tooltip.text, self.tooltip.x, self.tooltip.y)
    end
    if self.selectedSkill ~= nil then
        love.graphics.setColor(.5, .5, .5)
        love.graphics.rectangle("fill", menuToScreen(self.selectedSkill.x, self.selectedSkill.y).x,
            menuToScreen(self.selectedSkill.x, self.selectedSkill.y).y, 300, 500)
        love.graphics.setColor(1, 1, 1)
        
        love.graphics.setFont(smallfont)
        love.graphics.print("", menuToScreen(self.selectedSkill.x, self.selectedSkill.y).x,
            menuToScreen(self.selectedSkill.x, self.selectedSkill.y).y)
    end

end

function menu:click(x, y)
    self.tooltip = nil
    for _, skillUi in pairs(menu.skills) do
        if clickHitButton(x, y, menuToScreen(skillUi.x, skillUi.y).x + 32, menuToScreen(skillUi.x, skillUi.y).y + 32, 32) then
            self.tooltip = {text = skillUi.text, x = menuToScreen(skillUi.x, skillUi.y).x + 32, y = menuToScreen(skillUi.x, skillUi.y).y + 64}
            if love.mouse.isDown(1) then
                -- self.openMenu = {x = skillUi.x, y = skillUi.y, w = 400, h = 100}
                self.selectedSkill = skillUi
            end
        end
    end
end