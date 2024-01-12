local BulletEntity = require 'src.entities.bullets.bulletEntity'

local ColeBullet = Class('ColeBullet', BulletEntity)

function ColeBullet:initialize(x, y, hero, enemyEntity)
  BulletEntity.initialize(self, x + 36, y + 16, Images.pets.coleBullet, hero, enemyEntity, 800, 25)
end

return ColeBullet