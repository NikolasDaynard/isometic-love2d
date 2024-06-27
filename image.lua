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
    
    love.graphics.draw(self.images[imageName], x, y, 0, 1, 1)
end