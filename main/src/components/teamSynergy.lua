local Hero = require 'src.components.hero'

local SingletonComponent = require 'src.components.singletonComponent'

local TeamSynergy = Class('TeamSynergy', SingletonComponent)

function TeamSynergy:initialize(teamSlots)
  SingletonComponent.initialize(self)

  self.teamSlots = teamSlots or {}
  self.synergies = {}
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