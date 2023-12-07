local SingletonComponent = require 'src.components.singletonComponent'

local SoundManager = SingletonComponent:subclass('SoundManager')

function SoundManager:initialize(sounds)
  self.sounds = sounds -- <string, Source>
end

function SoundManager:play(key, volume, pitch)
  print(self.sounds[key], 'Missing '..key..' source')
  self.sounds[key]:setVolume(volume or 1)
  self.sounds[key]:setPitch(pitch or 1) 
  self.sounds[key]:stop()
  self.sounds[key]:play()
end

return SoundManager