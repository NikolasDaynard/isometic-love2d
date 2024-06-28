imageLib = {
    images = {}
}
function imageLib:loadImage(imageName)
    self.images[imageName] = love.graphics.newImage(imageName)
    self.images[imageName]:setFilter("nearest", "nearest")
end

-- draws isometrically (not true)
function imageLib:drawImage(x, y, imageName, sx, sy)
    sx = sx or 1
    sy = sy or 1
    if self.images[imageName] == nil then
        imageLib:loadImage(imageName)
    end
    love.graphics.draw(self.images[imageName], x, y, 0, sx, sy)
end

function imageLib:drawCircleClipped(x, y, imageName, r)
    r = r or 32
    if self.images[imageName] == nil then
        imageLib:loadImage(imageName)
    end

    love.graphics.stencil(function()
        love.graphics.circle("fill", x + r, y + r, r)
    end, "replace", 1)

    love.graphics.setStencilTest("greater", 0)

    love.graphics.draw(self.images[imageName], x, y, 0, 1, 1)

    -- Turn off
    love.graphics.setStencilTest()
end