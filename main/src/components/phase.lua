local SingletonComponent = require 'src.components.singletonComponent'

local Phase = Class('Phase', SingletonComponent)

function Phase:initialize()
  SingletonComponent.initialize(self)

  self._currentPhase = 'planning'
end

function Phase:switch(phase)
  assert(phase == 'planning' or phase == 'battle', 'Invalid phase switch')
  self._currentPhase = phase
end

function Phase:current()
  return self._currentPhase 
end

return Phase