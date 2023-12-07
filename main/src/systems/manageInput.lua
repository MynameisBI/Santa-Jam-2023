local System = require 'src.systems.system'

local ManageInput = System:subclass('ManageInput')

function ManageInput:initialize()
  System.initialize(self, 'Input')
end

function ManageInput:keypressed(input, key, scancode, isrepeat)
  table.insert(input.pressedScancodes, scancode)
end

function ManageInput:keyreleased(input, key, scancode)
  table.insert(input.releasedScancodes, scancode)
end

function ManageInput:mousepressed(input, x, y, button)
  table.insert(input.pressedMouseButtons, button)
end

function ManageInput:mousereleased(input, x, y, button)
  table.insert(input.releasedMouseButtons, button)
end

return ManageInput
