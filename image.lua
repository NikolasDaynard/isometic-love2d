imageLib = {
    images = {}
}

function imageLib:loadImage(imageName)
    self.images[imageName] = love.graphics.newImage(imageName)
    self.images[imageName]:setFilter("nearest", "nearest")
end

-- draws isometrically
function imageLib:drawImage(x, y, imageName)
    if self.images[imageName] == nil then
        imageLib:loadImage(imageName)
    end

    quad = love.graphics.newQuad()
    love.graphics.draw(self.images[imageName], x, y, math.pi / 4, 1, .7)
end