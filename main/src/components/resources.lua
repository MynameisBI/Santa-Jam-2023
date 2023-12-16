local SingletonComponent = require 'src.components.singletonComponent'

local Resources = Class('Resources', SingletonComponent)

Resources.UPGRADE_MONEY_THRESHOLD = {10, 20, 30, 40}

Resources.PERFORM_MONEY_THRESHOLD = {8, 12, 16, 20, 24, 28}

function Resources:initialize(teamSlots, startingMoney, startingStyle)
  SingletonComponent.initialize(self)

  self.teamSlots = teamSlots

  self._money = startingMoney or 10
  self._style = startingStyle or 0

  self.upgradeMoneyThresholdIndex = 1
  self.performMoneyThresholdIndex = 1

  self._health = 100
  self._maxHealth = 100
  self._energy = 200
  self._maxEnergy = 200
end

function Resources:modifyMoney(modifier)
  self._money = self._money + modifier
  if self._money < 0 then
    self._money = self._money - modifier
    return false
  end
  return true
end

function Resources:getMoney()
  return self._money
end

function Resources:modifyStyle(modifier)
  self._style = self._style + modifier
  if self._style < 0 then
    self._style = self._style - modifier
    return false
  end
  return true
end

function Resources:getStyle()
  return self._style
end

function Resources:getUpgradeMoney()
  return Resources.UPGRADE_MONEY_THRESHOLD[self.upgradeMoneyThresholdIndex]
end

function Resources:getPerformMoney()
  return Resources.PERFORM_MONEY_THRESHOLD[self.performMoneyThresholdIndex]
end


function Resources:modifyHealth(modifier)
  self._health = self._health + modifier
  if self._health < 0 then
    self._health = self._health - modifier
    return false
  end
  return true
end

function Resources:getHealth()
  return self._health
end

function Resources:modifyMaxHealth(modifier)
  self._maxHealth = self._maxHealth + modifier
  if self._maxHealth < 0 then
    self._maxHealth = self._maxHealth - modifier
    return false
  end
  return true
end

function Resources:getMaxHealth()
  return self._maxHealth
end

function Resources:modifyEnergy(modifier)
  self._energy = self._energy + modifier
  if self._energy < 0 then
    self._energy = self._energy - modifier
    return false
  end
  return true
end

function Resources:getEnergy()
  return self._energy
end

function Resources:modifyMaxEnergy(modifier)
  self._maxEnergy = self._maxEnergy + modifier
  if self._maxEnergy < 0 then
    self._maxEnergy = self._maxEnergy - modifier
    return false
  end
  return true
end

function Resources:getMaxEnergy()
  return self._maxEnergy
end

return Resources