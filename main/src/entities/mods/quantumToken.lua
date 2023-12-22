local ModEntity = require 'src.entities.mods.modEntity'

local QuantumToken = Class('QuantumToken', ModEntity)

function QuantumToken:initialize(slot)
  ModEntity.initialize(self, slot, Images.mods.quantumToken, 
    'SP',
    'Quantum Token',
    '+ 0.2 C.CHANCE',
    0, 0, 0, 0, 0.2, 0
  )
end

return QuantumToken