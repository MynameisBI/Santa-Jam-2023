local ModEntity = require 'src.entities.mods.modEntity'

local SubcellularSupervisor = Class('SubcellularSupervisor', ModEntity)

function SubcellularSupervisor:initialize(slot)
  ModEntity.initialize(self, slot, Images.mods.subcellularSupervisor, 
    'SBB',
    'Subcellular Supervisor',
    '+ 0.4 AS\n+ 15 CDR\n* Attacks and skills halve\nenemies\' physical armor',
    0, 0, 0.4, 0, 0, 0, 0.15, 0
  )
end

return SubcellularSupervisor