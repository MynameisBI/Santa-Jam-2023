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

return Resources