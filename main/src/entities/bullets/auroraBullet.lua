local BulletEntity = require 'src.entities.bullets.bulletEntity'

local AuroraBullet = Class('AuroraBullet', BulletEntity)

function AuroraBullet:initialize(x, y, hero, enemyEntity)
  BulletEntity.initialize(self, x + 10, y + 18, Images.pets.auroraBullet, hero, enemyEntity, 650, 20)
end

return AuroraBullet