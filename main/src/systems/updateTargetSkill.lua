local System = require 'src.systems.system'

local UpdateTargetSkill = Class('UpdateTargetSkill', System)

function UpdateTargetSkill:initialize()
  System.initialize(self, 'Transform', 'TargetSkill')
end

function UpdateTargetSkill:update(transform, targetSkill, dt)
  transform:setGlobalPosition(targetSkill.enemyEntity:getComponent('Transform'):getGlobalPosition())

  targetSkill.secondsUntilDetonate = targetSkill.secondsUntilDetonate - dt
  if targetSkill.secondsUntilDetonate <= 0 then
    local stats = targetSkill.hero:getStats()
    local damageInfo = targetSkill.damageInfo

    local damage = stats.attackDamage * damageInfo.attackDamageRatio + stats.realityPower * damageInfo.realityPowerRatio
    if damageInfo.canCrit and math.random() < stats.critChance then damage = damage * stats.critDamage end

    print(('%s take %d %s damage'):format(
        tostring(targetSkill.enemyEntity), damage, targetSkill.damageInfo.damageType))

    Hump.Gamestate.current():removeEntity(transform:getEntity())
  end
end

return UpdateTargetSkill