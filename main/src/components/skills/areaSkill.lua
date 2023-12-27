local Component = require 'src.components.component'

local AreaSkill = Class('AreaSkill', Component)

function AreaSkill:initialize(hero, targetInfo, w, h, damageInfo, secondsUntilDetonate, continuousInfo, centerDamageInfo, centerW, centerH)
  Component.initialize(self)

  self.hero = hero

  -- `targetInfo` can be nil or a table with properties `x` and `y`
  self.targetInfo = targetInfo
  self.w, self.h = w or 200, h or 60

  self.damageInfo = damageInfo or {}
  self.damageInfo.damageType = self.damageInfo.damageType or 'reality'
  self.damageInfo.attackDamageRatio = self.damageInfo.attackDamageRatio or 0
  self.damageInfo.realityPowerRatio = self.damageInfo.realityPowerRatio or 0
  self.damageInfo.canCrit = self.damageInfo.canCrit or false
  self.damageInfo.armorIgnoreRatio = self.damageInfo.armorIgnoreRatio or 0
  self.damageInfo.effects = self.damageInfo.effects or {}

  self.continuousInfo = {tickCount = 0, secondsPerTick = 1, secondsUnitlNextTick = 0}
  if continuousInfo then
    self.continuousInfo.tickCount = continuousInfo.tickCount or 6
    self.continuousInfo.secondsPerTick = continuousInfo.secondsPerTick or 0.5
  end

  self.secondsUntilDetonate = secondsUntilDetonate or 0


  self.centerW, self.centerH = centerW, centerH

  self.centerDamageInfo = centerDamageInfo or {}
  self.centerDamageInfo.damageType = self.centerDamageInfo.damageType or 'reality'
  self.centerDamageInfo.attackDamageRatio = self.centerDamageInfo.attackDamageRatio or 0
  self.centerDamageInfo.realityPowerRatio = self.centerDamageInfo.realityPowerRatio or 0
  self.centerDamageInfo.canCrit = self.centerDamageInfo.canCrit or false
  self.centerDamageInfo.armorIgnoreRatio = self.centerDamageInfo.armorIgnoreRatio or 0
  self.centerDamageInfo.effects = self.centerDamageInfo.effects or {}
end

return AreaSkill