local Component = require 'src.components.component'

local Rectangle = Class('Rectangle', Component)

function Rectangle:initialize(mode, color, lineWidth, layer)
  Component.initialize(self)

  self.mode = mode or 'fill'
  self.color = color or {1, 1, 1}
  self.lineWidth = lineWidth or 1

  self.layer = layer
end

return Rectangle