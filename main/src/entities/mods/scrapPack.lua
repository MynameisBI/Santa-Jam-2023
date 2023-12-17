local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'
local Area = require 'src.components.area'
local Draggable = require 'src.components.draggable'
local Mod = require 'src.components.mod'
local Entity = require 'src.entities.entity'

local ScrapPack = Class('ScrapPack', Entity)

function ScrapPack:initialize(slot)
  Entity.initialize(self)

  self:addComponent(Transform(200, 200, 0, 0.24, 0.24))

  self:addComponent(Sprite(Images.diamond, 12))

  self:addComponent(Area(24, 24))

  self:addComponent(Draggable(slot, 'mod'))

  self:addComponent(Mod())
end

return ScrapPack