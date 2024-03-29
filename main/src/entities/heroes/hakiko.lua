local Hero = require 'src.components.hero'
local HeroEntity = require 'src.entities.heroes.heroEntity'
local HakikoBullet = require 'src.entities.bullets.hakikoBullet'

local Entity = require 'src.entities.entity'

local Hakiko = Class('Hakiko', HeroEntity)

Hakiko.SKILL_DESCRIPTION = "Deal 2.4 RP reality damage and knock all enemies back"

function Hakiko:initialize(slot)
  Entity.initialize(self)

  HeroEntity.initialize(self, slot, Images.heroes.hakiko, 'Hakiko', 3, {'defect', 'droneMaestro'},
  {
    [1] = Hero.Stats(40, 60, 2.2, 500, 0, 2, 0, 0, 0, 0 ),
    [2] = Hero.Stats(53, 80, 2.2, 500, 0, 2, 0, 0, 0, 0),
    [3] = Hero.Stats(71, 107, 2.2, 500, 0, 2, 0, 0, 0, 0),
    [4] = Hero.Stats(95, 142, 2.2, 500, 0, 2, 0, 0, 0, 0),
    [5] = Hero.Stats(126, 190, 2.2, 500, 0, 2, 0, 0, 0, 0),
    [6] = Hero.Stats(169, 253, 2.2, 500, 0, 2, 0, 0, 0, 0),
  },
  HakikoBullet,
  Hero.Skill('Hakiko', 75, 6, function(hero)
    local stats = hero:getStats()
    local enemies = Hump.Gamestate.current():getComponents('Enemy')
    for _, enemy in ipairs(enemies) do
      enemy:takeDamage(stats.realityPower * 2.4, 'reality', stats.realityArmorIgnoreRatio, hero)
      enemy:knockBack(135)
    end
  end)
  )

  local animator = self:getComponent('Animator')
  animator:setGrid(18, 18, Images.heroes.hakiko:getWidth(), Images.heroes.hakiko:getHeight())
  animator:addAnimation('idle', {'1-2', 1}, 0.75, true)
  animator:addAnimation('attack', {'3-4', 1, 3, 1}, {0.075, 0.225, 0.7}, true, function()
  animator:setCurrentAnimationName('idle')
  end)
  animator:setCurrentAnimationName('idle')
end

return Hakiko