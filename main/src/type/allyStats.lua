local AllyStats = Class('AllyStats', Component)

function AllyStats:initialize(attackDamage, realityPower, attackSpeed, range, critChance, critDamage, cooldownReduction, energy)
  self.attackDamage = attackDamage or 33
  self.realityPower = realityPower or 0
  self.attackSpeed = attackSpeed or 0
  self.range = range or 300
  self.critChance = critChance or 0
  self.critDamage = 2
  self.cooldownReduction = cooldownReduction or 0
  self.energy = energy or 0
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
    self.energy + otherStats.energy
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
  }
end

return AllyStats