local Hero = require 'src.components.hero'
local HeroEntity = require 'src.entities.heroes.heroEntity'
local ColeBullet = require 'src.entities.bullets.coleBullet'
local TargetSkillEntity = require 'src.entities.skills.targetSkillEntity'
local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'
local Timer = require 'src.components.timer'

local Entity = require 'src.entities.entity'

local Cole = Class('Cole', HeroEntity)

function Cole:initialize(slot)
    Entity.initialize(self)

    HeroEntity.initialize(self, slot, Images.heroes.cole, 'Cole', 1, {'bigEar', 'coordinator'},
        {
            [1] = Hero.Stats(40, 30, 1.0, 600, 0, 2),
            [2] = Hero.Stats(60, 45, 1.0, 600, 0, 2),
            [3] = Hero.Stats(90, 68, 1.0, 600, 0, 2),
            [4] = Hero.Stats(135, 101, 1.0, 600, 0, 2)
        },
        ColeBullet,
        Hero.Skill('Cole',
            40, 8,
            function(hero, mx, my)
              local enemyEntities = Hump.Gamestate.current():getEntitiesWithComponent('Enemy')
              enemyEntities = Lume.shuffle(enemyEntities)
              local stats = hero:getStats()
              for i = 1, math.min(#enemyEntities, 8) do
                local targetSkillEntity = Hump.Gamestate.current():addEntity(
                  TargetSkillEntity(hero, enemyEntities[i],
                      {damageType = 'true', attackDamageRatio = 1, canCrit = true}, 1 / stats.attackSpeed)
                )

                local effectEntity = Entity()
                local transform = effectEntity:addComponent(Transform(18, 18, 0, 6, 6,
                    Images.effects.coleAim:getWidth()/2, Images.effects.coleAim:getHeight()/2))
                local sprite = effectEntity:addComponent(Sprite(Images.effects.coleAim, 16))
                sprite:setColor('default', 1, 1, 1, 0)
                local timerComponent = effectEntity:addComponent(Timer())
                timerComponent.timer:after(1 / stats.attackSpeed,
                    function() Hump.Gamestate.current():removeEntity(effectEntity) end)
                effectEntity:getComponent('Transform'):setParent(targetSkillEntity:getComponent('Transform'))
                timerComponent.timer:tween(0.5 / stats.attackSpeed, transform, {sx = 2, sy = 2}, 'quad')
                timerComponent.timer:tween(0.5 / stats.attackSpeed, sprite, {_alpha = 1}, 'quad')
                Hump.Gamestate.current():addEntity(effectEntity)
              end
            end
        ))
        local animator = self:getComponent('Animator')
        animator:setGrid(18, 18, Images.heroes.cole:getWidth(), Images.heroes.cole:getHeight())
        animator:addAnimation('idle', {'1-4', 1}, {1.4, 0.075, 0.075, 1}, true)
        animator:addAnimation('attack', {'8-7', 1}, {0.2, 0.8}, true, function()
          animator:setCurrentAnimationName('idle') 
        end)
        animator:setCurrentAnimationName('idle')
end

return Cole