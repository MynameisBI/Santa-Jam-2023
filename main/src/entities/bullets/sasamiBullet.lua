local BulletEntity = require 'src.entities.bullets.bulletEntity'

local SasamiBullet = Class('SasamiBullet', BulletEntity)

function SasamiBullet:initialize(x, y, hero, enemyEntity)
  BulletEntity.initialize(self, x + 20, y + 8, Images.pets.sasamiBullet, hero, enemyEntity, 800, 5)
end

return SasamiBullet