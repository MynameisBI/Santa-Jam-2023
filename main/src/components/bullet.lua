local Component = require 'src.components.component'

local Bullet = Class('Bullet', Component)

function Bullet:initialize(source, target, speed)
    Component.initialize(self)

    self.x = 10
    self.y = 10
    self.hero = source
    self.target = {x = 1, y = 1}
    self.speed = speed

    self.angle = math.atan2(self.target.y - self.y, self.target.x - self.x)
end



function Bullet:draw()
    love.graphics.setColor(0, 1, 1)
    love.graphics.circle('fill', self.x, self.y, 8)
    print('draw bullet')
end

return Bullet