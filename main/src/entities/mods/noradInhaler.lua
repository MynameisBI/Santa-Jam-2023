local ModEntity = require 'src.entities.mods.modEntity'

local NoradInhaler = Class('NoradInhaler', ModEntity)

function NoradInhaler:initialize(slot)
  ModEntity.initialize(self, slot, Images.mods.placeholder, 
    'BB',
    'Norad Inhaler',
    '+ 15 CDR\n+ 50 Energy',
    0, 0, 0, 0, 0, 0, 15, 50
  )
end

return NoradInhaler