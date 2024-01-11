local SingletonComponent = require 'src.components.singletonComponent'

local Phase = Class('Phase', SingletonComponent)

function Phase:initialize()
  SingletonComponent.initialize(self)

  self._currentPhase = 'planning'

  self.rounds = {}
  self:initializeRounds()
    
  self.totalRoundCount = #self.rounds
  self.currentRound = nil
end

function Phase:initializeRounds()
  self.rounds[1] = {mainType = 'enemy', subType = '~1'}
  self.rounds[1] = {mainType = 'elite', subType = 'C1'}
  self.rounds[2] = {mainType = 'enemy', subType = '~2'}
  self.rounds[3] = {mainType = 'dealer', value = 1}

  self.rounds[4] = {mainType = 'enemy', subType = 'A1'}
  self.rounds[5] = {mainType = 'enemy', subType = 'A1'}
  self.rounds[6] = {mainType = 'enemy', subType = 'A6'}
  if math.random() > 0.5 then
    self.rounds[7] = {mainType = 'dealer', value = 1}
    self.rounds[8] = {mainType = 'enemy', subType = 'A6'}
  else
    self.rounds[7] = {mainType = 'enemy', subType = 'A6'}
    self.rounds[8] = {mainType = 'dealer', value = 1}
  end

  self.rounds[9] = {mainType = 'enemy', subType = 'A11'}
  if math.random() > 0.5 then
    self.rounds[10] = {mainType = 'elite', subType = 'A1'}
    self.rounds[11] = {mainType = 'dealer', value = 2}
    self.rounds[12] = {mainType = 'enemy', subType = 'A11'}
    self.rounds[13] = {mainType = 'enemy', subType = 'B1'}
  else
    self.rounds[10] = {mainType = 'enemy', subType = 'A6'}
    self.rounds[11] = {mainType = 'enemy', subType = 'A6'}
    self.rounds[12] = {mainType = 'dealer', value = 1}
    self.rounds[13] = {mainType = 'elite', subType = 'A1'}
  end

  self.rounds[14] = {mainType = 'enemy', subType = 'B1'}
  self.rounds[15] = {mainType = 'enemy', subType = 'B6'}
  if math.random() > 0.5 then
    self.rounds[16] = {mainType = 'dealer', value = 2}
    self.rounds[17] = {mainType = 'enemy', subType = 'B6'}
  else
    self.rounds[16] = {mainType = 'enemy', subType = 'B6'}
    self.rounds[17] = {mainType = 'dealer', value = 1}
  end

  self.rounds[18] = {mainType = 'enemy', subType = 'B11'}
  if math.random() > 0.5 then
    self.rounds[19] = {mainType = 'elite', subType = 'B1'}
    self.rounds[20] = {mainType = 'dealer', value = 3}
    self.rounds[21] = {mainType = 'enemy', subType = 'B11'}
    self.rounds[22] = {mainType = 'enemy', subType = 'C1'}
  else
    self.rounds[19] = {mainType = 'enemy', subType = 'B6'}
    self.rounds[20] = {mainType = 'enemy', subType = 'B6'}
    self.rounds[21] = {mainType = 'dealer', value = 2}
    self.rounds[22] = {mainType = 'elite', subType = 'B1'}
  end

  self.rounds[23] = {mainType = 'enemy', subType = 'C1'}
  self.rounds[24] = {mainType = 'enemy', subType = 'C6'}
  self.rounds[25] = {mainType = 'enemy', subType = 'C6'}
  self.rounds[26] = {mainType = 'dealer', value = 3}
  self.rounds[27] = {mainType = 'enemy', subType = 'C11'}
  self.rounds[28] = {mainType = 'elite', subType = 'C1'}
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
    Hump.Gamestate.current():win()
  end

  table.remove(self.rounds, 1)

  if self.rounds[1].mainType == 'dealer' then
    Hump.Gamestate.current().guis[1]:onRoundStart()
  end
end

function Phase:switchNextRound()
  Hump.Gamestate.current().guis[1]:onRoundEnd()

  if self.rounds[1] == nil then
    Hump.Gamestate.current():win()
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