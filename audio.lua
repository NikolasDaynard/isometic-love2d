-- require("")

audio = {
    sounds = {},
    playingSounds = {}
}

function audio:loadSound(sound) 
    if self.sounds[sound] == nil then
        self.sounds[sound] = love.audio.newSource(sound, "static")
    end
end


function audio:update()
    for i, sound in ipairs(self.playingSounds) do
        if not sound:isPlaying() then
            table.remove(self.playingSounds, i)
        end
    end
end

function audio:playSound(sound)
    if self.sounds[sound] == nil then
        audio:loadSound(sound)
    end
    self.sounds[sound]:play()
    table.insert(self.playingSounds, self.sounds[sound])
end