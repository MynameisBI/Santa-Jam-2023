local BulletEntity = require 'src.entities.bullets.bulletEntity'

local HakikoBullet = Class('HakikoBullet', BulletEntity)

function HakikoBullet:initialize(x, y, hero, enemyEntity)
  BulletEntity.initialize(self, x + 26, y + 20, Images.pets.hakikoBullet, hero, enemyEntity, 800, 15)
end

return HakikoBullet