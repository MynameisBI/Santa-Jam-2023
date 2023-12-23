local SingletonComponent = require 'src.components.singletonComponent'

local CurrentSkill = Class('CurrentSkill', SingletonComponent)

function CurrentSkill:initialize()
  SingletonComponent.initialize(self)
  self.currentSkill = nil
end

return CurrentSkill