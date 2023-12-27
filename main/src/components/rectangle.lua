local Component = require 'src.components.component'

local Rectangle = Class('Rectangle', Component)

function Rectangle:initialize(mode, color, lineWidth, layer, rx, ry)
  Component.initialize(self)

  self.mode = mode or 'fill'
  self.color = color or {1, 1, 1}
  self.lineWidth = lineWidth or 1

  self.layer = layer

  self.rx = rx
  self.ry = ry

  self.update = function(self, dt) end -- war crime
end

return Rectangle