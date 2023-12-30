local ModEntity = require 'src.entities.mods.modEntity'

local AbovesSliver = Class('AbovesSliver', ModEntity)

function AbovesSliver:initialize(slot)
  ModEntity.initialize(self, slot, Images.mods.abovesSliver, 
    'SPB',
    'Above\'s Sliver',
    '+ 15 ATK\n+ 15 RPW\n+ 15 CDR\n+ 150 Energy',
    15, 15, 0, 0, 0, 0, 0.15, 150
  )
end

return AbovesSliver