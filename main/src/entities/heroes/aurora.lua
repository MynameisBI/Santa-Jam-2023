local Hero = require 'src.components.hero'
local HeroEntity = require 'src.entities.heroes.heroEntity'
local Resources = require 'src.components.resources'
local Transform = require 'src.components.transform'
local Rectangle = require 'src.components.rectangle'
local Timer = require 'src.components.timer'


local Entity = require 'src.entities.entity'

local Aurora = Class('Aurora', HeroEntity)

Aurora.SKILL_DESCRIPTION = "Regenerate 140 + 0.6 RP energy over 4s"

function Aurora:initialize(slot)
  Entity.initialize(self)

  HeroEntity.initialize(self, slot, Images.heroes.aurora, 'Aurora', 2, {'candyhead', 'droneMaestro'},
    {
      [1] = Hero.Stats(35, 50, 1, 425, 0, 2),
      [2] = Hero.Stats(47, 67, 1, 425, 0, 2),
      [3] = Hero.Stats(62, 89, 1, 425, 0, 2),
      [4] = Hero.Stats(83, 119, 1, 425, 0, 2),
      [5] = Hero.Stats(111, 158, 1, 425, 0, 2),
      [6] = Hero.Stats(147, 211, 1, 425, 0, 2),
    },
    nil,
    Hero.Skill('aurora', 80, 10, function(hero)
      local stats = hero:getStats()
      local resources = Resources()
      resources.secondsAuroraRegenLeft = 4
      resources.auroraRegenSpeed = (140 + stats.realityPower * 0.6) / 4

      local hx, hy = hero:getEntity():getComponent('Transform'):getGlobalPosition()
      for i = 1, 20 do
        local effect = Entity()
        local transform = effect:addComponent(
            Transform(hx + 18 + math.random(-12, 12), hy + 26 + math.random(-10, 10), math.pi/4, 14, 14, 5, 5))
        local rect = effect:addComponent(Rectangle('fill', {101/255, 200/255, 242/255, 0.4}, 1, 16))
        local timer = effect:addComponent(Timer())

        timer.timer:tween(5, rect.color, {[4] = 0}, 'linear')
        timer.timer:tween(
          5, transform,
          {x = hx + 18 + math.random(-66, 66), y = hy - 150 + math.random(-50, 50),
              sx = 6, sy = 6, ox = 1, oy = 1},
          'out-cubic',
          function()
            Hump.Gamestate.current():removeEntity(effect)
          end
        )
        Hump.Gamestate.current():addEntity(effect)
      end
    end)
  )
  local animator = self:getComponent('Animator')
  animator:setGrid(18, 18, Images.heroes.aurora:getWidth(), Images.heroes.aurora:getHeight())
  animator:addAnimation('idle', {'1-2', 1}, 0.65, true)
  animator:addAnimation('attack', {'3-10', 1}, {0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5}, true, function()
    animator:setCurrentAnimationName('idle') 
  end)
  animator:setCurrentAnimationName('idle')
end

return Aurora