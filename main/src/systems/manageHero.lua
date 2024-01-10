local TeamSynergy = require 'src.components.teamSynergy'
local Phase = require 'src.components.phase'
local Resources = require 'src.components.resources'

local System = require 'src.systems.system'

local ManageHero = System:subclass('ManageHero')

function ManageHero:initialize()
  System.initialize(self, 'Transform', 'Hero', 'TeamUpdateObserver')

  self.teamSynergy = TeamSynergy()
  self.phase = Phase()
  self.lastFramePhase = self.phase:current()
end

function ManageHero:update(transform, hero, teamUpdateObserver, dt)
  local isInTeam = self.teamSynergy:hasHeroComponent(hero)

  -- On switch to battle phase
  if self.lastFramePhase ~= self.phase:current() then
    self:onPhaseSwitch(self.phase:current(), isInTeam, hero)
  end

  self:updateHero(self.phase:current(), isInTeam, transform, hero, dt)
end

function ManageHero:latesystemupdate(dt)
  self.lastFramePhase = self.phase:current()
end

function ManageHero:updateHero(phase, isInTeam, transform, hero, dt)
  if phase == 'battle' and isInTeam then
    hero:onUpdate(dt)

    hero.secondsUntilAttackReady = hero.secondsUntilAttackReady - dt
    if hero.secondsUntilAttackReady <= 0 then
      local stats = hero:getStats()
      hero.secondsUntilAttackReady = 1 / stats.attackSpeed
      
      local x, y = transform:getGlobalPosition()
      local enemyEntities = Hump.Gamestate.current():getEntitiesWithComponent('Enemy')
      local nearestEnemyEntity = Lume.nearest(x, y, enemyEntities,
          function(enemyEntity) return enemyEntity:getComponent('Transform'):getGlobalPosition() end)
      
      if nearestEnemyEntity then
        local ex, ey = nearestEnemyEntity:getComponent('Transform'):getGlobalPosition()

        if Lume.distance(x, y, ex, ey) <= stats.range then
          local attackAccepted = hero:onBasicAttack(nearestEnemyEntity)
          if attackAccepted ~= false then
            if hero.bulletClass == nil then
                nearestEnemyEntity:getComponent('Enemy'):takeDamage(
                  hero:getBasicAttackDamage(nearestEnemyEntity), 'physical', stats.physicalArmorIgnoreRatio, hero)
            else
              Hump.Gamestate.current():addEntity(
                hero.bulletClass(x, y, hero, nearestEnemyEntity)
              )
            end

            if hero.modEntity then
              local modEntity = hero.modEntity
              if modEntity:getComponent('Mod').id == 'PBB' then
                Resources():modifyEnergy(modEntity.class.ENERGY_PER_ATTACK)
              end
            end

            hero:getEntity():getComponent('Animator'):setCurrentAnimationName('attack')
          end
        end
      end
    end

    local skill = hero.skill
    skill.secondsUntilSkillReady = skill.secondsUntilSkillReady - dt
    if skill.secondsUntilSkillReady < 0 then
      if skill.chargeCount < skill:getMaxChargeCount() then
        skill.chargeCount = skill.chargeCount + 1
        skill.secondsUntilSkillReady = skill.secondsUntilSkillReady + skill:getCooldown()
      end
    end

    for i = #hero.temporaryModifierStatses, 1, -1 do
      hero.temporaryModifierStatses[i].duration = hero.temporaryModifierStatses[i].duration - dt
      if hero.temporaryModifierStatses[i].duration <= 0 then
        table.remove(hero.temporaryModifierStatses, i)
      end
    end
  end
end

function ManageHero:onPhaseSwitch(phase, isInTeam, hero)
  if phase == 'battle' then
    if isInTeam then
      hero.skill.chargeCount = hero.skill:getMaxChargeCount()
    end
    hero:onBattleStart(isInTeam, self.teamSynergy:getHeroComponentsInTeam())

  elseif phase == 'planning' then
    hero:onBattleEnd(isInTeam, self.teamSynergy:getHeroComponentsInTeam())
  end
end



return ManageHero
