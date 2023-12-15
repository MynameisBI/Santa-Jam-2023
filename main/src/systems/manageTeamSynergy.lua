local System = require 'src.systems.system'

local ManageTeamSynergy = Class('ManageTeamSynergy', System)

function ManageTeamSynergy:initialize()
  System.initialize(self, 'TeamSynergy', 'TeamUpdateObserver')
end

function ManageTeamSynergy:update(teamSynergy, teamUpdateObserver, dt)
  if not teamUpdateObserver.teamUpdated then return end

  local heroes = {}
  for _, slot in ipairs(teamSynergy.teamSlots) do
    if slot.draggable then
      table.insert(heroes, slot.draggable:getEntity():getComponent('Hero'))
    end
  end

  teamSynergy.synergies = {}
  for _, hero in ipairs(heroes) do
    for _, trait in ipairs(hero.traits) do
      local synergy = Lume.match(teamSynergy.synergies, function(synergy) return synergy.trait == trait end)
      if synergy == nil then
        synergy = {trait = trait, count = 0}
        table.insert(teamSynergy.synergies, synergy)
      end
      synergy.count = synergy.count + 1
    end
  end

  teamUpdateObserver.teamUpdated = false
end

return ManageTeamSynergy