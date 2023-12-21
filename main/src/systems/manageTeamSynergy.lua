local Phase = require 'src.components.phase'
local AllyStats = require 'src.type.allyStats'

local System = require 'src.systems.system'

local ManageTeamSynergy = Class('ManageTeamSynergy', System)

function ManageTeamSynergy:initialize()
  System.initialize(self, 'TeamSynergy', 'TeamUpdateObserver')

  self.lastFramePhase = Phase():current()
end

function ManageTeamSynergy:update(teamSynergy, teamUpdateObserver, dt)
  -- on team updated for heroes in team
  if teamUpdateObserver.teamUpdated then
    self:onTeamUpdated(teamSynergy)
    teamUpdateObserver.teamUpdated = false
  end


  -- on battle start event for heroes in team
  local thisFramePhase = Phase():current()
  if self.lastFramePhase ~= thisFramePhase and thisFramePhase == 'battle' then
    local heroComponents = teamSynergy:getHeroComponentsInTeam()
    
  end
end

function ManageTeamSynergy:onTeamUpdated(teamSynergy)
  local heroComponents = teamSynergy:getHeroComponentsInTeam()


  -- Update team synergy
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


  -- Reset all hero modifiers
  for _, hero in ipairs(Hump.Gamestate.current():getComponents('Hero')) do
    hero.modifierStatses = {}
    hero.overrides = {}
  end
  -- Apply team synergy to individual heroes in team
  for _, synergy in ipairs(teamSynergy.synergies) do
    for _, hero in ipairs(heroComponents) do
      if synergy.trait == 'bigEar' and synergy.nextThresholdIndex ~= 1 then
        hero:addModiferStats(
            AllyStats(0, 0, 0, 0, 0, 0, teamSynergy.BIG_EAR_CDR_THRESHOLD[synergy.nextThresholdIndex-1]))

        hero.overrides.getMaxChargeCount = function(skill)
          return 1
        end
        
      elseif synergy.trait == 'sentient' and synergy.nextThresholdIndex ~= 1 then
        hero:addModiferStats(
            AllyStats(0, 0, teamSynergy.SENTIENT_AS_THRESHOLD[synergy.nextThresholdIndex-1], 0))

        hero.overrides.onSkillCast = function(skill)
          hero:addTemporaryModifierStats(
              AllyStats(0, 0, teamSynergy.SENTIENT_AS_THRESHOLD[synergy.nextThresholdIndex-1], 0), 2)
        end

      elseif synergy.trait == 'defect' and synergy.nextThresholdIndex ~= 1 then
        hero:addModiferStats(
            AllyStats(0, teamSynergy.DEFECT_RP_THRESHOLD[synergy.nextThresholdIndex-1]))

        hero.overrides.getStats = function(hero)
          local stats = hero.baseStats[hero.level]
          local baseAttackDamage = stats.attackDamage
          if hero.modEntity then
            stats = stats + hero.modEntity:getComponent('Mod').stats
          end
          for _, modifierStats in ipairs(hero.modifierStatses) do
            stats = stats + modifierStats
          end
          for _, temporaryModifierStats in ipairs(hero.temporaryModifierStatses) do
            stats = stats + temporaryModifierStats
          end
          local bonusAttackDamage = stats.attackDamage - baseAttackDamage
          stats.attackDamage = stats.attackDamage - bonusAttackDamage
          stats.realityPower = stats.realityPower + bonusAttackDamage
          return stats
        end

      elseif synergy.trait == 'candyhead' then

      elseif synergy.trait == 'coordinator' then
        if synergy.count == 1 then
          hero:addModiferStats(AllyStats(0, 0, 0, 0, teamSynergy.COORDINATOR_CRIT_THRESHOLD[1], 0))
        elseif synergy.count == 3 then
          hero:addModiferStats(AllyStats(0, 0, 0, 0, teamSynergy.COORDINATOR_CRIT_THRESHOLD[2], 0))
        end

      elseif synergy.trait == 'artificer' then
        
      elseif synergy.trait == 'trailblazer' and synergy.nextThresholdIndex ~= 1 then
        hero.overrides.getBasicAttackDamage = function(hero, enemyEntity)
          local baseDamage = hero:getDamageFromRatio(1, 0, true, enemyEntity)

          local hx, hy = hero:getEntity():getComponent('Transform'):getGlobalPosition()
          local ex, ey = enemyEntity:getComponent('Transform'):getGlobalPosition()
          local dist = Lume.distance(hx, hy, ex, ey)
          local stats = hero:getStats()
          return baseDamage * (1 + 
              teamSynergy.TRAILBLAZER_DAMAGE_BONUS_THRESHOLD[synergy.nextThresholdIndex-1] * (1 - dist / stats.range))
        end
      
      elseif synergy.trait == 'droneMaestro' then
        
      
      elseif synergy.trait == 'cracker' then
      
      end
    end
  end
end

return ManageTeamSynergy