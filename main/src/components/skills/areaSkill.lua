local Component = require 'src.components.component'

local AreaSkill = Class('AreaSkill', Component)

function AreaSkill:initialize(hero, x, y, range, damageInfo, secondsUntilDetonate, continuousInfo)
  Component.initialize(self)

  self.hero = hero

  self.x, self.y = x, y
  self.range = range

  self.damageInfo = {}
  self.damageInfo.damageType = damageInfo.damageType or 'reality'
  self.damageInfo.attackDamageRatio = damageInfo.attackDamageRatio or 0
  self.damageInfo.realityPowerRatio = damageInfo.realityPowerRatio or 0
  self.damageInfo.canCrit = damageInfo.canCrit or false

  self.continuousInfo = {}
  if self.continuousInfo then
    self.continuousInfo.tickCount = continuousInfo.tickCount or 6
    self.continuousInfo.secondsPerTick = continuousInfo.secondsPerTick or 0.5
    self.continuousInfo.secondsUnitlNextTick = 0
  end

  self.secondsUntilDetonate = secondsUntilDetonate or 0
end

return AreaSkill