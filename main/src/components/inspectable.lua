local Component = require 'src.components.component'

local Inspectable = Class('Inspectable', Component)

function Inspectable:initialize(image, qx, qy, objectType, object)
  Component.initialize(self)

  self.image = image
  self.qx, self.qy = qx, qy

  self.objectType = objectType
  self.object = object
end

function Inspectable:entityadded()
  self.image = self.image or self:getEntity():getComponent('Sprite').image

  local w, h = self.image:getDimensions()
  self.qx, self.qy = self.qx or w/2 - 6, self.qy or h/2 - 4
  
  self.quad = love.graphics.newQuad(self.qx, self.qy, 12, 13, self.image)
end

return Inspectable