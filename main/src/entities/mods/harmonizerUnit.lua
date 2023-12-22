local ModEntity = require 'src.entities.mods.modEntity'

local HarmonizerUnit = Class('HarmonizerUnit', ModEntity)

function HarmonizerUnit:initialize(slot)
  ModEntity.initialize(self, slot, Images.mods.harmonizerUnit, 
    'SS',
    'Harmonizer Unit',
    '+ 20 ATK',
    20, 0, 0, 0, 0, 0
  )
end

return HarmonizerUnit