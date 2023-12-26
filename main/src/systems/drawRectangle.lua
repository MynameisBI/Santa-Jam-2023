local System = require 'src.systems.system'

local DrawRectangle = Class('DrawRectangle', System)

function DrawRectangle:initialize()
  System.initialize(self, 'Transform', 'Rectangle')
end

function DrawRectangle:worlddraw(transform, rectangle)
  Deep.queue(rectangle.layer, function()
    love.graphics.push()
    love.graphics.translate(transform:getGlobalPosition())
    love.graphics.rotate(transform.r)
      love.graphics.setColor(rectangle.color)
      love.graphics.setLineWidth(rectangle.lineWidth)
      love.graphics.rectangle(rectangle.mode, -transform.ox, -transform.oy, transform.sx, transform.sy)
      love.graphics.setLineWidth(1)
    love.graphics.pop()
  end)
end 

return DrawRectangle