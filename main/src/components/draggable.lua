local Component = require 'src.components.component'

local Draggable = Class('Draggable', Component)

local HERO_Y_OFFSET = 4

-- draggableType can be `hero` or `mod`
function Draggable:initialize(slot, draggableType)
  Component.initialize(self)

  -- assert(slot, 'Draggable must have a Slot entity parent')
  if slot then
    slot:getComponent('DropSlot').draggable = self
    self.slot = slot
  end
  -- You can't do this bc the entity hasn't been fully initialized
  -- So we call this when the entity has been fully initialized
  -- self:setEntityPosToSlot(slot)

  self.draggableType = draggableType or 'hero'
end

-- The entity has been initialized
function Draggable:entityadded()
  if self.slot then
    self:setEntityPosToSlot(self.slot)
  end
end

-- These functions probably don't belong here, they belong to the system
function Draggable:setSlot(slotEntity)
  -- assert(slot, 'Draggable must have a Slot entity parent')
  slotEntity:getComponent('DropSlot').draggable = self
  self.slot = slotEntity
  -- Assuming the entity has been initialize, we can call this
  self:setEntityPosToSlot(slotEntity)
end

function Draggable:setEntityPosToSlot(slot)
  local x, y = self.slot:getComponent('Transform'):getGlobalPosition()
  self:getEntity():getComponent('Transform'):setGlobalPosition(x, y - HERO_Y_OFFSET)
end

function Draggable:unsetSlot()
  self.slot:getComponent('DropSlot').draggable = nil
  self.slot = nil
end

return Draggable