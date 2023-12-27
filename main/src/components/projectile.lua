local Component = require 'src.components.component'

local Projectile = Class('Projectile', Component)

function Projectile:initialize(hero, damageInfo, dirX, dirY, speed)
  Component.initialize(self)

  self.hero = hero

  self.damageInfo = damageInfo or {}
  self.damageInfo.damageType = self.damageInfo.damageType or 'reality'
  self.damageInfo.attackDamageRatio = self.damageInfo.attackDamageRatio or 0
  self.damageInfo.realityPowerRatio = self.damageInfo.realityPowerRatio or 0
  self.damageInfo.canCrit = self.damageInfo.canCrit or false
  self.damageInfo.armorIgnoreRatio = self.damageInfo.armorIgnoreRatio or 0
  self.damageInfo.effects = self.damageInfo.effects or {}

  self.dirX = dirX or 0
  self.dirY = dirY or 0
  self.speed = speed or 0
  self.secondsUntilDisappear = 4
end

return Projectile