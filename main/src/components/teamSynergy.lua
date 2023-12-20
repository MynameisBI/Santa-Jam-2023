local SingletonComponent = require 'src.components.singletonComponent'

local TeamSynergy = Class('TeamSynergy', SingletonComponent)

function TeamSynergy:initialize()
  SingletonComponent.initialize(self)

  self.teamSlots = {}

  -- `synergy` properties
    -- `trait`
    -- `count`
    -- `nextThresholdIndex`
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

TeamSynergy.TRAIT_THRESHOLD = {
  bigEar = {2, 4, 6},
  sentient = {2, 3, 4},
  defect = {2, 3, 4, 5},
  candyhead = {2},
  coordinator = {1, 3},
  artificer = {2, 3},
  trailblazer = {2, 4},
  droneMaestro = {1, 3, 5},
  cracker = {2, 3}
}

return TeamSynergy