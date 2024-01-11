local BulletEntity = require 'src.entities.bullets.bulletEntity'

local SoniyaBullet = Class('SoniyaBullet', BulletEntity)

function SoniyaBullet:initialize(x, y, hero, enemyEntity)
  BulletEntity.initialize(self, x + 4, y + 10, Images.pets.soniyaBullet, hero, enemyEntity, 600, 25)
end

return SoniyaBullet