local Transform = require 'src.components.transform'
local DropSlot = require 'src.components.dropSlot'
local Area = require 'src.components.area'
local DragAndDropInfo = require 'src.components.dragAndDropInfo'

local Entity = require 'src.entities.entity'

local ModSlot = Class('ModSlot', Entity)

function ModSlot:initialize(x, y)
  Entity.initialize(self)

  self:addComponent(Transform(x, y))

  self:addComponent(Area(24, 24))

  self:addComponent(DropSlot('mod'))

  self:addComponent(DragAndDropInfo())
end

return ModSlot