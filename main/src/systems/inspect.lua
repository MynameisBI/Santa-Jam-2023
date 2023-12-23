local CurrentInspectable = require 'src.components.currentInspectable'
local System = require 'src.systems.system'

local Inspect = Class('Inspect', System)

function Inspect:initialize()
  System.initialize(self, 'Transform', 'Area', 'Inspectable')
  self.currentInspectable = CurrentInspectable()
end

function Inspect:earlysystemupdate(dt)
  local inspectable = self.currentInspectable.inspectable
  if inspectable == nil then return end
  if inspectable.objectType == 'enemy' then
    if inspectable.object.isDestroyed then
      self.currentInspectable.inspectable = nil
    end
  end
end

function Inspect:earlysystemmousepressed(x, y, button)
  self.currentInspectable.inspectable = nil
end

function Inspect:mousepressed(transform, area, inspectable, x, y, button)
  if button ~= 2 then return end

  if area:hasScreenPoint(x, y) then
    self.currentInspectable.inspectable = inspectable
  end
end

return Inspect