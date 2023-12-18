local ModEntity = require 'src.entities.mods.modEntity'

local HullTransformer = Class('HullTransformer', ModEntity)

function HullTransformer:initialize(slot)
  ModEntity.initialize(self, slot, Images.mods.placeholder, 
    'SB',
    'Hull Transformer',
    '+ 0.2 AS',
    5, 0, 0.2, 0, 0, 0
  )
end

return HullTransformer