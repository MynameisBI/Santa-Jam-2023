local AllyStats = Class('AllyStats', Component)

function AllyStats:initialize(attackDamage, realityPower, attackSpeed, range, critChance, critDamage, cooldownReduction, energy, physicalArmorIgnoreRatio, realityArmorIgnoreRatio)
  self.attackDamage = attackDamage or (function() print('Warning: default stats attack damage is not 0'); return 33 end)()
  self.realityPower = realityPower or 0
  self.attackSpeed = attackSpeed or (function() print('Warning: default stats attack speed is not 0'); return 1 end)()
  self.range = range or 0
  self.critChance = critChance or 0
  self.critDamage = critDamage or (function() print('Warning: default crit damage is not 0'); return 2 end)()
  self.cooldownReduction = cooldownReduction or 0
  self.energy = energy or 0
  
  self.physicalArmorIgnoreRatio = physicalArmorIgnoreRatio or 0
  self.realityArmorIgnoreRatio = realityArmorIgnoreRatio or 0
end

function AllyStats:__add(otherStats)
  return AllyStats(
    self.attackDamage + otherStats.attackDamage,
    self.realityPower + otherStats.realityPower,
    self.attackSpeed + otherStats.attackSpeed,
    self.range + otherStats.range,
    self.critChance + otherStats.critChance,
    self.critDamage + otherStats.critDamage,
    self.cooldownReduction + otherStats.cooldownReduction,
    self.energy + otherStats.energy,
    self.physicalArmorIgnoreRatio + otherStats.physicalArmorIgnoreRatio,
    self.realityArmorIgnoreRatio + otherStats.realityArmorIgnoreRatio
  )
end

function AllyStats:getValues()
  return {
    attackDamage = self.attackDamage,
    realityPower = self.realityPower,
    attackSpeed = self.attackSpeed,
    range = self.range,
    critChance = self.critChance,
    critDamage = self.critDamage,
    cooldownReduction = self.cooldownReduction,
    energy = self.energy,
    physicalArmorIgnoreRatio = self.physicalArmorIgnoreRatio,
    realityArmorIgnoreRatio = self.realityArmorIgnoreRatio
  }
end

return AllyStats