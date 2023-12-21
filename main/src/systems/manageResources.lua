local Phase = require 'src.components.phase'
local Resources = require 'src.components.resources'
local TeamSynergy = require 'src.components.teamSynergy'

local System = require 'src.systems.system'

local ManageResources = Class('ManageResources', System)

function ManageResources:initialize()
  System.initialize(self)

  self.phase = Phase()
  self.lastFramePhase = self.phase:current()

  self.resources = Resources()

  self.teamSynergy = TeamSynergy()
  
  self.secondsUntilArtifierRegen = 4
  self.artificerRegenAmount = 0
end

function ManageResources:earlysystemupdate(dt)
  if self.phase:current() == 'battle' then
    self.resources:modifyEnergy(self.resources:getMaxEnergy() * self.resources.ENERGY_PERCENT_REGEN_RATE * dt)

    if self.artificerRegening then
      self.secondsUntilArtifierRegen = self.secondsUntilArtifierRegen - dt
      if self.secondsUntilArtifierRegen <= 0 then
        self.secondsUntilArtifierRegen = self.resources.SECONDS_PER_ARTIFICER_REGEN
        self.resources:modifyEnergy(self.artificerRegenAmount)
      end
    end
  end

  -- on phase changed
  if self.lastFramePhase ~= self.phase:current() then
    self.resources:modifyEnergy(math.huge)

    if self.phase:current() == 'battle' then
      local artificerSynergy = Lume.match(self.teamSynergy.synergies, function(synergy) return synergy.trait == 'artificer' end)
      if artificerSynergy then
        if artificerSynergy.nextThresholdIndex ~= 1 then
          self.artificerRegening = true
          self.secondsUntilArtifierRegen = self.resources.SECONDS_PER_ARTIFICER_REGEN
          self.artificerRegenAmount = self.teamSynergy.ARTIFICER_ENERGY_THRESHOLD[artificerSynergy.nextThresholdIndex-1]
        end
      end
    
    else
      self.artificerRegening = false
      self.artificerRegenAmount = 0
    end
  end

  self.lastFramePhase = self.phase:current()
end

return ManageResources