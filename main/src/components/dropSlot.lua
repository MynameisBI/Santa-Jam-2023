local Component = require 'src.components.component'

local DropSlot = Class('DropSlot', Component)

-- `slotType` can be 'bench' or 'team'
function DropSlot:initialize(slotType)
  Component.initialize(self)

  self.slotType = slotType or 'bench'
end

return DropSlot