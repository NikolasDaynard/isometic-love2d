function distance(x1, y1, x2, y2)
  return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end
function IsoCordToWorldSpace(x, y, height)
    height = height or 1
    local tileX = y * 32 + ((x % 2) * 16)
    local tileY = (x * 5) + (height * 16) - 24

    return {x = tileX, y = tileY}
end
function clickHitButton(x, y, buttonX, buttonY, buttonRadius)
    return distance(x, y, buttonX, buttonY) < buttonRadius
end
function clickHitRect(x, y, buttonX, buttonY, buttonW, buttonH)
    return x >= buttonX and x <= buttonX + buttonW and y >= buttonY and y <= buttonY + buttonH
end