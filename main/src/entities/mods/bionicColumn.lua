local ModEntity = require 'src.entities.mods.modEntity'

local BionicColumn = Class('BionicColumn', ModEntity)

function BionicColumn:initialize(slot)
  ModEntity.initialize(self, slot, Images.mods.bionicColumn, 
    'PPB',
    'Bionic Column',
    '+ 15 RPW\n+ 15 CDR\n* Attacks and skills halve\nenemies\' reality armor',
    0, 15, 0, 0, 0, 0, 0.15, 0
  )
end

return BionicColumn