local Hero = require 'src.components.hero'
local HeroEntity = require 'src.entities.heroes.heroEntity'
local TargetSkillEntity = require 'src.entities.skills.targetSkillEntity'
local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'
local Timer = require 'src.components.timer'
local Animator = require 'src.components.animator'

local Entity = require 'src.entities.entity'

local Keon = Class('K\'eon', HeroEntity)

function Keon:initialize(slot)
  Entity.initialize(self)

  HeroEntity.initialize(
    self, slot, Images.heroes["k'eon"], 'K\'eon', 1, {'defect', 'droneMaestro'},
    {
        [1] = Hero.Stats(40, 30, 1.0, 300, 0, 0),
        [2] = Hero.Stats(60, 45, 1.0, 300, 0, 0),
        [3] = Hero.Stats(90, 68, 1.0, 300, 0, 0),
        [4] = Hero.Stats(135, 101, 1.0, 300, 0, 0)
    },
    nil,
    Hero.Skill('Keon', 30, 3, function(hero)
      if hero.skill.castCount == nil then hero.skill.castCount = 0 end
      hero.skill.castCount = hero.skill.castCount + 1
      
      local spawnColumn = function()
        local enemyEntities = Hump.Gamestate.current():getEntitiesWithComponent('Enemy')
        enemyEntities = Lume.shuffle(enemyEntities)
        for i = 1, math.min(#enemyEntities, 4) do
          local targetSkillEntity = Hump.Gamestate.current():addEntity(
            TargetSkillEntity(hero, enemyEntities[i],
                {damageType = 'reality', realityPowerRatio = 2.5}, 0.4)
          )
  
          local effectEntity = Entity()
          local x, y = targetSkillEntity:getComponent('Transform'):getGlobalPosition()
          local transform = effectEntity:addComponent(Transform(20, -170, 0, 2, 2, 10, 100))
          transform:setParent(enemyEntities[i]:getComponent('Transform'))
          effectEntity:addComponent(Sprite(Images.effects.keonColumn, 16))
          local animator = effectEntity:addComponent(Animator())
          animator:setGrid(16, 200, Images.effects.keonColumn:getDimensions())
          animator:addAnimation('default', {'1-6', 1}, 0.1, false,
              function() Hump.Gamestate.current():removeEntity(effectEntity) end)
          animator:setCurrentAnimationName('default')
          Hump.Gamestate.current():addEntity(effectEntity)
        end
      end
      spawnColumn()
      if hero.skill.castCount >= 3 then
        hero.skill.castCount = 0
        hero:getEntity():getComponent('Timer').timer:every(0.7, spawnColumn, 2)
      end
    end)
  )

  self:addComponent(Timer())

  local animator = self:getComponent('Animator')
  animator:setGrid(18, 18, Images.heroes["k'eon"]:getWidth(), Images.heroes["k'eon"]:getHeight())
  animator:addAnimation('idle', {'1-2', 1}, {0.5, 0.5}, true)
  animator:addAnimation('attack', {'3-7', 1}, {0.075, 0.075, 0.075, 0.075, 1}, true)
  animator:setCurrentAnimationName('idle')
end

return Keon