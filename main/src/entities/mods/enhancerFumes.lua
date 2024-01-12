local ModEntity = require 'src.entities.mods.modEntity'

local EnhancerFumes = Class('EnhancerFumes', ModEntity)

EnhancerFumes.ENERGY_PER_ATTACK = 20

function EnhancerFumes:initialize(slot)
  ModEntity.initialize(self, slot, Images.mods.enhancerFumes,
    'PBB',
    'Enhancer Fumes',
    '+ 300 Energy\n* Attacks regenerate 10 energy',
    0, 15, 0, 0, 0, 0, 0, 300
  )
end

return EnhancerFumes