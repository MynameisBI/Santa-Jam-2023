local Hero = require 'src.components.hero'
local HeroEntity = require 'src.entities.heroes.heroEntity'
local AllyStats = require 'src.type.allyStats'

local Entity = require 'src.entities.entity'

local Nathanael = Class('Nathanael', HeroEntity)

Nathanael.SKILL_DESCRIPTION = "Increase 0.25 AD + 0.05 RP attack damage for 6s"

function Nathanael:initialize(slot)
  Entity.initialize(self)

  HeroEntity.initialize(
    self, slot, Images.heroes.nathanael, 'Nathanael', 2, {'sentient', 'trailblazer', 'droneMaestro'},
    {
      [1] = Hero.Stats(50, 30, 2.3, 350, 0, 2, 0, 0, 0, 0),
      [2] = Hero.Stats(67, 40, 2.3, 350, 0, 2, 0, 0, 0, 0),
      [3] = Hero.Stats(89, 53, 2.3, 350, 0, 2, 0, 0, 0, 0),
      [4] = Hero.Stats(119, 71, 2.3, 350, 0, 2, 0, 0, 0, 0),
      [5] = Hero.Stats(158, 95, 2.3, 350, 0, 2, 0, 0, 0, 0),
      [6] = Hero.Stats(211, 126, 2.3, 350, 0, 2, 0, 0, 0, 0)
    },
    nil,
    Hero.Skill('Nathanael', 50, 12, function(hero)
      local stats = hero:getStats()
      local genericDamageStats = hero.class.Stats(
        stats.attackDamage * 0.25 + stats.realityPower * 0.05,
        0, 0, 0, 0, 0, 0, 0, 0, 0
      ) -- Imagine stacking mutiplicatively, couldn't be me
      genericDamageStats.isNathanaelBuff = true

      for i = #hero.temporaryModifierStatses, 1, -1 do
        if hero.temporaryModifierStatses[i].isNathanaelBuff then
          table.remove(hero.temporaryModifierStatses, i)
        end
      end
      hero:addTemporaryModifierStats(genericDamageStats, 6)
    end)
  )

  local animator = self:getComponent('Animator')
  animator:setGrid(18, 18, Images.heroes.nathanael:getWidth(), Images.heroes.nathanael:getHeight())
  animator:addAnimation('idle', {'1-2', 1}, 0.5, true)
  animator:addAnimation('attack', {'4-6', 1, 3, 1}, {0.05, 0.15, 0.05, 0.75}, true, function()
    animator:setCurrentAnimationName('idle') 
  end)
  animator:setCurrentAnimationName('idle')
end

return Nathanael