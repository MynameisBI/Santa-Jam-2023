local Hero = require 'src.components.hero'
local HeroEntity = require 'src.entities.heroes.heroEntity'
local EnemyEffect = require 'src.type.enemyEffect'
local Transform = require 'src.components.transform'
local Rectangle = require 'src.components.rectangle'
local Timer = require 'src.components.timer'

local Entity = require 'src.entities.entity'

local Soniya = Class('Soniya', HeroEntity)

function Soniya:initialize(slot)
  Entity.initialize(self)

  HeroEntity.initialize(
    self, slot, Images.heroes.soniya, 'Soniya', 2, {'sentient', 'cracker'},
    {
        [1] = Hero.Stats(40, 30, 1.0, 300, 0, 0),
        [2] = Hero.Stats(60, 45, 1.0, 300, 0, 0),
        [3] = Hero.Stats(90, 68, 1.0, 300, 0, 0),
        [4] = Hero.Stats(135, 101, 1.0, 300, 0, 0)
    },
    nil,
    Hero.Skill('Soniya', 150, 12, function(hero)
      local stats = hero:getStats()
      local enemies = Hump.Gamestate.current():getComponents('Enemy')
      for _, enemy in ipairs(enemies) do
        enemy:takeDamage(stats.realityPower * 2.5, 'reality', stats.realityArmorIgnoreRatio)
        enemy:applyEffect(EnemyEffect('slow', 1, 0.3))
      end

      local effect = Entity()
      local transform = effect:addComponent(Transform(589, 292, math.pi/4, 0, 0, 0, 0))
      local rect = effect:addComponent(Rectangle('line', {1, 1, 1, 0.2}, 12, 16))
      local timer = effect:addComponent(Timer())

      timer.timer:tween(0.4, rect.color, {[4] = 0}, 'cubic')
      timer.timer:tween(0.4, rect, {lineWidth = 0}, 'cubic')
      timer.timer:tween(0.4, transform, {sx = 480, sy = 480, ox = 240, oy = 240}, 'out-quart', function()
        Hump.Gamestate.current():removeEntity(effect)
      end)
      Hump.Gamestate.current():addEntity(effect)

      timer.timer:after(0.05, function()
        local effect = Entity()
        local transform = effect:addComponent(Transform(589, 292, math.pi/4, 0, 0, 0, 0))
        local rect = effect:addComponent(Rectangle('line', {0.87, 0.61, 0.97, 0.9}, 4, 16))
        local timer = effect:addComponent(Timer())

        timer.timer:tween(0.55, rect.color, {[4] = 0}, 'cubic')
        timer.timer:tween(0.55, transform, {sx = 400, sy = 400, ox = 200, oy = 200}, 'out-quart', function()
          Hump.Gamestate.current():removeEntity(effect)
        end)
        Hump.Gamestate.current():addEntity(effect)
      end)
    end)
  )
  local animator = self:getComponent('Animator')
  animator:setGrid(18, 18, Images.heroes.soniya:getWidth(), Images.heroes.soniya:getHeight())
  animator:addAnimation('idle', {'1-2', 1}, 0.5, true)
  animator:addAnimation('attack', {'3-5', 1}, {0.075, 0.075, 0.075}, true)
  animator:setCurrentAnimationName('idle')
end

return Soniya