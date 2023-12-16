local Transform = require 'src.components.transform'
local DropSlot = require 'src.components.dropSlot'
local Area = require 'src.components.area'

local Entity = require 'src.entities.entity'

local Slot = Class('Slot', Entity)

function Slot:initialize(slotType, x, y)
  Entity.initialize(self)

  self:addComponent(Transform(x, y))

  self:addComponent(Area(36, 36))

  self:addComponent(DropSlot(slotType))
end

return Slot