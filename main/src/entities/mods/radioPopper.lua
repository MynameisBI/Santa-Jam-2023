local ModEntity = require 'src.entities.mods.modEntity'

local RadioPopper = Class('RadioPopper', ModEntity)

function RadioPopper:initialize(slot)
  ModEntity.initialize(self, slot, Images.mods.placeholder, 
    'SSB',
    'Radio Popper',
    '+ 0.7 AS\n- 20 CDR',
    0, 0, 0.7, 0, 0, 0
  )
end

return RadioPopper