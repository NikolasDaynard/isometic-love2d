-- So it's gonna be a bar like \
--                              0-0-0- with the options cuz thats cool

-- returns possible OLDACTIONS on the tile
require("image")
require("actions")

actionUi = {
    currentButton = -1,
    tooltip = {x = 0, y = 0, text = ""},
    tooltipTimer = 20,
}

function actionUi:tileLogic(tile)
    tiles = tileHolder:getTiles()
    actionArray = {}
    for _, action in pairs(actions) do
        if action.check(tile) then
            table.insert(actionArray, #actionArray + 1, action)
        end
    end

    return actionArray
end

function actionUi:click(mouseX, mouseY)
    self.currentButton = -1
    if selectedTile ~= nil then
        actionArray = actionUi:tileLogic(selectedTile)
        local x = IsoCordToWorldSpace(selectedTile.x, selectedTile.y, selectedTile.height, isometricRenderer.rotation).x
        local y = IsoCordToWorldSpace(selectedTile.x, selectedTile.y, selectedTile.height, isometricRenderer.rotation).y

        local i = 1

        for _, action in pairs(actionArray) do
            if clickHitButton(mouseX, mouseY, x + 40 + ((i - 1) * 18), y + 64 + 20 + 2, 6) then
                if love.mouse.isDown(1) then
                    self.currentButton = i
                else
                    self.tooltip = {x = x + 40 + ((i - 1) * 18), y = y + 64 + 32, text = action.tooltip}
                end
                break
            end
            i = i + 1
        end

        if self.currentButton ~= -1 then
            return true
        end
        if clickHitRect(mouseX, mouseY, x + 40, y + 64 + 16, 320, 16) and love.mouse.isDown(1) then
            return true
        end
    end
    return false-- no ui to click if ytou aint hit the thnnd
end

function actionUi:renderActions(tile) 
    if self.tooltip ~= nil then
        ui:renderTooltip(self.tooltip.text, self.tooltip.x, self.tooltip.y)
        
        self.tooltipTimer = self.tooltipTimer - 1
        if self.tooltipTimer == 0 then
            self.tooltip = nil
            self.tooltipTimer = 20
        end
    end
    actionArray = actionUi:tileLogic(tile)
    local x = IsoCordToWorldSpace(tile.x, tile.y, tile.height, isometricRenderer.rotation).x
    local y = IsoCordToWorldSpace(tile.x, tile.y, tile.height, isometricRenderer.rotation).y
    if #actionArray ~= 0 then
        imageLib:drawImage(x + 16, y + 16 + 20, "images/ui/uiactions.png") -- it's 64x64

        local currentButton = 1
        for _, action in ipairs(actionArray) do
            imageLib:drawImage(x + 32 + ((currentButton - 1) * 18), y + 64 + 12 + 1, "images/ui/actionCont.png")
            imageLib:drawImage(x + 32 + ((currentButton - 1) * 18), y + 64 + 12 + 2, action.image)
            currentButton = currentButton + 1
        end
        imageLib:drawImage(x + 32 + ((currentButton - 1) * 18), y + 64 + 13, "images/ui/actionCap.png")
    end
end

function actionUi:execute()
    if self.currentButton == -1 or selectedTile == nil then
        return
    end

    actionArray = actionUi:tileLogic(selectedTile)
    buttons = {}
    buttonNum = 1
    for _, action in ipairs(actionArray) do
        if buttonNum == self.currentButton then
            action.action()
            break
        end

        buttonNum = buttonNum + 1
    end

    self.currentButton = -1
end