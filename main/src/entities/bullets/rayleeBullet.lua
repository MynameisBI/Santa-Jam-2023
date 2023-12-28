local BulletEntity = require 'src.entities.bullets.bulletEntity'

local RayleeBullet = Class('RayleeBullet', BulletEntity)

function RayleeBullet:initialize(x, y, hero, enemyEntity)
  BulletEntity.initialize(self, x + 30, y + 14, Images.pets.rayleeBullet, hero, enemyEntity, 800, 20)
end

return RayleeBullet