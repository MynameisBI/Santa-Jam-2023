local SingletonComponent = require 'src.components.singletonComponent'

local DragAndDropInfo = Class('DragAndDropInfo', SingletonComponent)

function DragAndDropInfo:initialize()
  SingletonComponent.initialize(self)
  self.draggable = nil
  self.oldSlot = nil
end

return DragAndDropInfo