
local Hero = require 'src.components.hero'
local HeroEntity = require 'src.entities.heroes.heroEntity'

local Entity = require 'src.entities.entity'

local Skott = Class('Skott', HeroEntity)

function Skott:initialize(slot)
    Entity.initialize(self)

    HeroEntity.initialize(self, slot, Images.heroes["s'kott"], 'Skott', {'defect', 'artificer', 'cracker'},
        {
            [1] = Hero.Stats(40, 30, 1.0, 300, 0, 0),
            [2] = Hero.Stats(60, 45, 1.0, 300, 0, 0),
            [3] = Hero.Stats(90, 68, 1.0, 300, 0, 0),
            [4] = Hero.Stats(135, 101, 1.0, 300, 0, 0)
        },
        Hero.Skill('Skott',
            40, 8,
            function()
                print('machine guns!!!')
            end
        ))
        local animator = self:getComponent('Animator')
        animator:setGrid(18, 18, Images.heroes["s'kott"]:getWidth(), Images.heroes["s'kott"]:getHeight())
        animator:addAnimation('idle', {'1-2', 1}, {0.5, 0.5}, true)
        animator:addAnimation('attack', {'3-6', 1}, {0.075, 0.075, 0.075, 0.075}, true)
        animator:setCurrentAnimationName('idle')
end

return Skott