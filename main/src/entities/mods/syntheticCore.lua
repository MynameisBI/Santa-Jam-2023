local ModEntity = require 'src.entities.mods.modEntity'

local SyntheticCore = Class('SyntheticCore', ModEntity)

function SyntheticCore:initialize(slot)
  ModEntity.initialize(self, slot, Images.mods.placeholder, 
    'PB',
    'Synthetic Core',
    '+ 200 Energy',
    0, 0, 0, 0, 0, 0, 0, 200
  )
end

return SyntheticCore