settings = {
    draggingSlider = nil,
    open = false,
    clicking = false, 
    buttons = {
        {x = 0, y = 0, w = 1000, h = 200,
            callback = function(value)
                print("called back")
            end,
            value = false,
            -- text = 
        }
    },
    sliders = {
        {x = 300, y = -300, w = 1000, h = 200,
            callback = function(value)
                print("called back2")
            end,
            value = .5,
            text = "volume"
        }
    }
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

    for _, button in ipairs(self.buttons) do
        love.graphics.setFont(realbigfont)
        ui:renderButton(button.x, button.y, button.w, button.h, button.text)
    end
    for _, slider in ipairs(self.sliders) do
        ui:renderSlider(slider.x, slider.y, slider.w, slider.h, slider.value, slider.text)
    end
end
function settings:click(x, y)
    if love.mouse.isDown(1) then
        for _, button in ipairs(self.buttons) do
            if clickHitRect(x, y, button.x, button.y, button.w, button.h) then
                if button.callback then
                    button.callback()
                end
            end
        end

        for _, slider in ipairs(self.sliders) do
            if clickHitRect(x, y, slider.x, slider.y, slider.w, slider.h) then
                if slider.callback then
                    slider.callback()
                end
                self.draggingSlider = slider
            end
        end
    else
        self.draggingSlider = nil
    end
    if self.draggingSlider then -- ref to slider
        self.draggingSlider.value = math.abs(math.max(math.min(1 - (((self.draggingSlider.x + self.draggingSlider.w) - x) / self.draggingSlider.w), 1), 0))
        self.draggingSlider.callback(self.draggingSlider.value)
        return true
    end
end