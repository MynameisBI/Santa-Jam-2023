local ModEntity = require 'src.entities.mods.modEntity'

local RadioPopper = Class('RadioPopper', ModEntity)

function RadioPopper:initialize(slot)
  ModEntity.initialize(self, slot, Images.mods.radioPopper,
    'SSB',
    'Radio Popper',
    '+ 1.4 AS\n- 20 CDR',
    0, 0, 1.4, 0, 0, 0, -0.2, 0
  )
end

return RadioPopper