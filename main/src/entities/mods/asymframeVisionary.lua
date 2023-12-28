local ModEntity = require 'src.entities.mods.modEntity'

local AsymframeVisionary = Class('AsymframeVisionary', ModEntity)

function AsymframeVisionary:initialize(slot)
  ModEntity.initialize(self, slot, Images.mods.asymframeVisionary, 
    'SPP',
    'Asymframe Visionary',
    '+ 0.4 C.CHANCE\n* Skill can crit',
    0, 0, 0, 0, 0.4, 0
  )
end

return AsymframeVisionary