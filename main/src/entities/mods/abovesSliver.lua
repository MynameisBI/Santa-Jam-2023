local ModEntity = require 'src.entities.mods.modEntity'

local AbovesSliver = Class('AbovesSliver', ModEntity)

function AbovesSliver:initialize(slot)
  ModEntity.initialize(self, slot, Images.mods.placeholder, 
    'SPB',
    'Above\'s Sliver',
    '+ 20 ATK\n+ 15 RPW\n+ 10 CDR\n+ 100 Energy',
    20, 15, 0, 0, 0, 0, 0.1, 100
  )
end

return AbovesSliver