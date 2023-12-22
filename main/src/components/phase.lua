local SingletonComponent = require 'src.components.singletonComponent'

local Phase = Class('Phase', SingletonComponent)

function Phase:initialize()
  SingletonComponent.initialize(self)

  self._currentPhase = 'planning'

  self.rounds = {
    {mainType = 'enemy', subType = 'a'},
    {mainType = 'enemy', subType = 'b'},
    {mainType = 'enemy', subType = 'A'},
    {mainType = 'enemy', subType = 'B'},
  }
end

function Phase:switch(phase)
  assert(phase == 'planning' or phase == 'battle', 'Invalid phase')
  self._currentPhase = phase
end

function Phase:current()
  return self._currentPhase 
end

function Phase:enqueueRound(mainType, subType)
  assert(mainType == 'enemy' or mainType == 'elite' or mainType == 'dealer', 'Invalid round type')
  self.rounds[#self.rounds+1] = {mainType = mainType, subType = subType}
end

function Phase:dequeueRound()
  local round = self.rounds[1]

  if round == nil then
    print('win')

  else
    table.remove(self.rounds, 1)
    return round
  end
end

return Phase