require("ui")

menu = {
    open = false,
    holdingEsc = false,
    skills = {
        drilling = {x = 0, y = 0, earned = false, image = "images/skillTree/DrillingSkill.png", text = "Drilling",
        description = "Allows you to drill mineral deposits",
        price = 3},
        slimes3 = {x = .2, y = 0, earned = false, image = "images/skillTree/3warriorSkill.png", text = "Triple Slime",
        description = "3 slimes ready to fight for you, they all seem to have different priorities, but mostly fighting for you",
        price = 3,
        },
        disguise = {x = .7, y = .5, earned = false, image = "images/skillTree/disguiseSkill.png", text = "Cloning",
        description = "A dark magic conceals the form of the slime until it moves for 1 slime",
        price = 3,
        },
        dissolve = {x = .7, y = .6, earned = false, image = "images/skillTree/dissolveSkill.png", text = "Dissolve",
        description = "A mysterious force crushes the slime and converts the tile into a city tile",
        price = 3,
        },
        expand = {x = .9, y = .5, earned = false, image = "images/skillTree/expandSkill.png", text = "Expansion",
        description = "A blinding light alters the slime",
        price = 3,
        },
        telekinisis = {x = 1, y = .5, earned = false, image = "images/skillTree/telekinisisSkill.png", text = "Telekinisis",
        description = "A blinding force binds and harms slime",
        price = 3,
        },
        twist = {x = 1.1, y = .5, earned = false, image = "images/skillTree/twistSkill.png", text = "Twist",
        description = "A white light twists the slime and converts it into another unit",
        price = 3,
        },
        -- sawSlime = {x = 100, y = 100, earned = false, image = "images/drillwarrior.png"}
    },
    worldCameraPos = {},
    tooltip = nil,
    selectedSkill = nil,
    openedMenuSize = {x = 200, y = 200},
    clicking = false
}
-- sawSlime is locked behind drilling
menu.skills.sawSlime = {x = 0, y = -.2, earned = false, image = "images/skillTree/drillwarriorSkill.png", 
    text = "sawslime",
    description = "A slime engineered to spin ooze at a high speed turning it into the perfect drilling machine",
    price = 3,
    link = menu.skills.drilling
}

local function menuToScreen(x, y)
    return {x = (x * width) - 16, y = (y * height) - 16}
end

function menu:isClickInButton(x, y, posX, posY, w, h)
    return x > posX and x < posX + w and y > posY and y < posY + h
end

function menu:update()
    if love.keyboard.isDown("escape") then
        if not self.holdingEsc then
            self.open = not self.open
            if self.open then
                self.worldCameraPos.x, self.worldCameraPos.y = cam:position()
                cam:lookAt(0, 0)
            else
                cam:lookAt(self.worldCameraPos.x, self.worldCameraPos.y)
            end
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
        if ui.earned then
            imageLib:drawImage((ui.x * width) - 32, (ui.y * height) - 32, "images/skillTree/skillEarnedUi.png")
        elseif self.selectedSkill == ui then
            imageLib:drawImage((ui.x * width) - 32, (ui.y * height) - 32, "images/skillTree/skillSelectedUi.png")
        else
            imageLib:drawImage((ui.x * width) - 32, (ui.y * height) - 32, "images/skillTree/skillUnearnedUi.png")
        end
        if ui.link ~= nil then
            love.graphics.line(menuToScreen(ui.x, ui.y).x + 32, menuToScreen(ui.x, ui.y).y + 32,
            menuToScreen(ui.link.x, ui.link.y).x + 32, menuToScreen(ui.link.x, ui.link.y).y + 32)
            if ui.link.earned ~= true then
                love.graphics.setColor(0.2, 0.2, 0.2)
            end
        end

        imageLib:drawCircleClipped((ui.x * width) - 16, (ui.y * height) - 16, ui.image, 32)
        love.graphics.setColor(1, 1, 1)
    end
    if self.tooltip then
        ui:renderTooltip(self.tooltip.text, self.tooltip.x, self.tooltip.y)
    end
    if self.selectedSkill ~= nil then
        local maxWidth = 280

        imageLib:drawImage((width / 2) - 160, height / 2 - 120, "images/skillTree/ConfirmUi.png") --  -80 is center
        imageLib:drawImage((width / 2) - 160, height / 2 + 10, "images/skillTree/PurchaseUi.png")

        love.graphics.setFont(realbigfont)
        love.graphics.print(self.selectedSkill.price, (width / 2) - 20, height / 2 + 60)

        love.graphics.setFont(smallfont)

        -- printf wrapps text which is cool
        love.graphics.printf(self.selectedSkill.description, (width / 2) - 130, (height / 2) - 60, maxWidth, "left")
    end

end

function menu:click(x, y)
    self.tooltip = nil
    for _, skillUi in pairs(menu.skills) do
        if self.selectedSkill ~= nil then
            if love.mouse.isDown(1) then
                if not self.clicking then -- ui for the input
                    if menu:isClickInButton(x, y, (width / 2) - 160, height / 2 + 10, 320, 120) and oozeNum - self.selectedSkill.price >= 0 and self.selectedSkill.earned ~= true then
                        oozeNum = oozeNum - self.selectedSkill.price
                        self.selectedSkill.earned = true
                        self.selectedSkill = nil
                    end
                    -- if it's not in some arbitary bounding box
                    if not menu:isClickInButton(x, y, (width / 2) - 160, (height / 2) - 120, 320, 220) then
                        self.selectedSkill = nil
                    end
                    self.clicking = true
                end
            end
        end
        -- actual icons
        if clickHitButton(x, y, menuToScreen(skillUi.x, skillUi.y).x + 32, menuToScreen(skillUi.x, skillUi.y).y + 32, 32) and not self.clicking then
            self.tooltip = {text = skillUi.text, x = menuToScreen(skillUi.x, skillUi.y).x + 32, y = menuToScreen(skillUi.x, skillUi.y).y + 64}
            if love.mouse.isDown(1) then
                if skillUi.link == nil then
                    self.selectedSkill = skillUi
                    self.clicking = true
                elseif skillUi.link.earned then
                    self.selectedSkill = skillUi
                    self.clicking = true
                end
            end
        end
    end
    if not love.mouse.isDown(1) then
        self.clicking = false
    end
end