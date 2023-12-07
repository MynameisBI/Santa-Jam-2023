local Component = require 'src.components.component'

local Transform = Component:subclass('Transform')

function Transform:initialize(x, y, r, sx, sy)
  Component.initialize(self)
  
  self.x, self.y = x or 0, y or 0
  self.r = r or 0
  self.sx, self.sy = sx or 1, sy or 1

  self.z = 0 -- Bring the layer attribute from sprite to here

  self.parent = nil
end

function Transform:getGlobalPosition()
  local globalX, globalY = self.x, self.y
  local parentTransform = self.parent
  
  while parentTransform do
    globalX = globalX + parentTransform.x
    globalY = globalY + parentTransform.y
    parentTransform = parentTransform.parent
  end
  
  return globalX, globalY
end

function Transform:setGlobalPosition(wx, wy)
  self.x, self.y = wx, wy
  local parentTransform = self.parent

  while parentTransform do
    self.x = self.x - parentTransform.x
    self.y = self.y - parentTransform.y
    parentTransform = parentTransform.parent
  end
end

function Transform:getLocalPosition()
  return self.x, self.y
end

function Transform:setLocalPosition(lx, ly)
  self.x, self.y = lx, ly
end

function Transform:translate(dx, dy)
  self.x = self.x + dx
  self.y = self.y + dy
end

return Transform

