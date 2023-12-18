local ModEntity = require 'src.entities.mods.modEntity'

local PsychePack = Class('PsychePack', ModEntity)

function PsychePack:initialize(slot)
  ModEntity.initialize(self, slot, Images.mods.psychePack, 
    'P',
    'Psyche Pack',
    '+ 5 RP',
    0, 5, 0, 0, 0, 0
  )
end

return PsychePack