local Phase = require 'src.components.phase'
local TeamSynergy = require 'src.components.teamSynergy'

local SingletonComponent = require 'src.components.singletonComponent'

local Resources = Class('Resources', SingletonComponent)

Resources.STARTING_MONEY = 100
Resources.STARTING_STYLE = 0

Resources.UPGRADE_MONEY_THRESHOLD = {10, 20, 30, 40, 50}
Resources.UPGRADE_ENERGY_GAIN = 100

Resources.PERFORM_MONEY_THRESHOLD = {8, 12, 16, 20, 24, 28}
Resources.PERFORM_STYLE_GAIN = 50

Resources.ENERGY_PERCENT_REGEN_RATE = 0.01

Resources.SECONDS_PER_ARTIFICER_REGEN = 4

function Resources:initialize(startingMoney, startingStyle)
  SingletonComponent.initialize(self)

  self._money = startingMoney or Resources.STARTING_MONEY
  self._style = startingStyle or Resources.STARTING_STYLE

  self.upgradeMoneyThresholdIndex = 1
  self.performMoneyThresholdIndex = 1

  self._health = 100
  self._baseMaxHealth = 100
  self._energy = 200
  self._baseMaxEnergy = 200

  self.secondsUntilArtifierRegen = 4
  self.artificerRegenAmount = 0

  self.secondsAuroraRegenLeft = 0
  self.auroraRegenSpeed = 0
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
  self._health = math.min(self:getMaxHealth(), self._health)
  if self._health < 0 then
    print('lost')
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