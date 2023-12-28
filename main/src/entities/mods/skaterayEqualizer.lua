local ModEntity = require 'src.entities.mods.modEntity'

local SkaterayEqualizer = Class('SkaterayEqualizer', ModEntity)

function SkaterayEqualizer:initialize(slot)
  ModEntity.initialize(self, slot, Images.mods.skaterayEqualizer, 
    'SSP',
    'Skateray Equalizer',
    '+ 10 ATK\n+ 100 RANGE\n+ 0.25 C.CHANCE',
    10, 0, 0, 100, 0.25, 0
  )
end

return SkaterayEqualizer