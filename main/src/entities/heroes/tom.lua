
local Hero = require 'src.components.hero'
local HeroEntity = require 'src.entities.heroes.heroEntity'

local Entity = require 'src.entities.entity'

local Tom = Class('Tom', HeroEntity)

function Tom:initialize(slot)
    Entity.initialize(self)

    HeroEntity.initialize(self, slot, Images.heroes.tom, 'Tom', {'bigEar', 'droneMaestro'},
        {
            [1] = Hero.Stats(40, 30, 1.0, 300, 0, 0),
            [2] = Hero.Stats(60, 45, 1.0, 300, 0, 0),
            [3] = Hero.Stats(90, 68, 1.0, 300, 0, 0),
            [4] = Hero.Stats(135, 101, 1.0, 300, 0, 0)
        },
        nil,
        Hero.Skill('Tom',
            40, 8,
            function()
                print('machine guns!!!')
            end
        ))
        local animator = self:getComponent('Animator')
        animator:setGrid(18, 18, Images.heroes.tom:getWidth(), Images.heroes.tom:getHeight())
        animator:addAnimation('idle', {'1-2', 1}, 0.8, true)
        animator:addAnimation('attack', {'3-7', 1}, {1.4, 0.075, 0.075, 0.075, 1}, true)
        animator:setCurrentAnimationName('idle')
end

return Tom