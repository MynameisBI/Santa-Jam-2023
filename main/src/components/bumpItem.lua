local BumpWorld = require 'src.components.bumpWorld'

local Component = require 'src.components.component'

-- To do
-- Currently, bumpitem can only detect if it is colliding with another bumpitem
-- Make it so the bumpitem send a call when it touch (enter) another bumpitem
-- and another call when it's not touching it anymore (exit perhaps)
local BumpItem = Component:subclass('BumpItem')

function BumpItem:initialize(...)
  Component.initialize(self)
  self.tags = {...}
  self.defaultFilter = nil
end

function BumpItem:setDefaultFilter(filter)
  assert(type(filter) == 'function', 'Filter must be a function')
  self.defaultFilter = filter
end

function BumpItem:hasTag(tag)
  return Lume.find(self.tags, tag) and true or false
end

function BumpItem:check(x, y, filter)
  local cols, len = BumpWorld().world:check(self, x, y, filter or self.defaultFilter)
  return cols, len
end

function BumpItem:update(x, y)
  BumpWorld().world:update(self, x, y)
  return x, y
end

function BumpItem:move(x, y, filter)
  local actualX, actualY, cols, len = BumpWorld().world:move(self, x, y, filter or self.defaultFilter)
  return actualX, actualY, cols, len
end

return BumpItem