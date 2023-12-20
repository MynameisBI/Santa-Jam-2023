local Hero = require 'src.components.hero'
local HeroEntity = require 'src.entities.heroes.heroEntity'
local BulletEntity = require 'src.entities.bullets.bulletEntity'
local TargetSkillEntity = require 'src.entities.skills.targetSkillEntity'

local Entity = require 'src.entities.entity'

local Cole = Class('Cole', HeroEntity)

function Cole:initialize(slot)
    Entity.initialize(self)

    HeroEntity.initialize(self, slot, Images.heroes.cole, 'Cole', {'bigEar', 'coordinator'},
        {
            [1] = Hero.Stats(40, 30, 1.0, 500, 0, 0),
            [2] = Hero.Stats(60, 45, 1.0, 500, 0, 0),
            [3] = Hero.Stats(90, 68, 1.0, 500, 0, 0),
            [4] = Hero.Stats(135, 101, 1.0, 500, 0, 0)
        },
        BulletEntity,
        Hero.Skill('Cole',
            40, 8,
            function(hero)
                local enemyEntities = Hump.Gamestate.current():getEntitiesWithComponent('Enemy')
                enemyEntities = Lume.shuffle(enemyEntities)
                for i = 1, math.min(#enemyEntities, 8) do
                  Hump.Gamestate.current():addEntity(
                    TargetSkillEntity(Images.icons.candyheadIcon, hero, enemyEntities[i],
                        {damageType = 'true', attackDamageRatio = 1, canCrit = true}, 0.6)
                  )
                end
            end
        ))
        local animator = self:getComponent('Animator')
        animator:setGrid(18, 18, Images.heroes.cole:getWidth(), Images.heroes.cole:getHeight())
        animator:addAnimation('idle', {'1-4', 1}, {1.4, 0.075, 0.075, 1}, true)
        animator:addAnimation('attack', {'7-8', 1}, 0.2, true)
        animator:setCurrentAnimationName('idle')
end

return Cole