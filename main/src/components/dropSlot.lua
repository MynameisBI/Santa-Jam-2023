local Component = require 'src.components.component'

local DropSlot = Class('DropSlot', Component)

-- `slotType` can be 'bench', 'team' or 'mod'
function DropSlot:initialize(slotType)
  Component.initialize(self)

  self.slotType = slotType or 'bench'
  self.draggable = nil
end

return DropSlot