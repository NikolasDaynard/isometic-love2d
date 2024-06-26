-- require("")

audio = {
    sounds = {},
    playingSounds = {},
    fadingAudio = {},
    fadingAudioIn = {},
}
local BGM = "audio/City of Gelatin.mp3"
local BGMRef = nil

function audio:loadSound(sound) 
    if self.sounds[sound] == nil then
        self.sounds[sound] = love.audio.newSource(sound, "static")
    end
end


function audio:update()
    love.audio.setVolume(settings:getSetting("volume") or 1)
    for i, sound in ipairs(self.fadingAudio) do
        sound:setVolume(math.max(sound:getVolume() - .01 * settings:getSetting("volume"), 0))
        if math.max(sound:getVolume() - .01, 0) == 0 then
            table.remove(self.fadingAudio, i)
        end
    end
    for i, sound in ipairs(self.fadingAudioIn) do
        sound:setVolume(math.min(sound:getVolume() + .01 * settings:getSetting("volume"), 1))
        if math.min(sound:getVolume() + .01, 1) == 1 then
            table.remove(self.fadingAudioIn, i)
        end
    end
    for i, sound in ipairs(self.playingSounds) do
        if self.playingSounds[i] == self.sounds[BGM] then
            if not sound:isPlaying() then
                BGM = "audio/City of Gelatin.mp3"
                audio:fadeInBGM()
            end
        end
        if not sound:isPlaying() then
            table.remove(self.playingSounds, i)
        end
    end
end

function audio:playSound(sound, volume, loop)
    -- volume = 0
    if self.sounds[sound] == nil then
        audio:loadSound(sound)
    end
    self.sounds[sound]:play()

    self.sounds[sound]:setLooping(loop or false)

    self.sounds[sound]:setVolume((volume or 1)) -- mute game

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

function audio:startBattleTheme(soundName)
    BGM = soundName
    audio:playSound("audio/Battle Theme.mp3", 1, false)
    audio:fade("audio/City of Gelatin.mp3")
end

function audio:fadeBGM()
    audio:fade(BGM)
end
function audio:fadeInBGM()
    audio:fadeIn(BGM)
end