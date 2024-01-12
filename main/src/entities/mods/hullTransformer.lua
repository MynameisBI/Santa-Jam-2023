local ModEntity = require 'src.entities.mods.modEntity'

local HullTransformer = Class('HullTransformer', ModEntity)

function HullTransformer:initialize(slot)
  ModEntity.initialize(self, slot, Images.mods.hullTransformer, 
    'SB',
    'Hull Transformer',
    '+ 0.4 AS',
    0, 0, 0.4, 0, 0, 0
  )
end

return HullTransformer