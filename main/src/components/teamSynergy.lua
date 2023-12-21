local SingletonComponent = require 'src.components.singletonComponent'

local TeamSynergy = Class('TeamSynergy', SingletonComponent)

TeamSynergy.TRAIT_THRESHOLD = {
  bigEar = {2, 4, 6},
  sentient = {2, 3, 4},
  defect = {2, 3, 4, 5},
  candyhead = {2},
  coordinator = {1, 3},
  artificer = {2},
  trailblazer = {2, 3, 4},
  droneMaestro = {1, 3, 5},
  cracker = {2, 3}
}

TeamSynergy.BIG_EAR_CDR_THRESHOLD = {0.05, 0.2, 0.45}
TeamSynergy.SENTIENT_AS_THRESHOLD = {0.2, 0.325, 0.5}
TeamSynergy.DEFECT_RP_THRESHOLD = {20, 35, 50, 65}

TeamSynergy.COORDINATOR_CRIT_THRESHOLD = {0.3, 0.6}
TeamSynergy.ARTIFICER_ENERGY_THRESHOLD = {50}
TeamSynergy.TRAILBLAZER_DAMAGE_BONUS_THRESHOLD = {0.5, 0.75, 1}
TeamSynergy.DRONE_MAESTRO_DRONE_DAMAGE_THRESHOLD = {10, 16, 24} 
TeamSynergy.CRACKER_CRACK_INTERVAL_THRESHOLD = {4, 2}

function TeamSynergy:initialize()
  SingletonComponent.initialize(self)

  self.teamSlots = {}

  -- `synergy` properties
    -- `trait`
    -- `count`
    -- `nextThresholdIndex`: the `nextThresholdIndex` will always be the current threshold+1, even when the threshold doesn't exist
  self.synergies = {}
end

function TeamSynergy:setTeamSlots(teamSlots)
  self.teamSlots = teamSlots
end

function TeamSynergy:getHeroComponentsInTeam()
  local heroComponents = {}
  for _, slot in ipairs(self.teamSlots) do
    local dropSlotComponent = slot:getComponent('DropSlot')
    if dropSlotComponent.draggable then
      table.insert(heroComponents, dropSlotComponent.draggable:getEntity():getComponent('Hero'))
    end
  end
  return heroComponents
end

function TeamSynergy:getTeamEnergy()
  local energy = 0
  local heroComponents = self:getHeroComponentsInTeam()
  for _, heroComponent in ipairs(heroComponents) do
    local stats = heroComponent:getStats()
    energy = energy + stats.energy
  end
  return energy
end

function TeamSynergy:hasHeroComponent(heroComponent)
  return Lume.find(self:getHeroComponentsInTeam(), heroComponent) and true or false
end

return TeamSynergy