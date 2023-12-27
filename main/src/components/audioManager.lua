local Component = require 'src.components.component'
local Phase = require 'src.components.phase'

local AudioManager = Component:subclass('AudioManager')

function AudioManager:initialize()
  self.sounds = {}
  self.songs = {}
  self.phase = Phase()
  self.currentSong = nil
  self.currentGoalIndex = nil

  self.currentSongVolume = nil
  self.isMusicMuted = false
  self.isSoundMuted = false
end

function AudioManager:loadSound(id, path, soundType)
  self.sounds[id] = love.audio.newSource(path, soundType)
end

function AudioManager:playSound(id, volume, pitch)
  if self.sounds[id] and not self.isSoundMuted then
    self.sounds[id]:stop()
    self.sounds[id]:setVolume(volume or 0.7)
    self.sounds[id]:setPitch(pitch or 1)
    self.sounds[id]:play()
    return self.sounds[id]
  end
end

function AudioManager:stopSound()
  if self.sounds[id] then
    self.sounds[id]:stop()
    return self.sounds[id]
  end
end

function AudioManager:update(dt)
  -- local isPlaying = self.currentSong and (self.currentSong:getDuration() - self.currentSong:tell()) > 1

  -- if self.currentSong and not isPlaying then
  --   self.currentSong:stop()

  --   local currentPhase = self.phase:current()
  --   local round = self.phase:getCurrentRound()

  --   if currentPhase == 'battle' and (round.mainType == 'enemy' or round.mainType == 'elite') then
  --     self:playSong('enemy', 0.4)
  --   end
  -- end
  self:switch()
end


function AudioManager:playSong(id, volume, pitch)
  if self.currentSong ~= self.sounds[id] then
    if self.currentSong then
      self.currentSong:stop()
    end
  end

  self.currentSong = self.sounds[id]
  if self.currentSong then
    if not DEBUG.audioEnabled then self.currentSongVolume = 0
    else self.currentSongVolume = volume or 0.4
    end
    self.currentSong:setVolume(self.currentSongVolume)
    self.currentSong:setPitch(pitch or 1)
    self.currentSong:play()
  end

  return self.currentSong
end

function AudioManager:switch()
  local isPlaying = self.currentSong and (self.currentSong:getDuration() - self.currentSong:tell()) > 1
  if self.currentSong and not isPlaying then
    self.currentSong:stop()
  end

  local currentPhase = self.phase:current()
  local round = self.phase:getCurrentRound()

  if currentPhase == 'battle' and (round.mainType == 'enemy' or round.mainType == 'elite') then
    self:playSong('song1', 0.4)
  else
    self:playSong('song2', 0.4)
  end
end

return AudioManager
