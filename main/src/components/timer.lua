local Component = require 'src.components.component'

local Timer = Class('Timer', Component)

function Timer:initialize()
  Component.initialize(self)
  self.timer = Hump.Timer()
end

return Timer