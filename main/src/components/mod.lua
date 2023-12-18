local Hero = require 'src.components.hero'
local Component = require 'src.components.component'

local Mod = Class('Mod', Component)

function Mod:initialize(id, name, description, ...)
  Component.initialize(self)

  assert(type(id) == 'string', 'Invalid id')
  self.id = id

  self.name = name or ''
  self.description = description or ''
  self.stats = Hero.Stats(...)
end

return Mod