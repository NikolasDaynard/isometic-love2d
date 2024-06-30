-- require("")

audio = {
    sounds = {},
    playingSounds = {},
    fadingAudio = {},
    fadingAudioIn = {},
}

function audio:loadSound(sound) 
    if self.sounds[sound] == nil then
        self.sounds[sound] = love.audio.newSource(sound, "static")
    end
end


function audio:update()
    for i, sound in ipairs(self.fadingAudio) do
        sound:setVolume(math.max(sound:getVolume() - .01, 0))
        if math.max(sound:getVolume() - .01, 0) == 0 then
            table.remove(self.fadingAudio, i)
        end
    end
    for i, sound in ipairs(self.fadingAudioIn) do
        sound:setVolume(math.min(sound:getVolume() + .01, 1))
        if math.min(sound:getVolume() + .01, 1) == 1 then
            table.remove(self.fadingAudioIn, i)
        end
    end
    for i, sound in ipairs(self.playingSounds) do
        if not sound:isPlaying() then
            table.remove(self.playingSounds, i)
        end
    end
end

function audio:playSound(sound, volume, loop)
    if self.sounds[sound] == nil then
        audio:loadSound(sound)
    end
    self.sounds[sound]:play()

    self.sounds[sound]:setLooping(loop or false)

    self.sounds[sound]:setVolume(volume or 1)

    table.insert(self.playingSounds, self.sounds[sound])
end

function audio:stopSound(soundName)
    for i, sound in ipairs(self.playingSounds) do
        if sound == self.sounds[soundName] then
            sound:pause()
            table.remove(self.playingSounds, i)
        end
    end
end

function audio:fade(soundName)
    if self.sounds[soundName] == nil then
        audio:loadSound(soundName)
    end
    for i, sound in ipairs(self.playingSounds) do
        if sound == self.sounds[soundName] then
            table.insert(self.fadingAudio, self.playingSounds[i])
        end
    end
end
function audio:fadeIn(soundName)
    if self.sounds[soundName] == nil then
        audio:loadSound(soundName)
    end
    for i, sound in ipairs(self.playingSounds) do
        if sound == self.sounds[soundName] then
            table.insert(self.fadingAudioIn, self.playingSounds[i])
        end
    end
end