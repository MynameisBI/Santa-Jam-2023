local Component = require 'src.components.component'

local Trap = Class('Trap', Component)

function Trap:initialize(secondsUntilArmed, secondsUntilDetonate, onActivation)
  Component.initialize(self)

  self.secondsUntilArmed = secondsUntilArmed or 0

  self.secondsUntilDetonate = secondsUntilDetonate or 10

  self.onActivation = onActivation or function(enemies) end
end

return Trap