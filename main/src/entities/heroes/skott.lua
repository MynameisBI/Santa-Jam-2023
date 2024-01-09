local Hero = require 'src.components.hero'
local HeroEntity = require 'src.entities.heroes.heroEntity'
local EnemyEffect = require 'src.type.enemyEffect'

local Skott = Class('S\'kott', HeroEntity)

Skott.SKILL_DESCRIPTION = "Mark all enemies for 3s. Ally attacks and abilities detonate the mark dealing 3.0 RP damage, stun them for 0.25s and regenerate 10 + 0.05 RP energy"

function Skott:initialize(slot)
  HeroEntity.initialize(
    self, slot, Images.heroes["s'kott"], 'S\'kott', 4, {'defect', 'artificer', 'cracker'},
    {
      [1] = Hero.Stats(40, 30, 1.0, 300, 0, 2),
      [2] = Hero.Stats(60, 45, 1.0, 300, 0, 2),
      [3] = Hero.Stats(90, 68, 1.0, 300, 0, 2),
      [4] = Hero.Stats(135, 101, 1.0, 300, 0, 2)
    },
    nil,
    Hero.Skill('Skott', 100, 15, function(hero)
      local stats = hero:getStats()

      local enemies = Hump.Gamestate.current():getComponents('Enemy')
      for _, enemy in ipairs(enemies) do
        enemy:applyEffect(EnemyEffect('skottMark', 3,
            stats.realityPower * 3, 'reality', 0, 0.25, 10 + stats.realityPower * 0.05))
      end
    end)
  )

  local animator = self:getComponent('Animator')
  animator:setGrid(18, 18, Images.heroes["s'kott"]:getWidth(), Images.heroes["s'kott"]:getHeight())
  animator:addAnimation('idle', {'1-2', 1}, {0.5, 0.5}, true)
  animator:addAnimation('attack', {'3-6', 1}, {0.075, 0.075, 0.075, 0.075}, true)
  animator:setCurrentAnimationName('idle')
end

return Skott