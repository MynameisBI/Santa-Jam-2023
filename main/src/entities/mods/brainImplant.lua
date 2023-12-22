local ModEntity = require 'src.entities.mods.modEntity'

local BrainImplant = Class('BrainImplant', ModEntity)

function BrainImplant:initialize(slot)
  ModEntity.initialize(self, slot, Images.mods.brainImplant, 
    'PP',
    'Brain Implant',
    '+ 20 RPW',
    0, 20, 0, 0, 0, 0
  )
end

return BrainImplant