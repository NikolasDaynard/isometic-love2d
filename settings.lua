settings = {
    dragging = false,
    open = false,
    buttons = {
        {x = 3, y = 3, w = 1000, h = 200,
            callback = function(value)
                print("called back")
            end,
            value = false
        }
    },
    sliders = {
        {x = 3, y = -300, w = 1000, h = 200,
            callback = function(value)
                print("called back")
            end,
            value = .5
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
        ui:renderButton(button.x, button.y, button.w, button.h, "foo")
    end
    for _, slider in ipairs(self.sliders) do
        ui:renderSlider(slider.x, slider.y, slider.w, slider.h, slider.value, "foo")
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
                dragging = slider
            end
        end
    else
        dragging = nil
    end
    if dragging then -- ref to slider 
        dragging.value = math.abs(1 - (((dragging.x + dragging.w) - x) / dragging.w))
        print(dragging.value)
    end
end