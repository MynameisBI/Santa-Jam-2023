local ModEntity = require 'src.entities.mods.modEntity'

local NeuralProcessor = Class('NeuralProcessor', ModEntity)

function NeuralProcessor:initialize(slot)
  ModEntity.initialize(self, slot, Images.mods.neuralProcessor,
    'PPP',
    'Neural Processor',
    '+ 50 RPW',
    0, 50, 0, 0, 0, 0
  )
end

return NeuralProcessor