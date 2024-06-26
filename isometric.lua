isometricRenderer = {
    tile = {x = 3 * 100, y = 4 * 100}
}

function isometricRenderer:render(x, y, image)
    imageLib:drawImage(self.tile.x, self.tile.y, "ground.png")
end