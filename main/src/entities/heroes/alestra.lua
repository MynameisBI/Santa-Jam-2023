
local Hero = require 'src.components.hero'
local HeroEntity = require 'src.entities.heroes.heroEntity'

local Entity = require 'src.entities.entity'

local Alestra = Class('Alestra', HeroEntity)

function Alestra:initialize(slot)
    Entity.initialize(self)

    HeroEntity.initialize(self, slot, Images.heroes.alestra, 'Alestra', {'sentient', 'coordinator'},
        {
            [1] = Hero.Stats(40, 30, 1.0, 300, 0, 0),
            [2] = Hero.Stats(60, 45, 1.0, 300, 0, 0),
            [3] = Hero.Stats(90, 68, 1.0, 300, 0, 0),
            [4] = Hero.Stats(135, 101, 1.0, 300, 0, 0)
        },
        Hero.Skill('Alestra',
            40, 8,
            function()
                print('machine guns!!!')
            end
        ))
        local animator = self:getComponent('Animator')
        animator:setGrid(18, 18, Images.heroes.alestra:getWidth(), Images.heroes.alestra:getHeight())
        animator:addAnimation('idle', {'1-2', 1}, 0.65, true)
        animator:addAnimation('attack', {'3-6', 1}, {0.5, 0.5, 0.5, 0.5}, true)
        animator:setCurrentAnimationName('idle')
end

return Alestra