local System = require 'src.systems.system'
local Hero = require 'src.systems.hero'

local Bullet = System:subclass('Bullet')

function Bullet:initialize(x, y, thisPlayer, thisEnemy)
    System.initialize(self, 'Transform', 'Sprite')
    
    self.Transform:setPosition(x, y)
    self.speed = 100
    self.player = thisPlayer
    self.target = thisEnemy
end

function Bullet:update(dt)
    if (self.x - self.target.x)^2 + (self.y - self.target.y)^2 < 4 then
        self:destroy()
    else
        local angle = math.atan2(self.target.y - self.y, self.target.x - self.x)
        local dx = self.speed * math.cos(angle)
        local dy = self.speed * math.sin(angle)
        self.x = self.x + dx * dt
        self.y = self.y + dy * dt
    end
end

function Bullet:destroy()
    for i = 1, #hero.bullets do
        if hero.bullets[i] == self then
            table.remove(self.hero.bullets, i)
            break
        end
    end
end
