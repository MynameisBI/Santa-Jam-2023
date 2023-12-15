local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'
local Animator = require 'src.components.animator'
local Hero = require 'src.components.hero'

local Entity = require 'src.entities.entity'

local Cole = Class('Cole', Entity)

function Cole:initialize(x, y)
  Entity.initialize(self)

  self:addComponent(Transform(x, y, 0, 2, 2))

  self:addComponent(Sprite(Images.heroes.cole, 10))

  local animator = Animator()
  animator:setGrid(18, 18, Images.heroes.cole:getWidth(), Images.heroes.cole:getHeight())
  animator:addAnimation('idle', {'1-4', 1}, {1.4, 0.075, 0.075, 1}, true)
  animator:addAnimation('attack', {'7-8', 1}, 0.2, true)
  animator:setCurrentAnimationName('idle')
  self:addComponent(animator)

  local hero = Hero('Cole', {'bigEar', 'coordinator'},
      {
        [1] = Hero.Stats(40, 30, 1.0, 300, 0, 0),
        [2] = Hero.Stats(60, 45, 1.0, 300, 0, 0),
        [3] = Hero.Stats(90, 68, 1.0, 300, 0, 0),
        [4] = Hero.Stats(135, 101, 1.0, 300, 0, 0)
      },
      Hero.Skill('Cole shoots things',
        40, 8, 
        function()
          print('bam bam bam')
        end
      )
    )
  self:addComponent(hero)
end

return Cole