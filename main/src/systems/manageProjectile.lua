local System = require 'src.systems.system'

local ManageProjectile = Class('ManageProjectile', System)

function ManageProjectile:initialize()
  System.initialize(self, 'Transform', 'Area', 'Projectile')
end

function ManageProjectile:update(transform, area, projectile, dt)
  projectile.secondsUntilDisappear = projectile.secondsUntilDisappear - dt
  if projectile.secondsUntilDisappear <= 0 then
    Hump.Gamestate.current():removeEntity(transform:getEntity())
    return
  end

  local x, y = transform:getGlobalPosition()
  local w, h = area:getSize()

  transform:setGlobalPosition(x + projectile.dirX * projectile.speed * dt, y + projectile.dirY * projectile.speed * dt)

  local enemyEntities = Hump.Gamestate.current():getEntitiesWithComponent('Enemy')
  enemyEntities = Lume.filter(enemyEntities, function(enemyEntity)
    local ex, ey = enemyEntity:getComponent('Transform'):getGlobalPosition()
    local ew, eh = enemyEntity:getComponent('Area'):getSize()
    return x < ex + ew and x + w > ex and y < ey + eh and y + h > ey
  end)

  for _, enemyEntity in ipairs(enemyEntities) do
    local damageInfo = projectile.damageInfo
    local damage = projectile.hero:getDamageFromRatio(damageInfo.attackDamageRatio,
        damageInfo.realityPowerRatio, damageInfo.canCrit)
    local enemy = enemyEntity:getComponent('Enemy')
    enemy:takeDamage(damage, damageInfo.damageType, damageInfo.armorIgnoreRatio)
    for _, effect in ipairs(damageInfo.effects) do
      enemy:applyEffect(Lume.clone(effect))
    end

    Hump.Gamestate.current():removeEntity(transform:getEntity())
    break
  end
end

return ManageProjectile