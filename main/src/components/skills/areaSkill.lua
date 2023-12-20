local Component = require 'src.components.component'

local AreaSkill = Class('AreaSkill', Component)

function AreaSkill:initialize(hero, x, y, range, damageInfo, secondsUntilDetonate)
  Component.initialize(self)

  self.hero = hero

  self.x, self.y = x, y
  self.range = range

  self.damageInfo = damageInfo or {}
  self.damageInfo.damageType = damageInfo.damageType or 'reality'
  self.damageInfo.attackDamageRatio = damageInfo.attackDamageRatio or 0
  self.damageInfo.realityPowerRatio = damageInfo.realityPowerRatio or 0
  self.damageInfo.canCrit = damageInfo.canCrit or false

  self.secondsUntilDetonate = secondsUntilDetonate or 0
end

return AreaSkill