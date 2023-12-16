local SingletonComponent = require 'src.components.singletonComponent'

local CameraManager = SingletonComponent:subclass('CameraManager')

function CameraManager:initialize()
  SingletonComponent.initialize(self)
  self.cameras = {}
end

function CameraManager:addCamera(name, camera)
  self.cameras[name] = camera
end

function CameraManager:getCamera(name)
  assert(self.cameras[name], tostring(name)..' camera does not exist')
  return self.cameras[name]
end

-- Gamera wrapper
local Camera = Class('Camera')
CameraManager.static.Camera = Camera

function Camera:initialize(screenX, screenY, screenW, screenH, worldX, worldY)
  self._gamera = Gamera.new(-math.huge, -math.huge, math.huge, math.huge)

  local SWIDTH, SHEIGHT = love.graphics.getDimensions()
  self._gamera:setWindow(screenX or 0, screenY or 0, screenW or SWIDTH, screenH or SHEIGHT)
  self._gamera:setPosition(worldX or SWIDTH / 2, worldY or SHEIGHT / 2)

  self.layer = 'lol have not coded this yet'
end

function Camera:draw(worlddrawFunc)
  self._gamera:draw(worlddrawFunc)
end

function Camera:setScreenArea(screenX, screenY, screenW, screenH)
  self._gamera:setWindow(screenX, screenY, screenW, screenH)
end

function Camera:setWorldPosition(worldX, worldY)
  self._gamera:setPosition(worldX, worldY)
end

function Camera:toWorld(x, y)
  return self._gamera:toWorld(x, y)
end

function Camera:toScreen(x, y)
  return self._gamera:toScreen(x, y)
end

function Camera:getVisible()
  return self._gamera:getVisible()
end

return CameraManager