local Component = require 'src.components.component'

-- Quick and dirty singleton maker to be inherit
local SingletonComponent = Component:subclass('SingletonComponent')

function SingletonComponent.static:new(...)
  assert(type(self) == 'table', "Make sure that you are using 'Class:new' instead of 'Class.new'")
  if self.static._instance == nil then
    self.static._instance = self:allocate()
    self.static._instance:initialize(...)
  end
  return self.static._instance
end

function SingletonComponent:initialize()
  Component.initialize(self)
end

return SingletonComponent