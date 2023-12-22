local Component = require 'src.components.component'

local Bullet = Class('Bullet', Component)

function Bullet:initialize(hero, enemyEntity, speed)
  Component.initialize(self)

  assert(hero ~= nil, 'Hero cannot be nil')
  self.hero = hero
  
  assert(enemyEntity ~= nil, 'Enemy entity cannot be nil')
  self.enemyTransform = enemyEntity:getComponent('Transform')
  self.enemy = enemyEntity:getComponent('Enemy')
  assert(self.enemyTransform and self.enemy, 'Invalid enemy entity')

  self.speed = speed or 800
  self.hitSqrtDist = (self.speed / 45) ^ 2

  self.trailPoints = {}

  -- self.angle = math.atan2(self.target.y - self.y, self.target.x - self.x)
end

return Bullet