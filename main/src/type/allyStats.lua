local AllyStats = Class('AllyStats', Component)

function AllyStats:initialize(attackDamage, realityPower, attackSpeed, range, critChance, critDamage)
  self.attackDamage = attackDamage or 33
  self.realityPower = realityPower or 0
  self.attackSpeed = attackSpeed or 0
  self.range = range or 300
  self.critChance = critChance or 0
  self.critDamage = critDamage or 0
end

function AllyStats:__add(otherStats)
  return AllyStats(
    self.attackDamage + otherStats.attackDamage,
    self.realityPower + otherStats.realityPower,
    self.attackSpeed + otherStats.attackSpeed,
    self.range + otherStats.range,
    self.critChance + otherStats.critChance,
    self.critDamage + otherStats.critDamage
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
  }
end

return AllyStats