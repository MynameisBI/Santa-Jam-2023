local Component = require 'src.components.component'

local TargetSkill = Class('TargetSkill', Component)

function TargetSkill:initialize(hero, enemyEntity, damageInfo, secondsUntilDetonate)
  Component.initialize(self)

  self.hero = hero

  self.enemyEntity = enemyEntity

  self.damageInfo = damageInfo or {}
  self.damageInfo.damageType = damageInfo.damageType or 'reality'
  self.damageInfo.attackDamageRatio = damageInfo.attackDamageRatio or 0
  self.damageInfo.realityPowerRatio = damageInfo.realityPowerRatio or 0
  self.damageInfo.canCrit = damageInfo.canCrit or false

  self.secondsUntilDetonate = secondsUntilDetonate or 0
end

return TargetSkill