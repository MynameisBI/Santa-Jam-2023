local Component = require 'src.components.component'

local TargetSkill = Class('TargetSkill', Component)

function TargetSkill:initialize(hero, enemyEntity, damageInfo, secondsUntilDetonate, continuousInfo)
  Component.initialize(self)

  self.hero = hero

  self.enemyEntity = enemyEntity

  self.damageInfo = damageInfo or {}
  self.damageInfo.damageType = damageInfo.damageType or 'reality'
  self.damageInfo.attackDamageRatio = damageInfo.attackDamageRatio or 0
  self.damageInfo.realityPowerRatio = damageInfo.realityPowerRatio or 0
  self.damageInfo.armorIgnoreRatio = damageInfo.armorIgnoreRatio or 0
  self.damageInfo.canCrit = damageInfo.canCrit or false

  self.continuousInfo = continuousInfo
  if self.continuousInfo then
    self.continuousInfo.tickCount = self.continuousInfo.tickCount or 6
    self.continuousInfo.secondsPerTick = self.continuousInfo.secondsPerTick or 0.5
    self.continuousInfo.secondsUnitlNextTick = 0
  end  

  self.secondsUntilDetonate = secondsUntilDetonate or 0
end

return TargetSkill