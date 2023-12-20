local Hero = require 'src.components.hero'
local HeroEntity = require 'src.entities.heroes.heroEntity'
local AreaSkillEntity = require 'src.entities.skills.areaSkillEntity'

local Entity = require 'src.entities.entity'

local Raylee = Class('Raylee', HeroEntity)

function Raylee:initialize(slot)
    Entity.initialize(self)

    HeroEntity.initialize(self, slot, Images.heroes.raylee, 'Raylee', {'bigEar', 'droneMaestro'},
        {
            [1] = Hero.Stats(40, 30, 1.0, 300, 0, 0),
            [2] = Hero.Stats(60, 45, 1.0, 300, 0, 0),
            [3] = Hero.Stats(90, 68, 1.0, 300, 0, 0),
            [4] = Hero.Stats(135, 101, 1.0, 300, 0, 0)
        },
        nil,
        Hero.Skill('Raylee',
            40, 8,
            function(hero)
              Hump.Gamestate.current():addEntity(
                AreaSkillEntity(Images.icons.candyheadIcon, hero, 450, 280, 300,
                    {damageType = 'reality', realityPowerRatio = 4}, 0.6)
              )
            end
        ))
        local animator = self:getComponent('Animator')
        animator:setGrid(18, 18, Images.heroes.raylee:getWidth(), Images.heroes.raylee:getHeight())
        animator:addAnimation('idle', {'1-2', 1}, 0.5, true)
        animator:addAnimation('attack', {'3-6', 1}, {1, 0.075, 0.075, 1}, true)
        animator:setCurrentAnimationName('idle')
end

return Raylee