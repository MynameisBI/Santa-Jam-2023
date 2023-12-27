local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'
local Area = require 'src.components.area'
local Projectile = require 'src.components.projectile'

local Entity = require 'src.entities.entity'

local ProjectileEntity = Class('ProjectileEntity', Entity)

function ProjectileEntity:initialize(hero, image, damageInfo, x, y, w, h, dirX, dirY, speed)
  Entity.initialize(self)

  self:addComponent(Transform(x, y, Lume.angle(0, 0, dirX, dirY), 2, 2))

  self:addComponent(Sprite(image, 14))

  self:addComponent(Area(w, h))

  self:addComponent(Projectile(hero, damageInfo, dirX, dirY, speed))
end

return ProjectileEntity