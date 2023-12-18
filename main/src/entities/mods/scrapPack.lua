local ModEntity = require 'src.entities.mods.modEntity'

local ScrapPack = Class('ScrapPack', ModEntity)

function ScrapPack:initialize(slot)
  ModEntity.initialize(self, slot, Images.mods.scrapPack, 
    'S',
    'Scrap Pack',
    '+ 5 ATK',
    5, 0, 0, 0, 0, 0
  )
end

return ScrapPack