local Hero = require 'src.components.hero'
local HeroEntity = require 'src.entities.heroes.heroEntity'
local AllyStats = require 'src.type.allyStats'

local Entity = require 'src.entities.entity'

local Nathanael = Class('Nathanael', HeroEntity)

Nathanael.SKILL_DESCRIPTION = "Increase 0.2 AD + 0.05 RP attack damage for 4s"

function Nathanael:initialize(slot)
  Entity.initialize(self)

  HeroEntity.initialize(
    self, slot, Images.heroes.nathanael, 'Nathanael', 2, {'sentient', 'trailblazer', 'droneMaestro'},
    {
      [1] = Hero.Stats(40, 30, 1.0, 300, 0, 2),
      [2] = Hero.Stats(60, 45, 1.0, 300, 0, 2),
      [3] = Hero.Stats(90, 68, 1.0, 300, 0, 2),
      [4] = Hero.Stats(135, 101, 1.0, 300, 0, 2)
    },
    nil,
    Hero.Skill('Nathanael', 50, 12, function(hero)
      local stats = hero:getStats()
      local genericDamageStats = hero.class.Stats(
        stats.attackDamage * 0.2 + stats.realityPower * 0.05,
        0, 0, 0, 0, 0, 0, 0, 0, 0
      ) -- Imagine stacking mutiplicatively, couldn't be me
      genericDamageStats.isNathanaelBuff = true

      for i = #hero.temporaryModifierStatses, 1, -1 do
        if hero.temporaryModifierStatses[i].isNathanaelBuff then
          table.remove(hero.temporaryModifierStatses, i)
        end
      end
      hero:addTemporaryModifierStats(genericDamageStats, 4)
    end)
  )

  local animator = self:getComponent('Animator')
  animator:setGrid(18, 18, Images.heroes.nathanael:getWidth(), Images.heroes.nathanael:getHeight())
  animator:addAnimation('idle', {'1-2', 1}, 0.5, true)
  animator:addAnimation('attack', {'3-6', 1}, {1, 0.075, 0.075, 0.075}, true)
  animator:setCurrentAnimationName('idle')
end

return Nathanael