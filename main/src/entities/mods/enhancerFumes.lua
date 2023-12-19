local ModEntity = require 'src.entities.mods.modEntity'

local EnhancerFumes = Class('EnhancerFumes', ModEntity)

function EnhancerFumes:initialize(slot)
  ModEntity.initialize(self, slot, Images.mods.placeholder, 
    'PBB',
    'Enhancer Fumes',
    '+ 300 Energy\n* Attacks regenerate 20 energy',
    0, 15, 0, 0, 0, 0
  )
end

return EnhancerFumes