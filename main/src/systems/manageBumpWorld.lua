local System = require 'src.systems.system'
local BumpWorld = require 'src.components.bumpWorld'

local ManageBumpWorld = System:subclass('ManageBumpWorld')

function ManageBumpWorld:initialize()
  System.initialize(self, 'Transform', 'Area', 'BumpItem')
  self.bumpWorld = BumpWorld()
end

function ManageBumpWorld:entityadded(transform, area, bumpItem, entity)
  local x, y = transform:getGlobalPosition()
  local w, h = area:getSize()
  self.bumpWorld.world:add(bumpItem, x, y, w, h)
end

function ManageBumpWorld:entityremoved(bumpItem, entity)
  BumpWorld().world:remove(bumpItem)
end

return ManageBumpWorld
