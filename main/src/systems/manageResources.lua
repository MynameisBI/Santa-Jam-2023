local Phase = require 'src.components.phase'
local Resources = require 'src.components.resources'

local System = require 'src.systems.system'

local ManageResources = Class('ManageResources', System)

function ManageResources:initialize()
  System.initialize(self)

  self.phase = Phase()
  self.lastFramePhase = self.phase:current()

  self.resources = Resources()
end

function ManageResources:earlysystemupdate(dt)
  if self.phase:current() == 'battle' then
    self.resources:modifyEnergy(self.resources:getMaxEnergy() * self.resources.ENERGY_PERCENT_REGEN_RATE * dt)
  end

  -- on phase changed
  if self.lastFramePhase ~= self.phase:current() then
    self.resources:modifyEnergy(math.huge)
  end

  self.lastFramePhase = self.phase:current()
end

return ManageResources