local SingletonComponent = require 'src.components.singletonComponent'

local Phase = Class('Phase', SingletonComponent)

function Phase:initialize()
  SingletonComponent.initialize(self)

  self._currentPhase = 'planning'

  self.rounds = {
    {mainType = 'enemy', subType = '~1'},
    {mainType = 'dealer', value = 1},
    {mainType = 'enemy', subType = '~2'},
    {mainType = 'elite', subType = 'A1'},
    {mainType = 'enemy', subType = 'A6'},
  }
  self.totalRoundCount = #self.rounds
  self.currentRound = nil
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

function Phase:getCurrentRound()
  return self.rounds[1]
end

function Phase:getCurrentRoundIndex()
  return self.totalRoundCount - #self.rounds + 1
end

function Phase:dequeueRound()
  Hump.Gamestate.current().guis[1]:onRoundEnd()

  if self.rounds[1] == nil then
    print('win')
  end

  table.remove(self.rounds, 1)

  if self.rounds[1].mainType == 'dealer' then
    Hump.Gamestate.current().guis[1]:onRoundStart()
  end
end

function Phase:switchNextRound()
  Hump.Gamestate.current().guis[1]:onRoundEnd()

  if self.rounds[1] == nil then
    print('win')
  end

  table.remove(self.rounds, 1)

  if self.rounds[1].mainType == 'dealer' then
    self:startCurrentRound()
    Hump.Gamestate.current().guis[4]:open(self.rounds[1].value)
  end
end

function Phase:startCurrentRound()
  Hump.Gamestate.current().guis[1]:onRoundStart()
end

return Phase