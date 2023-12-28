local Entity = require 'src.entities.entity'
local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'
local AudioManager = require 'src.components.audioManager'

local System = require 'src.systems.system'

local ManageBullet = Class('ManageBullet', System)

function ManageBullet:initialize()
  System.initialize(self, 'Transform', 'Sprite', 'Bullet')
end

function ManageBullet:update(transform, sprite, bullet, dt)
  local bx, by = transform:getGlobalPosition()
  local ex, ey = bullet.enemyTransform:getGlobalPosition()
  ex, ey = ex + 6, ey + 18
  local dirX, dirY = Lume.vector(Lume.angle(bx, by, ex, ey), 1)
  local distX, distY = dirX * bullet.speed * dt, dirY *  bullet.speed * dt
  local sqrtDistToEnemy = Lume.distance(bx, by, ex, ey, true)

  if sqrtDistToEnemy < bullet.hitSqrtDist then
    local stats = bullet.damageSource:getStats()
    bullet.enemy:takeDamage(bullet.damageSource:getBasicAttackDamage(bullet.enemy:getEntity()), 'physical',
        stats.physicalArmorIgnoreRatio)
    Hump.Gamestate.current():removeEntity(transform:getEntity())
    AudioManager:playSound('shoot', 0.4)
  else
    transform:setGlobalPosition(bx + distX, by + distY)
  end

  transform.r = Lume.angle(bx, by, ex, ey)

  if bullet.fadeSpeed then
    Hump.Gamestate.current():addEntity(Entity(
    Transform(bx, by, transform.r, 2, 2),
    Sprite(sprite.image, 14, 'fade', bullet.fadeSpeed,
        function(sprite) Hump.Gamestate.current():removeEntity(sprite:getEntity()) end)
  ))
  end
end

return ManageBullet