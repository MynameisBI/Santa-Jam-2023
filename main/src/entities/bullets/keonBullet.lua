local BulletEntity = require 'src.entities.bullets.bulletEntity'

local KeonBullet = Class('K\'eonBullet', BulletEntity)

function KeonBullet:initialize(x, y, hero, enemyEntity)
  BulletEntity.initialize(self, x + 2, y + 6, Images.pets['k\'eonBullet'], hero, enemyEntity, 600, 6.5)
end

return KeonBullet