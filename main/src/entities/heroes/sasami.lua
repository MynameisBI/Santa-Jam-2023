local Hero = require 'src.components.hero'
local HeroEntity = require 'src.entities.heroes.heroEntity'
local AreaSkillEntity = require 'src.entities.skills.areaSkillEntity'
local EnemyEffect = require 'src.type.enemyEffect'
local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'
local Rectangle = require 'src.components.rectangle'
local Timer = require 'src.components.timer'

local Entity = require 'src.entities.entity'

local Sasami = Class('Sasami', HeroEntity)

Sasami.SKILL_DESCRIPTION = "After a delay, obliterate an area dealing 8.0 RP reality damage. Enemies caught in the epicenter can be critically strike"

function Sasami:initialize(slot)
  Entity.initialize(self)

  HeroEntity.initialize(
    self, slot, Images.heroes.sasami, 'Sasami', 3, {'defect', 'coordinator'},
    {
      [1] = Hero.Stats(35, 65, 1.2, 500, 0, 2),
      [2] = Hero.Stats(47, 87, 1.2, 500, 0, 2),
      [3] = Hero.Stats(62, 116, 1.2, 500, 0, 2),
      [4] = Hero.Stats(83, 154, 1.2, 500, 0, 2),
      [5] = Hero.Stats(111, 205, 1.2, 500, 0, 2),
      [6] = Hero.Stats(147, 274, 1.2, 500, 0, 2),
    },
    nil,
    Hero.Skill('Sasami', 150, 12, function(hero, mx, my)
      Hump.Gamestate.current():addEntity(AreaSkillEntity(hero, {x = mx, y = my}, 240, 140,
          {damageType = 'reality', realityPowerRatio = 8}, 1.075, nil,
          {damageType = 'reality', realityPowerRatio = 8, canCrit = true}, 128, 76))

      local effectEntity = Entity()
      local transform = effectEntity:addComponent(Transform(mx,  my, 0, 440, 240, 220, 120))
      effectEntity:addComponent(Rectangle('line', {0.38, 0.73, 0.76, 0.2}, 4, 16))
      local timer = effectEntity:addComponent(Timer())
      timer.timer:tween(1, transform, {sx = 0, sy = 0, ox = 0, oy = 0}, 'linear', function()
        Hump.Gamestate.current():removeEntity(effectEntity)
      end)
      Hump.Gamestate.current():addEntity(effectEntity)

      local effectEntity = Entity()
      local transform = effectEntity:addComponent(Transform(mx, my, 0, 60, 450, 30, 448))
      local rectangle = effectEntity:addComponent(Rectangle('fill', {0.38, 0.73, 0.76, 0.05}, 4, 16, 2, 2))
      local timer = effectEntity:addComponent(Timer())
      timer.timer:tween(1, rectangle.color, {[4] = 0.25}, 'quad')
      timer.timer:tween(1, transform, {sx = 0, ox = 0}, 'quad', function()
        Hump.Gamestate.current():removeEntity(effectEntity)
      end)
      Hump.Gamestate.current():addEntity(effectEntity)

      local effectEntity = Entity()
      local transform = effectEntity:addComponent(Transform(mx - 64, my - 438, 0, 2, 2))
      local sprite = effectEntity:addComponent(Sprite(Images.effects.sasamiMark, 8))
      sprite:setColor('255', 59, 233, 251, 255)
      local timer = effectEntity:addComponent(Timer())
      timer.timer:after(1, function()
        timer.timer:tween(0.075, transform, {y = my - 38}, 'linear', function()
          local afterImpact = Entity()
          local aTransform = afterImpact:addComponent(Transform(mx, my, 0, 0, 0, 0))
          local aRectangle = afterImpact:addComponent(Rectangle('line', {0.38, 0.73, 0.76, 1}, 12, 6))
          local aTimer = afterImpact:addComponent(Timer())
          aTimer.timer:tween(0.1, aTransform, {sx = 240, sy = 130, ox = 120, oy = 65}, 'out-quad')
          aTimer.timer:tween(0.5, aRectangle.color, {[4] = 0}, 'linear')
          aTimer.timer:tween(0.5, aRectangle, {lineWidth = 2}, 'out-quad', function()
            Hump.Gamestate.current():removeEntity(afterImpact)
          end)
          Hump.Gamestate.current():addEntity(afterImpact)

          timer.timer:tween(5, sprite, {_alpha = 0}, 'linear', function()
            Hump.Gamestate.current():removeEntity(effectEntity)
          end)

          local afterMark = Entity()
          afterMark:addComponent(Transform(mx - 64, my - 38, 0, 2, 2))
          amSprite = afterMark:addComponent(Sprite(Images.effects.sasamiMark, 7, 'fade', 0.05))
          amSprite:setColor('default', 0.14, 0.19, 0.28, 1)
          Hump.Gamestate.current():addEntity(afterMark)
        end)
      end)
      Hump.Gamestate.current():addEntity(effectEntity)
    end, true, 240, 140, 128, 76)
  )

  local animator = self:getComponent('Animator')
  animator:setGrid(18, 18, Images.heroes.sasami:getWidth(), Images.heroes.sasami:getHeight())
  animator:addAnimation('idle', {'1-2', 1}, {0.5, 0.5}, true, function()
    animator:setCurrentAnimationName('idle') 
  end)
  animator:setCurrentAnimationName('idle')
end

return Sasami