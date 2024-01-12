local BulletEntity = require 'src.entities.bullets.bulletEntity'

local CloudBullet = Class('CloudBullet', BulletEntity)

function CloudBullet:initialize(x, y, hero, enemyEntity)
  BulletEntity.initialize(self, x + 32, y + 12, Images.pets.cloudBullet, hero, enemyEntity, 800)
end

return CloudBullet