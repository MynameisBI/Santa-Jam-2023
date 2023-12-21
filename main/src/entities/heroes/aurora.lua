
local Hero = require 'src.components.hero'
local HeroEntity = require 'src.entities.heroes.heroEntity'

local Entity = require 'src.entities.entity'

local Aurora = Class('Aurora', HeroEntity)

function Aurora:initialize(slot)
  Entity.initialize(self)

  HeroEntity.initialize(self, slot, Images.heroes.aurora, 'Aurora', {'candyhead', 'droneMaestro'},
    {
      [1] = Hero.Stats(40, 30, 1.0, 300, 0, 0),
      [2] = Hero.Stats(60, 45, 1.0, 300, 0, 0),
      [3] = Hero.Stats(90, 68, 1.0, 300, 0, 0),
      [4] = Hero.Stats(135, 101, 1.0, 300, 0, 0)
    },
    nil,
    Hero.Skill('aurora',
      40, 8,
      function()
        print('slowww')
      end
    )
  )
  local animator = self:getComponent('Animator')
  animator:setGrid(18, 18, Images.heroes.aurora:getWidth(), Images.heroes.aurora:getHeight())
  animator:addAnimation('idle', {'1-2', 1}, 0.65, true)
  animator:addAnimation('attack', {'3-10', 1}, {0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5}, true)
  animator:setCurrentAnimationName('idle')
end

return Aurora