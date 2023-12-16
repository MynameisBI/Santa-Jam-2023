local CameraManager = require 'src.components.cameraManager'
local Input = require 'src.components.input'

local Component = require 'src.components.component'

-- This can be merged with BumpItem
-- This whole class' purpose is to check whether it has a specific 2D point
-- Or (I think it's better to),
-- First, about the cameras
  -- remove the CameraManager singleton but keep the Camera components
  -- Then to screendraw, query all the entity with Transform, Area and Camera then draw
-- Second, about bump
  -- idk just keep it as it is and we'll have 2 ways to check if this area has point:
    -- using the Area
    -- or using the bump.world to query with point and check if item is in the result
local Area = Component:subclass('Area')

function Area:initialize(w, h)
  Component.initialize(self)
  self.w, self.h = w or 16, h or 16
end

function Area:getSize()
  return self.w, self.h
end

function Area:hasWorldPoint(worldX, worldY)
  assert(worldX and worldY, 'Missing point x or/and y')

  local entity = self:getEntity()
  assert(entity, 'Area not attached to an entity')

  local transform = entity:getComponent('Transform')
  assert(transform, 'Attached entity does not have a Transform component')

  local x, y = transform:getGlobalPosition()
  return Area:rectContainPoint(x, y, self.w, self.h, worldX, worldY)
end

function Area:hasScreenPoint(screenX, screenY, cameraName)
  assert(screenX and screenY, 'Missing point x or/and y')

  local camera = CameraManager():getCamera(cameraName or 'main')
  local worldX, worldY = camera:toWorld(screenX, screenY)
  return self:hasWorldPoint(worldX, worldY)
end

function Area:isPressed(button, cameraName, input)
  input = input or Input()

  if input:isMouseButtonPressed(button) then
    local px, py = input:getMouseScreenPosition()
    if self:hasScreenPoint(px, py, cameraName) then
      return true
    end
  end

  return false
end

function Area.static:rectContainPoint(rx, ry, rw, rh, px, py)
  return (rx <= px and px <= rx + rw and ry <= py and py <= ry + rh)
end

return Area