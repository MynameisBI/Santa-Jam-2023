local System = require 'src.systems.system'

local UpdateTargetSkill = Class('UpdateTargetSkill', System)

function UpdateTargetSkill:initialize()
  System.initialize(self, 'Transform', 'TargetSkill')
end

function UpdateTargetSkill:update(transform, targetSkill, dt)
  if targetSkill.enemyEntity:getComponent('Enemy').stats.HP <= 0 then
    Hump.Gamestate.current():removeEntity(transform:getEntity())
    return
  end

  transform:setGlobalPosition(targetSkill.enemyEntity:getComponent('Transform'):getGlobalPosition())

  if targetSkill.secondsUntilDetonate > 0 then
    targetSkill.secondsUntilDetonate = targetSkill.secondsUntilDetonate - dt

  else
    local continuousInfo = targetSkill.continuousInfo

    if continuousInfo == nil then
      local damageInfo = targetSkill.damageInfo
      self:damageEnemy(targetSkill.hero, damageInfo, targetSkill.enemyEntity)

      Hump.Gamestate.current():removeEntity(transform:getEntity())

    else
      if continuousInfo.secondsUnitlNextTick > 0 then
        continuousInfo.secondsUnitlNextTick = continuousInfo.secondsUnitlNextTick - dt

      else
        local damageInfo = targetSkill.damageInfo
        self:damageEnemy(targetSkill.hero, damageInfo, targetSkill.enemyEntity)
        
        continuousInfo.tickCount = continuousInfo.tickCount - 1
        if continuousInfo.tickCount <= 0 then 
          Hump.Gamestate.current():removeEntity(transform:getEntity())
        else
          continuousInfo.secondsUnitlNextTick = continuousInfo.secondsPerTick
        end
      end
    end
  end
end

function UpdateTargetSkill:damageEnemy(hero, damageInfo, enemyEntity)
  local damage = hero:getDamageFromRatio(damageInfo.attackDamageRatio,
      damageInfo.realityPowerRatio, damageInfo.canCrit) 
  enemyEntity:getComponent('Enemy'):takeDamage(damage, damageInfo.damageType, damageInfo.armorIgnoreRatio, hero)
end

return UpdateTargetSkill