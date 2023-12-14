local System = require 'src.systems.system'

local ManageBullet = System:subclass('ManageBullet')

function ManageBullet:initialize()
    System.initialize(self, 'Transform', 'Sprite', 'Bullet')
end

function ManageBullet:update()
end

return ManageBullet