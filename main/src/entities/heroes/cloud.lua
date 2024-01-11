local Hero = require 'src.components.hero'
local HeroEntity = require 'src.entities.heroes.heroEntity'
local AreaSkillEntity = require 'src.entities.skills.areaSkillEntity'
local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'
local Animator = require 'src.components.animator'
local CloudBullet = require 'src.entities.bullets.cloudBullet'

local Entity = require 'src.entities.entity'

local Cloud = Class('Cloud', HeroEntity)

Cloud.SKILL_DESCRIPTION = "Create an explosion dealing 5.0 RP reality damage"

function Cloud:initialize(slot)
  Entity.initialize(self)

  HeroEntity.initialize(
    self, slot, Images.heroes.cloud, 'Cloud', 1, {'candyhead', 'cracker'},
    {
      [1] = Hero.Stats(35, 40, 0.9, 500, 0, 2, 0, 0, 0, 0),
      [1] = Hero.Stats(47, 53, 0.9, 500, 0, 2, 0, 0, 0, 0),
      [1] = Hero.Stats(62, 71, 0.9, 500, 0, 2, 0, 0, 0, 0),
      [1] = Hero.Stats(83, 95, 0.9, 500, 0, 2, 0, 0, 0, 0),
      [1] = Hero.Stats(111, 126, 0.9, 500, 0, 2, 0, 0, 0, 0),
      [1] = Hero.Stats(147, 169, 0.9, 500, 0, 2, 0, 0, 0, 0),
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