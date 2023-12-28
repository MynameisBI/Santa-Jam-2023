local Component = require 'src.components.component'

local Bullet = Class('Bullet', Component)

function Bullet:initialize(damageSource, enemyEntity, speed, fadeSpeed)
  Component.initialize(self)

  assert(damageSource ~= nil, 'Damage source cannot be nil')
  self.damageSource = damageSource

  assert(type(damageSource.getStats) == 'function' and type(damageSource.getBasicAttackDamage) == 'function',
      'Damage source missing <getStats> or <getBasicAttackDamage> function')
  
  assert(enemyEntity ~= nil, 'Enemy entity cannot be nil')
  self.enemyTransform = enemyEntity:getComponent('Transform')
  self.enemy = enemyEntity:getComponent('Enemy')
  assert(self.enemyTransform and self.enemy, 'Invalid enemy entity')

  self.speed = speed or 800
  self.hitSqrtDist = ((self.speed / 40) * (60 / love.timer.getFPS())) ^ 2

  self.fadeSpeed = fadeSpeed
end

return Bullet