local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'
local Area = require 'src.components.area'
local Draggable = require 'src.components.draggable'
local Mod = require 'src.components.mod'
local Entity = require 'src.entities.entity'

local ModEntity = Class('ModEntity', Entity)

function ModEntity:initialize(slot, image, ...)
  Entity.initialize(self)

  self:addComponent(Transform(0, 0, 0, 2, 2))

  self:addComponent(Sprite(image, 12))

  self:addComponent(Area(24, 24))

  self:addComponent(Draggable(slot, 'mod'))

  self:addComponent(Mod(...))
end

return ModEntity