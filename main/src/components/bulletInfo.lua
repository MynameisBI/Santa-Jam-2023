local Component = require 'src.components.component'

local BulletInfo = Component:subclass('BulletInfo')

function BulletInfo:initialize(speed, target)
    Component.initialize(self)

    self.speed = speed
    self.target = target
end

