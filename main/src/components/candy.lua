local Component = require 'src.components.component'

local Candy = Class('Candy', Component)

function Candy:initialize(targetX, targetY, radius, speed)
  Component.initialize(self)

  self.targetX = targetX
  self.targetY = targetY

  self.radius = radius or 240
  self.speed = speed or 1200
end

return Candy