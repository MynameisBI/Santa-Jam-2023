local Component = require 'src.components.component'

local Draggable = Class('Draggable', Component)

local HERO_Y_OFFSET = 4

function Draggable:initialize(slot)
  Component.initialize(self)

  assert(slot, 'Draggable must have a Slot entity parent')
  self.slot = slot

  -- You can't do this bc the entity hasn't been fully initialize
  -- So we call this in the system when the entity has been fully initialize
  -- self:setEntityPosToSlot(slot)
end

function Draggable:setSlot(slot)
  assert(slot, 'Draggable must have a Slot entity parent')
  self.slot = slot
  -- Assuming the entity has been initialize, we can call this
  self:setEntityPosToSlot(slot)
end

function Draggable:setEntityPosToSlot(slot)
  local x, y = self.slot:getComponent('Transform'):getGlobalPosition()
  self:getEntity():getComponent('Transform'):setGlobalPosition(x, y - HERO_Y_OFFSET)
end

return Draggable