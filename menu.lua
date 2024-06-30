require("ui")

-- fracture? Splits target into a bunch of VERY weak, could be used for or against

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
        twist = {x = -.2, y = 0, earned = false, image = "images/skillTree/twistSkill.png", text = "Twist",
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
menu.skills.sawSlime = {x = -.06, y = -.2, earned = false, image = "images/skillTree/drillwarriorSkill.png",
    text = "sawslime",
    description = "A slime engineered to spin ooze at a high speed turning it into the perfect drilling machine",
    price = 3,
    link = function() return playerStat[currentPlayer].skills.drilling end
}
menu.skills.giant = {x = -.06, y = -.4, earned = false, image = "images/skillTree/giantSkill.png", text = "Giant Slime",
    description = "A *giant* slime",
    price = 3,
    link = function() return playerStat[currentPlayer].skills.sawSlime end
}
menu.skills.brickSlime = {x = .01, y = -.6, earned = false, image = "images/skillTree/brickSlimeSkill.png", text = "Brick",
    description = "Brick slime is strong. Strong like brick. Brick hurt a lot,",
    price = 3,
    link = function() return playerStat[currentPlayer].skills.giant end
}
menu.skills.mechanisedSlime = {x = .02, y = -.47, earned = false, image = "images/skillTree/mechanisedSlimeSkill.png", text = "Mechanized Slime",
    description = "A mechanical slime",
    price = 3,
    link = function() return playerStat[currentPlayer].skills.crystalSlime end
}
menu.skills.build = {x = -.1, y = -.6, earned = false, image = "images/skillTree/buildSkill.png", text = "Build",
    description = "A raises the height of the tile",
    price = 3,
    link = function() return playerStat[currentPlayer].skills.giant end
}
menu.skills.rain = {x = -.03, y = -.8, earned = false, image = "images/skillTree/slimeRainSkill.png", text = "Rain",
    description = "A cloud of toxic slime rains down on the tile for a turn",
    price = 3,
    link = function() return playerStat[currentPlayer].skills.build end
}
menu.skills.slimeCo = {x = -.15, y = -.8, earned = false, image = "images/skillTree/slimeCo.png", text = "Slime Co.",
    description = "An industry built on the exponential nature of slime, though the slime doesn't stop with what they make!",
    price = 3,
    link = function() return playerStat[currentPlayer].skills.build end
}
menu.skills.wealth = {x = -.15, y = -1, earned = false, image = "images/skillTree/wealthSkill.png", text = "Wizard",
    description = "WEALTH WEALTH IT'S ALL MINE HAHAHAHAHAHAHHAHAHHAHAH",
    price = 3,
    link = function() return playerStat[currentPlayer].skills.slimeCo end
}
menu.skills.crystalSlime = {x = .06, y = -.2, earned = false, image = "images/skillTree/crystalwarriorSkill.png", text = "Crystal Slime",
    description = "A slime with a mineral shoved into it's head, granting it mystical powers",
    price = 3,
    link = function() return playerStat[currentPlayer].skills.drilling end
}
menu.skills.crystalize = {x = .1, y = -.35, earned = false, image = "images/skillTree/crystalizeSkill.png", text = "Crystal Slime",
    description = "A slime with extrodinary crystal coverage",
    price = 3,
    link = function() return playerStat[currentPlayer].skills.crystalSlime end
}
menu.skills.crystalGuardian = {x = .12, y = -.5, earned = false, image = "images/skillTree/crystalGuardianSkill.png", text = "Crystal Slime",
    description = "At what point is it no longer a slime?",
    price = 3,
    link = function() return playerStat[currentPlayer].skills.crystalize end
}
-- menu.skills.rouge = {x = .1, y = -.5, earned = false, image = "images/skillTree/crystalGuardianSkill.png", text = "Crystal Slime",
-- description = "At what point is it no longer a slime?",
-- price = 3,
-- link = function() return playerStat[currentPlayer].skills.crystalGuardian end
-- }

menu.skills.expand = {x = -.25, y = -.2, earned = false, image = "images/skillTree/expandSkill.png", text = "Expansion",
    description = "A blinding light alters the slime",
    price = 3,
    link = function() return playerStat[currentPlayer].skills.twist end
}
menu.skills.spirit = {x = -.4, y = -.25, earned = false, image = "images/skillTree/spiritSkill.png", text = "Spirit",
    description = "A ghastly incantaton of a deceased slime",
    price = 3,
    link = function() return playerStat[currentPlayer].skills.twist end
}
menu.skills.reincarnate = {x = -.4, y = -.4, earned = false, image = "images/skillTree/reincarnate.png", text = "Reincarnate",
    description = "A pure slime that sheds it's skin on death, coming back as a source of purity",
    price = 3,
    link = function() return playerStat[currentPlayer].skills.spirit end
}
menu.skills.framework = {x = -.55, y = -.4, earned = false, image = "images/skillTree/frameworkSkill.png", text = "Framework",
    description = "A shell of a slime, ready to be embued with the power of another it comes across",
    price = 3,
    link = function() return playerStat[currentPlayer].skills.spirit end
}
menu.skills.telekinisis = {x = -.3, y = -.4, earned = false, image = "images/skillTree/telekinisisSkill.png", text = "Telekinisis",
    description = "A blinding force binds and harms slime",
    price = 3,
    link = function() return playerStat[currentPlayer].skills.expand end
}
menu.skills.blessing = {x = -.3, y = -.55, earned = false, image = "images/skillTree/blessingSkill.png", text = "Blessing",
    description = "A blessing of white light heals and rejuvinates slime",
    price = 3,
    link = function() return playerStat[currentPlayer].skills.telekinisis end
}
menu.skills.fly = {x = -.2, y = -.3, earned = false, image = "images/skillTree/flySkill.png", text = "Fly",
    description = "A brilliant white force pushes the slime into the air",
    price = 3,
    link = function() return playerStat[currentPlayer].skills.twist end
}
menu.skills.whirlwind = {x = -.2, y = -.5, earned = false, image = "images/skillTree/whirlwindSkill.png", text = "Whirlwind",
    description = "A light force spins extremely fast knocking back and damaging all slimes it hits",
    price = 3,
    link = function() return playerStat[currentPlayer].skills.fly end
}
menu.skills.wizard = {x = -.2, y = -.7, earned = false, image = "images/skillTree/wizardSkill.png", text = "Wizard",
    description = "A wizard embued with crystal magic",
    price = 3,
    link = function() return {playerStat[currentPlayer].skills.whirlwind, playerStat[currentPlayer].skills.giant} end
}
menu.skills.strike = {x = -.25, y = -.9, earned = false, image = "images/skillTree/strikeSkill.png", text = "Wizard",
    description = "A flash white light strikes down the target",
    price = 3,
    link = function() return playerStat[currentPlayer].skills.wizard end
}
menu.skills.swap = {x = -.3, y = -.7, earned = false, image = "images/skillTree/swapSkill.png", text = "Swap",
    description = "A light force instantly swaps two slimes",
    price = 3,
    link = function() return playerStat[currentPlayer].skills.whirlwind end
}
menu.skills.dig = {x = .15, y = -.2, earned = false, image = "images/skillTree/digSkill.png", text = "Dig",
    description = "A dark magic pulls the ground downward caving in on itself",
    price = 3,
    link = function() return playerStat[currentPlayer].skills.slimes3 end
}
menu.skills.disguise = {x = .25, y = -.2, earned = false, image = "images/skillTree/disguiseSkill.png", text = "Cloning",
    description = "A dark magic conceals the form of the slime until it moves for 1 slime",
    price = 3,
    link = function() return playerStat[currentPlayer].skills.slimes3 end
}
menu.skills.networkSlime = {x = .35, y = -.2, earned = false, image = "images/skillTree/networkwarriorSkill.png", text = "Network Slime",
    description = "A small unassuming slime hooked into a large ooze network, giving it regerative properties",
    price = 3,
    link = function() return playerStat[currentPlayer].skills.slimes3 end
}
menu.skills.sleep = {x = .4, y = -.35, earned = false, image = "images/skillTree/sleepSkill.png", text = "Sleep",
    description = "A powerful dark incantation manages to stall out the slimes and put them to sleep",
    price = 3,
    link = function() return playerStat[currentPlayer].skills.networkSlime end
}
menu.skills.dissolve = {x = .2, y = -.4, earned = false, image = "images/skillTree/dissolveSkill.png", text = "Dissolve",
    description = "A mysterious force crushes the slime and converts the tile into a city tile",
    price = 3,
    link = function() return playerStat[currentPlayer].skills.disguise end
}
menu.skills.slimeTrap = {x = .25, y = -.5, earned = false, image = "images/skillTree/slimeTrapSkill.png", text = "Slime Trap",
    description = "A mysterious force grabs the slime and crushes them",
    price = 3,
    link = function() return playerStat[currentPlayer].skills.disguise end
}
menu.skills.hammer = {x = .25, y = -.65, earned = false, image = "images/skillTree/hammerSkill.png", text = "Hammer Slime",
    description = "A slime with a dark hammer radiating evil eneregy",
    price = 3,
    link = function() return playerStat[currentPlayer].skills.slimeTrap end
}
menu.skills.slimeCoil = {x = .15, y = -.65, earned = false, image = "images/skillTree/slimeCoilSkill.png", text = "Slime Coil",
    description = "An electic coil that melts slime",
    price = 3,
    link = function() return {playerStat[currentPlayer].skills.hammer, playerStat[currentPlayer].skills.mechanisedSlime} end
}
menu.skills.lurker = {x = .4, y = -.65, earned = false, image = "images/skillTree/lurkerSkill.png", text = "Lurker Slime",
    description = "A slime radiating evil energy",
    price = 3,
    link = function() return playerStat[currentPlayer].skills.hammer end
}
menu.skills.shred = {x = .25, y = -.8, earned = false, image = "images/skillTree/shredSkill.png", text = "Shred",
    description = "A powerful blast of short range dark energy targets anything",
    price = 3,
    link = function() return playerStat[currentPlayer].skills.hammer end
}
menu.skills.slimeArrowSkill = {x = 0.3, y = -.4, earned = false, image = "images/skillTree/slimeArrowSkill.png", text = "Slime Arrow",
    description = "A slime that shoots arrows from the cover of darkness",
    price = 3,
    link = function() return playerStat[currentPlayer].skills.disguise end
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

    for _, ui in pairs(playerStat[currentPlayer].skills) do
        if ui.earned then
            imageLib:drawImage((ui.x * width) - 32, (ui.y * height) - 32, "images/skillTree/skillEarnedUi.png")
        elseif self.selectedSkill == ui then
            imageLib:drawImage((ui.x * width) - 32, (ui.y * height) - 32, "images/skillTree/skillSelectedUi.png")
        else
            imageLib:drawImage((ui.x * width) - 32, (ui.y * height) - 32, "images/skillTree/skillUnearnedUi.png")
        end
        local linked = true
        if ui.link ~= nil then
            linked = false
            if #ui.link() == 2 then -- 2 means it's a doubly linked thing
                for _, link in ipairs(ui.link()) do 
                    love.graphics.line(menuToScreen(ui.x, ui.y).x + 32, menuToScreen(ui.x, ui.y).y + 32,
                    menuToScreen(link.x, link.y).x + 32, menuToScreen(link.x, link.y).y + 32)
                    if link.earned == true then
                        linked = true
                    end
                end
            else
                love.graphics.line(menuToScreen(ui.x, ui.y).x + 32, menuToScreen(ui.x, ui.y).y + 32,
                menuToScreen(ui.link().x, ui.link().y).x + 32, menuToScreen(ui.link().x, ui.link().y).y + 32)
                if ui.link().earned == true then
                    linked = true
                end
            end
        end
        if not linked then
            love.graphics.setColor(.2, .2, .2)
        end

        imageLib:drawCircleClipped((ui.x * width) - 16, (ui.y * height) - 16, ui.image, 32)
        love.graphics.setColor(1, 1, 1)
    end
    if self.tooltip then
        ui:renderTooltip(self.tooltip.text, self.tooltip.x, self.tooltip.y)
    end
    if self.selectedSkill ~= nil then
        local maxWidth = 280

        imageLib:drawImage(self.selectedSkill.x - 160, self.selectedSkill.y - 120, "images/skillTree/ConfirmUi.png") --  -80 is center
        imageLib:drawImage(self.selectedSkill.x - 160, self.selectedSkill.y + 10, "images/skillTree/PurchaseUi.png")

        love.graphics.setFont(realbigfont)
        love.graphics.print(self.selectedSkill.price, self.selectedSkill.x - 20, self.selectedSkill.y + 60)

        love.graphics.setFont(smallfont)

        -- printf wrapps text which is cool
        love.graphics.printf(self.selectedSkill.description, self.selectedSkill.x - 130, self.selectedSkill.y - 60, maxWidth, "center")
    end

end

function menu:click(x, y)
    self.tooltip = nil
    for _, skillUi in pairs(playerStat[currentPlayer].skills) do
        if self.selectedSkill ~= nil then
            if love.mouse.isDown(1) then
                if not self.clicking then -- ui for the input
                    -- if it's not in some arbitary bounding box
                    if not menu:isClickInButton(x, y, self.selectedSkill.x - 130, self.selectedSkill.y - 60, 320, 220) then
                        self.selectedSkill = nil
                    else
                        if menu:isClickInButton(x, y, self.selectedSkill.x - 160, self.selectedSkill.y + 10, 320, 120) and playerStat[currentPlayer].oozeNum - self.selectedSkill.price >= 0 and self.selectedSkill.earned ~= true then
                            playerStat[currentPlayer].oozeNum = playerStat[currentPlayer].oozeNum - self.selectedSkill.price
                            self.selectedSkill.earned = true
                            self.selectedSkill = nil
                        end
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
                elseif #skillUi.link() ~= 2 then
                    if skillUi.link().earned then
                        self.selectedSkill = skillUi
                        self.clicking = true
                    end
                else
                    for _, link in ipairs(skillUi.link()) do
                        if link.earned == true then
                            self.selectedSkill = skillUi
                            self.clicking = true
                        end
                    end
                end
            end
        end
    end
    if not love.mouse.isDown(1) then
        self.clicking = false
    end
end