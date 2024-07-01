lunajson = require("libs.lunajson")
require("credits")

settings = {
    clicking = false,
    draggingSlider = nil,
    open = false,
    buttons = {
        {x = 0, y = 0, w = 1000, h = 200,
            callback = function(value)
                settings:saveSettings()
            end,
            value = false,
            text = "1"
        },
        {x = 0, y = 300, w = 1000, h = 200,
            callback = function(value)
                settings.buttons[2].value = false
                credits.open = not credits.open
            end,
            value = false,
            text = "credits"
        }
    },
    sliders = {
        {x = 0, y = -300, w = 1000, h = 200,
            callback = function(value)
                settings:saveSettings()
            end,
            value = .5,
            text = "volume"
        }
    }
}

function settings:render()
    if not settings.open then
        if credits.open then
            credits.open = false
        end
        return
    end

    cam:lookAt(1200 / 2, 600 / 2)
    cam:zoomTo(.3)
    love.graphics.setColor(0, 0, 0)
    local windowWidth, windowHeight, windowMode = love.window.getMode()
    love.graphics.rectangle("fill", 0, 0, windowWidth + cam:getX(), windowHeight + cam:getY())
    love.graphics.setColor(1, 1, 1)

    for _, button in ipairs(self.buttons) do
        love.graphics.setFont(realbigfont)
        ui:renderButton(button.x, button.y, button.w, button.h, button.value, button.text)
    end
    for _, slider in ipairs(self.sliders) do
        ui:renderSlider(slider.x, slider.y, slider.w, slider.h, slider.value, slider.text)
    end
    credits:render()
end

function settings:click(x, y)
    if love.mouse.isDown(1) then
        for _, button in ipairs(self.buttons) do
            if clickHitRect(x, y, button.x, button.y, button.w, button.h) and not self.clicking then
                if button.callback then
                    button.value = not button.value
                    button.callback(not button.value)
                end
            end
        end

        for _, slider in ipairs(self.sliders) do
            if clickHitRect(x, y, slider.x, slider.y, slider.w, slider.h) then
                self.draggingSlider = slider
            end
        end
        self.clicking = true
    else
        self.draggingSlider = nil
        self.clicking = false
    end
    if self.draggingSlider then -- ref to slider
        self.draggingSlider.value = math.abs(math.max(math.min(1 - (((self.draggingSlider.x + self.draggingSlider.w) - x) / self.draggingSlider.w), 1), 0))
        if self.draggingSlider.callback then
            self.draggingSlider.callback(self.draggingSlider.value)
        end
        return true
    end
end

function settings:saveSettings()
    values = {}
    for _, button in ipairs(self.buttons) do
        table.insert(values, button.value)
    end

    for _, slider in ipairs(self.sliders) do
        table.insert(values, slider.value)
    end

    local jsonString = lunajson.encode(values)
    love.filesystem.write("settings.json", jsonString)
end

function settings:loadSettings()
    local fileData = love.filesystem.read("settings.json")
    local settingsTable = lunajson.decode(fileData)
    index = 1

    for _, button in ipairs(self.buttons) do
        button.value = settingsTable[index]
        index = index + 1
    end

    for _, slider in ipairs(self.sliders) do
        slider.value = settingsTable[index]
        index = index + 1
    end
end

function settings:getSetting(name)
    for _, button in ipairs(self.buttons) do
        if button.text == name then
            return button.value
        end
    end

    for _, slider in ipairs(self.sliders) do
        if slider.text == name then
            return slider.value
        end
    end
end