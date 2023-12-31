local Hero = require 'src.components.hero'
local HeroEntity = require 'src.entities.heroes.heroEntity'
local AreaSkillEntity = require 'src.entities.skills.areaSkillEntity'
local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'
local Animator = require 'src.components.animator'
local CloudBullet = require 'src.entities.bullets.cloudBullet'

local Entity = require 'src.entities.entity'

local Cloud = Class('Cloud', HeroEntity)

function Cloud:initialize(slot)
  Entity.initialize(self)

  HeroEntity.initialize(
    self, slot, Images.heroes.cloud, 'Cloud', 1, {'candyhead', 'cracker'},
    {
      [1] = Hero.Stats(40, 30, 1.0, 550, 0, 2),
      [2] = Hero.Stats(60, 45, 1.0, 550, 0, 2),
      [3] = Hero.Stats(90, 68, 1.0, 550, 0, 2),
      [4] = Hero.Stats(135, 101, 1.0, 300, 0, 2)
    },
    CloudBullet,
    Hero.Skill('Cloud', 50, 5, function(hero, mx, my)
      Hump.Gamestate.current():addEntity(AreaSkillEntity(hero, {x = mx, y = my}, 150, 40,
          {damageType = 'reality', realityPowerRatio = 5}, 0.1)) 

      local effectEntity = Entity()
      effectEntity:addComponent(Transform(mx - 52, my - 60, 0, 2, 2))
      effectEntity:addComponent(Sprite(Images.effects.cloudExplosion, 16))
      local animator = effectEntity:addComponent(Animator())
      animator:setGrid(52, 38, Images.effects.cloudExplosion:getDimensions())
      animator:addAnimation('default', {'1-5', 1}, 0.075, false,
          function() Hump.Gamestate.current():removeEntity(effectEntity) end)
      animator:setCurrentAnimationName('default')
      Hump.Gamestate.current():addEntity(effectEntity)
    end, true, 150, 40),
    3, 0
  )

  local animator = self:getComponent('Animator')
  animator:setGrid(18, 18, Images.heroes.cloud:getWidth(), Images.heroes.cloud:getHeight())
  animator:addAnimation('idle', {'1-2', 1}, 0.5, true)
  animator:addAnimation('attack', {'6-5', 1}, {0.3, 0.7}, true, function()
    animator:setCurrentAnimationName('idle') 
  end)
  animator:setCurrentAnimationName('idle')
end

return Cloud