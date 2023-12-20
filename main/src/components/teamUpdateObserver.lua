local Component = require 'src.components.component'

local TeamUpdateObserver = Class('TeamUpdateObserver', Component)

function TeamUpdateObserver:initialize()
  Component.initialize(self)

  self.teamUpdated = false
end

function TeamUpdateObserver:notify()
  self.teamUpdated = true
end

return TeamUpdateObserver