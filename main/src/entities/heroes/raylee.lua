local Hero = require 'src.components.hero'
local HeroEntity = require 'src.entities.heroes.heroEntity'
local AreaSkillEntity = require 'src.entities.skills.areaSkillEntity'
local EnemyEffect = require 'src.type.enemyEffect'
local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'
local Animator = require 'src.components.animator'
local Rectangle = require 'src.components.rectangle'
local RayleeBullet = require 'src.entities.bullets.rayleeBullet'

local Entity = require 'src.entities.entity'

local Raylee = Class('Raylee', HeroEntity)

Raylee.SKILL_DESCRIPTION = "Drop a note dealing 2.5 RP damage and reduce their reality armor by 50% for 3s"

function Raylee:initialize(slot)
  Entity.initialize(self)

  HeroEntity.initialize(self, slot, Images.heroes.raylee, 'Raylee', 1, {'bigEar', 'droneMaestro'},
    {
      [1] = Hero.Stats(40, 30, 1.0, 500, 0, 2),
      [2] = Hero.Stats(60, 45, 1.0, 500, 0, 2),
      [3] = Hero.Stats(90, 68, 1.0, 500, 0, 2),
      [4] = Hero.Stats(135, 101, 1.0, 460, 0, 2)
    },
    RayleeBullet,
    Hero.Skill('Raylee', 50, 8, function(hero, mx, my)
      Hump.Gamestate.current():addEntity(AreaSkillEntity(hero, {x = mx, y = my}, 200, 60,
          {damageType = 'reality', realityPowerRatio = 2.5, effects = {EnemyEffect('reduceRealityArmor', 3)}}, 0.42)) 

      local effectEntity = Entity()
      effectEntity:addComponent(Transform(mx - 100, my - 96, 0, 2, 2))
      effectEntity:addComponent(Sprite(Images.effects.rayleeSkill, 16))
      local animator = effectEntity:addComponent(Animator())
      animator:setGrid(100, 60, Images.effects.rayleeSkill:getDimensions())
      animator:addAnimation('default', {'1-10', 1}, 0.06, false,
          function() Hump.Gamestate.current():removeEntity(effectEntity) end)
      animator:setCurrentAnimationName('default')
      Hump.Gamestate.current():addEntity(effectEntity)
    end, true, 200, 60),
    2, -1
  )

  local animator = self:getComponent('Animator')
  animator:setGrid(18, 18, Images.heroes.raylee:getWidth(), Images.heroes.raylee:getHeight())
  animator:addAnimation('idle', {'1-2', 1}, 0.4, true)
  animator:addAnimation('attack', {'5-6', 1}, {0.2, 0.8}, true, function()
    animator:setCurrentAnimationName('idle') 
  end)
  animator:setCurrentAnimationName('idle')
end

return Raylee