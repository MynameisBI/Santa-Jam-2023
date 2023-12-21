local System = require 'src.systems.system'

local UpdateTargetSkill = Class('UpdateTargetSkill', System)

function UpdateTargetSkill:initialize()
  System.initialize(self, 'Transform', 'TargetSkill')
end

function UpdateTargetSkill:update(transform, targetSkill, dt)
  transform:setGlobalPosition(targetSkill.enemyEntity:getComponent('Transform'):getGlobalPosition())

  if targetSkill.secondsUntilDetonate > 0 then
    targetSkill.secondsUntilDetonate = targetSkill.secondsUntilDetonate - dt

  else
    local continuousInfo = targetSkill.continuousInfo

    if continuousInfo == nil then
      local heroStats = targetSkill.hero:getStats()
      local damageInfo = targetSkill.damageInfo
      self:damageEnemy(heroStats, damageInfo, targetSkill.enemyEntity)

      Hump.Gamestate.current():removeEntity(transform:getEntity())

    else
      if continuousInfo.secondsUnitlNextTick > 0 then
        continuousInfo.secondsUnitlNextTick = continuousInfo.secondsUnitlNextTick - dt

      else
        local heroStats = targetSkill.hero:getStats()
        local damageInfo = targetSkill.damageInfo
        self:damageEnemy(heroStats, damageInfo, targetSkill.enemyEntity)
        
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

function UpdateTargetSkill:damageEnemy(stats, damageInfo, enemyEntity)
  local damage = stats.attackDamage * damageInfo.attackDamageRatio + stats.realityPower * damageInfo.realityPowerRatio
    if damageInfo.canCrit and math.random() < stats.critChance then damage = damage * stats.critDamage end

  print(('%s take %d %s damage'):format(
      tostring(enemyEntity), damage, damageInfo.damageType))
end

return UpdateTargetSkill