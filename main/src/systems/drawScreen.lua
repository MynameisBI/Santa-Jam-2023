local System = require 'src.systems.system'

local DrawScreen = System:subclass('DrawScreen')

function DrawScreen:initialize()
  System.initialize(self, 'CameraManager')
end

function DrawScreen:screendraw(cameraManager, worlddrawFunc)
  for cameraName, camera in pairs(cameraManager.cameras) do
    camera:draw(worlddrawFunc)
  end
end

return DrawScreen