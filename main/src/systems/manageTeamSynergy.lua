local System = require 'src.systems.system'

local ManageTeamSynergy = Class('ManageTeamSynergy', System)

function ManageTeamSynergy:initialize()
  System.initialize(self, 'TeamSynergy', 'TeamUpdateObserver')
end

function ManageTeamSynergy:update(teamSynergy, teamUpdateObserver, dt)
  if not teamUpdateObserver.teamUpdated then return end

  local heroComponents = teamSynergy:getHeroComponentsInTeam()

  teamSynergy.synergies = {}
  for _, hero in ipairs(heroComponents) do
    for _, trait in ipairs(hero.traits) do
      local synergy = Lume.match(teamSynergy.synergies, function(synergy) return synergy.trait == trait end)
      if synergy == nil then
        synergy = {trait = trait, count = 0, nextThresholdIndex = 1}
        table.insert(teamSynergy.synergies, synergy)
      end
      synergy.count = synergy.count + 1
      if synergy.count >= teamSynergy.TRAIT_THRESHOLD[synergy.trait][synergy.nextThresholdIndex] then
        synergy.nextThresholdIndex = synergy.nextThresholdIndex + 1
      end
    end
  end

  table.sort(teamSynergy.synergies, function(syn1, syn2)
    if syn1.nextThresholdIndex == 1 and syn2.nextThresholdIndex ~= 1 then
      return false
    elseif syn1.nextThresholdIndex ~= 1 and syn2.nextThresholdIndex == 1 then
      return true
    else
      return syn1.count > syn2.count
    end
  end)

  teamUpdateObserver.teamUpdated = false
end

return ManageTeamSynergy