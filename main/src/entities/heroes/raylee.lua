local Hero = require 'src.components.hero'
local HeroEntity = require 'src.entities.heroes.heroEntity'
local AreaSkillEntity = require 'src.entities.skills.areaSkillEntity'
local CurrentSkill = require 'src.components.skills.currentSkill'
local EnemyEffect = require 'src.type.enemyEffect'
local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'
local Animator = require 'src.components.animator'

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
      0, 0,
      function(hero, x, y)
        Hump.Gamestate.current():addEntity(AreaSkillEntity(hero, {x = x, y = y}, 200, 60,
            {damageType = 'reality', realityPowerRatio = 4, effects = {EnemyEffect('reduceRealityArmor', 3)}}, 0.42)) 

        local effectEntity = Entity()
        effectEntity:addComponent(Transform(x - 100, y - 96, 0, 2, 2))
        effectEntity:addComponent(Sprite(Images.effects.rayleeSkill, 16))
        local animator = effectEntity:addComponent(Animator())
        animator:setGrid(100, 60, Images.effects.rayleeSkill:getDimensions())
        animator:addAnimation('default', {'1-10', 1}, 0.06, false,
            function() Hump.Gamestate.current():removeEntity(effectEntity) end)
        animator:setCurrentAnimationName('default')
        Hump.Gamestate.current():addEntity(effectEntity)        
      end, true, 200, 60
    ))

  local animator = self:getComponent('Animator')
  animator:setGrid(18, 18, Images.heroes.raylee:getWidth(), Images.heroes.raylee:getHeight())
  animator:addAnimation('idle', {'1-2', 1}, 0.5, true)
  animator:addAnimation('attack', {'3-6', 1}, {1, 0.075, 0.075, 1}, true)
  animator:setCurrentAnimationName('idle')
end

return Raylee