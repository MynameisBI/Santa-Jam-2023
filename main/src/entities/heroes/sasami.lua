
local Hero = require 'src.components.hero'
local HeroEntity = require 'src.entities.heroes.heroEntity'

local Entity = require 'src.entities.entity'

local Sasami = Class('Sasami', HeroEntity)

function Sasami:initialize(slot)
    Entity.initialize(self)

    HeroEntity.initialize(self, slot, Images.heroes.sasami, 'Sasami', {'defect', 'coordinator'},
        {
            [1] = Hero.Stats(40, 30, 1.0, 300, 0, 0),
            [2] = Hero.Stats(60, 45, 1.0, 300, 0, 0),
            [3] = Hero.Stats(90, 68, 1.0, 300, 0, 0),
            [4] = Hero.Stats(135, 101, 1.0, 300, 0, 0)
        },
        nil,
        Hero.Skill('Sasami',
            40, 8,
            function()
                print('machine guns!!!')
            end
        ))
        local animator = self:getComponent('Animator')
        animator:setGrid(18, 18, Images.heroes.sasami:getWidth(), Images.heroes.sasami:getHeight())
        animator:addAnimation('idle', {'1-2', 1}, {0.5, 0.5}, true)
        animator:setCurrentAnimationName('idle')
end

return Sasami