local Phase = require 'src.components.phase'
local TeamSynergy = require 'src.components.teamSynergy'

local SingletonComponent = require 'src.components.singletonComponent'

local Resources = Class('Resources', SingletonComponent)

Resources.UPGRADE_MONEY_THRESHOLD = {10, 20, 30, 40}
Resources.UPGRADE_ENERGY_GAIN = 100

Resources.PERFORM_MONEY_THRESHOLD = {8, 12, 16, 20, 24, 28}
Resources.PERFORM_STYLE_GAIN = 50

Resources.ENERGY_PERCENT_REGEN_RATE = 0.1

function Resources:initialize(teamSlots, startingMoney, startingStyle)
  SingletonComponent.initialize(self)

  self.teamSlots = teamSlots

  self._money = startingMoney or 10
  self._style = startingStyle or 0

  self.upgradeMoneyThresholdIndex = 1
  self.performMoneyThresholdIndex = 1

  self._health = 100
  self._baseMaxHealth = 100
  self._energy = 200
  self._baseMaxEnergy = 200
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
  self._health = math.min(self:getMaxHealth(), self._energy)
  if self._health < 0 then
    self._health = self._health - modifier
    return false
  end
  return true
end

function Resources:getHealth()
  return self._health
end

function Resources:modifyBaseMaxHealth(modifier)
  self._baseMaxHealth = self._baseMaxHealth + modifier
  if self._baseMaxHealth < 0 then
    self._baseMaxHealth = self._baseMaxHealth - modifier
    return false
  end
  return true
end

function Resources:getMaxHealth()
  return self._baseMaxHealth
end

function Resources:modifyEnergy(modifier)
  self._energy = self._energy + modifier
  self._energy = math.min(self:getMaxEnergy(), self._energy)
  if self._energy < 0 then
    self._energy = self._energy - modifier
    return false
  end
  return true
end

function Resources:getEnergy()
  local phase = Phase():current()
  if phase == 'planning' then
    return self:getMaxEnergy()
  elseif phase == 'battle' then
    return self._energy
  end
end

function Resources:modifyBaseMaxEnergy(modifier)
  self._baseMaxEnergy = self._baseMaxEnergy + modifier
  if self._baseMaxEnergy < 0 then
    self._baseMaxEnergy = self._baseMaxEnergy - modifier
    return false
  end
  return true
end

function Resources:getMaxEnergy()
  return self._baseMaxEnergy + TeamSynergy():getTeamEnergy()
end

return Resources