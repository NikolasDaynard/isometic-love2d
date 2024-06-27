require("ui")

menu = {
    open = false,
    holdingEsc = false,
    skills = {
        sawSlime = {x = .5, y = .5, earned = false, image = "images/drillwarrior.png", 
            text = "sawslime",
            description = "A slime engineered to spin ooze at a high speed turning it into the perfect drilling machine",
            price = 3
        },
        slimes3 = {x = .6, y = .5, earned = false, image = "images/3warrior.png", text = "Triple Slime", price = 3},
        -- sawSlime = {x = 100, y = 100, earned = false, image = "images/drillwarrior.png"}
    },
    scrollOffset = 0,
    tooltip = nil,
    selectedSkill = nil,
    openedMenuSize = {x = 200, y = 200},
    clicking = false
}

local function menuToScreen(x, y)
    return {x = (x * width) - 16, y = (y * height) - 16}
end

function menu:isClickInButton(x, y, posX, posY, w, h)
    return x > posX and x < posX + w and y > posY and y < posY + h
end

function menu:isClickInWindow(x, y, posX, posY)
    return x > posX and x < posX + self.openedMenuSize.x and y > posY and y < posY + self.openedMenuSize.y
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
        -- love.graphics.setColor(.5, .5, .5)
        -- love.graphics.rectangle("fill", menuToScreen(self.selectedSkill.x, self.selectedSkill.y).x,
        --     menuToScreen(self.selectedSkill.x, self.selectedSkill.y).y, 300, 500)
        -- love.graphics.setColor(1, 1, 1)

        local maxWidth = 280

        imageLib:drawImage((width / 2) - 160, height / 2 - 120, "images/skillTree/ConfirmUi.png") --  -80 is center
        imageLib:drawImage((width / 2) - 160, height / 2 + 10, "images/skillTree/PurchaseUi.png")
        
        love.graphics.setFont(smallfont)
        local textWidth = love.graphics.getFont():getWidth(self.selectedSkill.description)
        local textHeight = love.graphics.getFont():getHeight(self.selectedSkill.description)
        
        -- printf wrapps text which is cool
        love.graphics.printf(self.selectedSkill.description, (width / 2) - 130, (height / 2) - 30, maxWidth, "left")
    end

end

function menu:click(x, y)
    self.tooltip = nil
    for _, skillUi in pairs(menu.skills) do
        if self.selectedSkill ~= nil then
            if love.mouse.isDown(1) then
                if not self.clicking then
                    if menu:isClickInButton(x, y, (width / 2) - 160, height / 2 + 10, 320, 160) then
                        oozeNum = oozeNum - self.selectedSkill.price
                        self.selectedSkill = nil
                    end
                    -- if it's not in some arbitary bounding box
                    if not menu:isClickInButton(x, y, (width / 2) - 120, height / 2 + 10, 320, 220) then
                        self.selectedSkill = nil
                    end
                end
            else
                self.clicking = false
            end
        end
        if clickHitButton(x, y, menuToScreen(skillUi.x, skillUi.y).x + 32, menuToScreen(skillUi.x, skillUi.y).y + 32, 32) then
            self.tooltip = {text = skillUi.text, x = menuToScreen(skillUi.x, skillUi.y).x + 32, y = menuToScreen(skillUi.x, skillUi.y).y + 64}
            if love.mouse.isDown(1) then
                self.selectedSkill = skillUi
                self.clicking = true
            end
        end
    end
end