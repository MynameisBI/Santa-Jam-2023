local SingletonComponent = require 'src.components.singletonComponent'

local CurrentInspectable = Class('CurrentInspectable', SingletonComponent)

function CurrentInspectable:initialize()
  SingletonComponent.initialize(self)
  self.currentInspectable = nil
end

return CurrentInspectable