local System = require 'src.systems.system'
local BumpWorld = require 'src.components.bumpWorld'

local ManageBumpWorld = System:subclass('ManageBumpWorld')

function ManageBumpWorld:initialize()
  System.initialize(self, 'BumpWorld')
end

function ManageBumpWorld:entityadded(bumpWorld, entity)
  -- print(bumpItem.tags[1]) huh

  local transform = entity:getComponent('Transform')
  if transform == nil then return end
  local area = entity:getComponent('Area')
  if area == nil then return end
  local bumpItem = entity:getComponent('BumpItem')
  if bumpItem == nil then return end

  local x, y = transform:getGlobalPosition()
  local w, h = area:getSize()
  bumpWorld.world:add(bumpItem, x, y, w, h)
end

function ManageBumpWorld:entityremoved(bumpItem, entity)
  BumpWorld().world:remove(bumpItem)
end

return ManageBumpWorld
