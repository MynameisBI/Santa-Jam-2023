
local Hero = require 'src.components.hero'
local HeroEntity = require 'src.entities.heroes.heroEntity'

local Entity = require 'src.entities.entity'

local Brunnos = Class('Brunnos', HeroEntity)

function Brunnos:initialize(slot)
    Entity.initialize(self)

    HeroEntity.initialize(self, slot, Images.heroes.brunnos, 'Brunnos', {'sentient', 'trailblazer'},
        {
            [1] = Hero.Stats(40, 30, 1.0, 300, 0, 0),
            [2] = Hero.Stats(60, 45, 1.0, 300, 0, 0),
            [3] = Hero.Stats(90, 68, 1.0, 300, 0, 0),
            [4] = Hero.Stats(135, 101, 1.0, 300, 0, 0)
        },
        Hero.Skill('Brunnos',
            40, 8,
            function()
                print('Attack the highest health enemy 8 times')
            end
        ))
        local animator = self:getComponent('Animator')
        animator:setGrid(18, 18, Images.heroes.brunnos:getWidth(), Images.heroes.brunnos:getHeight())
        animator:addAnimation('idle', {'1-2', 1}, 0.5, true)
        animator:addAnimation('attack', {'5-8', 1}, {1, 0.075, 0.075, 1}, true)
        animator:setCurrentAnimationName('idle')
end

return Brunnos