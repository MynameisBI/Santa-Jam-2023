
local Hero = require 'src.components.hero'
local HeroEntity = require 'src.entities.heroes.heroEntity'

local Entity = require 'src.entities.entity'

local Hakiko = Class('Hakiko', HeroEntity)

function Hakiko:initialize(slot)
  Entity.initialize(self)

  HeroEntity.initialize(self, slot, Images.heroes.hakiko, 'Hakiko', 3, {'defect', 'droneMaestro'},
  {
    [1] = Hero.Stats(40, 30, 1.0, 300, 0, 2),
    [2] = Hero.Stats(60, 45, 1.0, 300, 0, 2),
    [3] = Hero.Stats(90, 68, 1.0, 300, 0, 2),
    [4] = Hero.Stats(135, 101, 1.0, 300, 0, 2)
  },
  nil,
  Hero.Skill('Hakiko', 60, 8, function(hero)
    local stats = hero:getStats()
    local enemies = Hump.Gamestate.current():getComponents('Enemy')
    for _, enemy in ipairs(enemies) do
      enemy:takeDamage(stats.realityPower * 2.4, 'reality', stats.realityArmorIgnoreRatio, hero)
      enemy:knockBack(150)
    end
  end)
  )

  local animator = self:getComponent('Animator')
  animator:setGrid(18, 18, Images.heroes.hakiko:getWidth(), Images.heroes.hakiko:getHeight())
  animator:addAnimation('idle', {'1-2', 1}, 0.5, true)
  animator:addAnimation('attack', {'3-4', 1}, 0.075, true)
  animator:setCurrentAnimationName('idle')
end

return Hakiko