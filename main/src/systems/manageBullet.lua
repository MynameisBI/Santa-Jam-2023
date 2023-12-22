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
    print(tostring(bullet.enemy:getEntity())..' take '..tostring(bullet.hero:getBasicAttackDamage(bullet.enemy:getEntity()))..' damage')
    bullet.enemy:takeDamage(bullet.hero:getBasicAttackDamage(bullet.enemy:getEntity()))
    Hump.Gamestate.current():removeEntity(transform:getEntity())
  else
    transform:setGlobalPosition(bx + distX, by + distY)
  end

  transform.r = Lume.angle(bx, by, ex, ey)

  -- for i = 1, #bullet.trailPoints do
  --   bullet.trailPoints[i].existTime = bullet.trailPoints[i].existTime + dt
  -- end
  -- table.insert(bullet.trailPoints, {x = bx, y = by, existTime = 0})
end

function ManageBullet:worlddraw(transform, bullet)
  -- Deep.queue(14, function()
  --   for i = 1, #bullet.trailPoints-1 do
  --     local x1, y1, x2, y2, x3, y3, x4, y4
  --     x1, y1 = bullet.trailPoints[i].x, bullet.trailPoints[i].y
  --     x4, y4 = bullet.trailPoints[i+1].x, bullet.trailPoints[i+1].y
  --     local ox, oy = Lume.vector(Lume.angle(x1, y1, x4, y4) + math.pi/4, 4)
  --     x2, y2 = x1 + ox, y1 + oy
  --     x3, y3 = x4 + ox, y4 + oy
  --     love.graphics.setColor(1, 1, 1)
  --     love.graphics.polygon('fill', x1, y1, x2, y2, x3, y3, x4, y4)
  --   end
  -- end)
end

return ManageBullet