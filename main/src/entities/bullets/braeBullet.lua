local BulletEntity = require 'src.entities.bullets.bulletEntity'

local BraeBullet = Class('BraeBullet', BulletEntity)

function BraeBullet:initialize(x, y, hero, enemyEntity) 
  BulletEntity.initialize(self, x + 36, y + 14, Images.pets.braeBullet, hero, enemyEntity, 750, 10)
end

return BraeBullet