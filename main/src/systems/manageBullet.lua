local Entity = require 'src.entities.entity'
local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'

local System = require 'src.systems.system'

local ManageBullet = Class('ManageBullet', System)

function ManageBullet:initialize()
  System.initialize(self, 'Transform', 'Bullet')
end

function ManageBullet:update(transform, bullet, dt)
  local bx, by = transform:getGlobalPosition()
  local ex, ey = bullet.enemyTransform:getGlobalPosition()
  ex, ey = ex + 6, ey + 18
  local dirX, dirY = Lume.vector(Lume.angle(bx, by, ex, ey), 1)
  local distX, distY = dirX * bullet.speed * dt, dirY *  bullet.speed * dt
  local sqrtDistToEnemy = Lume.distance(bx, by, ex, ey, true)

  if sqrtDistToEnemy < bullet.hitSqrtDist then
    local stats = bullet.hero:getStats()
    bullet.enemy:takeDamage(bullet.hero:getBasicAttackDamage(bullet.enemy:getEntity()), 'physical',
        stats.physicalArmorIgnoreRatio)
    Hump.Gamestate.current():removeEntity(transform:getEntity())
  else
    transform:setGlobalPosition(bx + distX, by + distY)
  end

  transform.r = Lume.angle(bx, by, ex, ey)

  Hump.Gamestate.current():addEntity(Entity(
    Transform(bx, by, transform.r, 2, 2), 
    Sprite(Images.pets.alestraBullet, 14, 'fade', 7.5,
        function(sprite) Hump.Gamestate.current():removeEntity(sprite:getEntity()) end)
  ))
end

return ManageBullet