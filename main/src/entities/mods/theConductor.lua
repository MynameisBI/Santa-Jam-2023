local ModEntity = require 'src.entities.mods.modEntity'

local TheConductor = Class('TheConductor', ModEntity)

function TheConductor:initialize(slot)
  ModEntity.initialize(self, slot, Images.mods.theConductor, 
    'SSS',
    'The Conductor',
    '+ 50 ATK',
    50, 0, 0, 0, 0, 0
  )
end

return TheConductor