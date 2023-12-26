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
end

function ManageResources:earlysystemupdate(dt)
  if self.phase:current() == 'battle' then
    self.resources:modifyEnergy(self.resources:getMaxEnergy() * self.resources.ENERGY_PERCENT_REGEN_RATE * dt)

    if self.artificerRegening then
      self.resources.secondsUntilArtifierRegen = self.resources.secondsUntilArtifierRegen - dt
      if self.resources.secondsUntilArtifierRegen <= 0 then
        self.resources.secondsUntilArtifierRegen = self.resources.SECONDS_PER_ARTIFICER_REGEN
        self.resources:modifyEnergy(self.resources.artificerRegenAmount)
      end
    end

    if self.resources.secondsAuroraRegenLeft > 0 then
      self.resources:modifyEnergy(self.resources.auroraRegenSpeed * dt)
    end
    self.resources.secondsAuroraRegenLeft = self.resources.secondsAuroraRegenLeft - dt
  end

  -- on phase changed
  if self.lastFramePhase ~= self.phase:current() then
    self.resources:modifyEnergy(math.huge)

    if self.phase:current() == 'battle' then
      local artificerSynergy = Lume.match(self.teamSynergy.synergies, function(synergy) return synergy.trait == 'artificer' end)
      if artificerSynergy then
        if artificerSynergy.nextThresholdIndex ~= 1 then
          self.artificerRegening = true
          self.resources.secondsUntilArtifierRegen = self.resources.SECONDS_PER_ARTIFICER_REGEN
          self.resources.artificerRegenAmount = self.teamSynergy.ARTIFICER_ENERGY_THRESHOLD[artificerSynergy.nextThresholdIndex-1]
        end
      end
    
    elseif self.phase:current() == 'planning' then
      self.artificerRegening = false
      self.resources.artificerRegenAmount = 0
    end

    self.resources.secondsAuroraRegenLeft = 0
  end

  self.lastFramePhase = self.phase:current()
end

return ManageResources