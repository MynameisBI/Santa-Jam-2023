local Hero = require 'src.components.hero'

local SingletonComponent = require 'src.components.singletonComponent'

local TeamSynergy = Class('TeamSynergy', SingletonComponent)

function TeamSynergy:initialize(teamSlots)
  SingletonComponent.initialize(self)

  self.teamSlots = teamSlots or {}
  self.synergies = {}
end

return TeamSynergy