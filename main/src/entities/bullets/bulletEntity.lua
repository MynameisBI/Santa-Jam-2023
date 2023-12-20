local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'
local Bullet = require 'src.components.bullet'

local Entity = require 'src.entities.entity'

local BulletEntity = Class('BulletEntity', Entity)

function BulletEntity:initialize(x, y, image, hero, enemyEntity, speed)
  Entity.initialize(self)

  self:addComponent(Transform(x, y, 0, 2, 2))

  self:addComponent(Sprite(image, 14))

  self:addComponent(Bullet(hero, enemyEntity, speed))
end

return BulletEntity