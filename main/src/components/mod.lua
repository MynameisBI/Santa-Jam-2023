local Component = require 'src.components.component'

local Mod = Class('Mod', Component)

function Mod:initialize()
  Component.initialize(self)
end

return Mod