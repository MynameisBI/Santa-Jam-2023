local ModEntity = require 'src.entities.mods.modEntity'

local DeathsPromise = Class('DeathsPromise', ModEntity)

function DeathsPromise:initialize(slot)
  ModEntity.initialize(self, slot, Images.mods.placeholder, 
    'BBB',
    'Death\'s Promise',
    '+ 35 CDR\n+ 100 Energy',
    0, 15, 0, 0, 0, 0, 0.35, 100
  )
end

return DeathsPromise