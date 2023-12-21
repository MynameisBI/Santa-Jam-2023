local System = require 'src.systems.system'

local ManageBullet = Class('ManageBullet', System)

function ManageBullet:initialize()
  System.initialize(self, 'Transform', 'Bullet')
end

function ManageBullet:update(transform, bullet, dt)
  local bx, by = transform:getGlobalPosition()
  local ex, ey = bullet.enemyTransform:getGlobalPosition()
  ex, ey = ex + 6, ey + 6
  local dirX, dirY = Lume.vector(Lume.angle(bx, by, ex, ey), 1)
  local distX, distY = dirX * bullet.speed * dt, dirY *  bullet.speed * dt
  local sqrtDistToEnemy = Lume.distance(bx, by, ex, ey, true)

  if sqrtDistToEnemy < 25 then
    print(tostring(bullet.enemy:getEntity())..' take '..tostring(bullet.hero:getBasicAttackDamage(bullet.enemy:getEntity()))..' damage')
    Hump.Gamestate.current():removeEntity(transform:getEntity())
  else
    transform:setGlobalPosition(bx + distX, by + distY)
  end
end

return ManageBullet