local AllyStats = require 'src.type.allyStats'
local Component = require 'src.components.component'

local Mod = Class('Mod', Component)

function Mod:initialize(id, name, description, ...)
  Component.initialize(self)

  assert(type(id) == 'string', 'Invalid id')
  self.id = id

  self.name = name or ''
  self.description = description or ''
  self.stats = AllyStats(...)
end

return Mod