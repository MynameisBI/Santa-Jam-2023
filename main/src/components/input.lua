local CameraManager = require 'src.components.cameraManager'

local SingletonComponent = require 'src.components.singletonComponent'

local Input = SingletonComponent:subclass('Input')

function Input:initialize()
  SingletonComponent.initialize(self)
  self.cameraManager = CameraManager()
  self:clear()
end

function Input:clear()
  self.pressedScancodes = {}
  self.releasedScancodes = {}

  self.pressedMouseButtons = {}
  self.releasedMouseButtons = {}
end

function Input:isScancodePressed(scancode)
  return Lume.find(self.pressedScancodes, scancode) and true or false
end

function Input:isScancodeDown(scancode)
  return love.keyboard.isScancodeDown(scancode)
end

function Input:isScancodeReleased()
  return Lume.find(self.releasedScancodes, scancode) and true or false
end

function Input:isMouseButtonPressed(button)
  return Lume.find(self.pressedMouseButtons, button) and true or false
end

function Input:isMouseButtonDown(button)
  return love.mouse.isDown(button)
end

function Input:isMouseButtonReleased(button)
  return Lume.find(self.releasedMouseButtons, button) and true or false
end

function Input:getMouseScreenPosition()
  return love.mouse.getPosition()
end

function Input:getMouseWorldPosition(cameraName)
  cameraName = cameraName or 'main'
  local camera = self.cameraManager:getCamera(cameraName)
  local mx, my = love.mouse.getPosition()
  return camera:toWorld(mx, my)
end

return Input