local System = require 'src.systems.system'

local UpdateTimer = Class('UpdateTimer', System)

function UpdateTimer:initialize()
  System.initialize(self, 'Timer')
end

function UpdateTimer:update(timer, dt)
  timer.timer:update(dt)
end

return UpdateTimer