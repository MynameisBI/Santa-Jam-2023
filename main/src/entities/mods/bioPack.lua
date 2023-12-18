local ModEntity = require 'src.entities.mods.modEntity'

local BioPack = Class('BioPack', ModEntity)

function BioPack:initialize(slot)
  ModEntity.initialize(self, slot, Images.mods.bioPack, 
    'B',
    'Bio Pack',
    '+ 5 CDR',
    0, 0, 0, 0, 0, 0
  )
end

return BioPack