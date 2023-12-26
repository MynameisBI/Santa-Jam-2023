local Component = require 'src.components.component'

local AreaSkill = Class('AreaSkill', Component)

function AreaSkill:initialize(hero, targetInfo, w, h, damageInfo, secondsUntilDetonate, continuousInfo)
  Component.initialize(self)

  self.hero = hero

  -- `targetInfo` can be nil or a table with properties `x` and `y`
  self.targetInfo = targetInfo
  self.w, self.h = w or 200, h or 60

  self.damageInfo = damageInfo or {}
  self.damageInfo.damageType = damageInfo.damageType or 'reality'
  self.damageInfo.attackDamageRatio = damageInfo.attackDamageRatio or 0
  self.damageInfo.realityPowerRatio = damageInfo.realityPowerRatio or 0
  self.damageInfo.canCrit = damageInfo.canCrit or false
  self.damageInfo.armorIgnoreRatio = damageInfo.armorIgnoreRatio or 0
  self.damageInfo.effects = damageInfo.effects or {}

  self.continuousInfo = {tickCount = 0, secondsPerTick = 1, secondsUnitlNextTick = 0}
  if continuousInfo then
    self.continuousInfo.tickCount = continuousInfo.tickCount or 6
    self.continuousInfo.secondsPerTick = continuousInfo.secondsPerTick or 0.5
  end

  self.secondsUntilDetonate = secondsUntilDetonate or 0
end

return AreaSkill