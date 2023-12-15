local SingletonComponent = require 'src.components.singletonComponent'

local Resources = Class('Resources', SingletonComponent)

function Resources:initialize(startingMoney, startingStyle)
  SingletonComponent.initialize(self)

  self._money = startingMoney or 10
  self._startingStyle = startingStyle or 0
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

function Resources:getStyle()
  return self._startingStyle
end

return Resources