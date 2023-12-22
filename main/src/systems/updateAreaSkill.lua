local System = require 'src.systems.system'

local UpdateAreaSkill = Class('UpdateAreaSkill', System)

function UpdateAreaSkill:initialize()
  System.initialize(self, 'Transform', 'AreaSkill')
end

function UpdateAreaSkill:update(transform, areaSkill, dt)
  if areaSkill.secondsUntilDetonate > 0 then
    areaSkill.secondsUntilDetonate = areaSkill.secondsUntilDetonate - dt

  else
    local continuousInfo = areaSkill.continuousInfo

    if continuousInfo == nil then
      local damageInfo = areaSkill.damageInfo
      self:damageEnemiesInArea(areaSkill.hero, damageInfo, areaSkill.x, areaSkill.y, areaSkill.range)

      Hump.Gamestate.current():removeEntity(transform:getEntity())

    else
      if continuousInfo.secondsUnitlNextTick > 0 then
        continuousInfo.secondsUnitlNextTick = continuousInfo.secondsUnitlNextTick - dt

      else
        local damageInfo = areaSkill.damageInfo
        self:damageEnemiesInArea(areaSkill.hero, damageInfo, areaSkill.x, areaSkill.y, areaSkill.range)
        
        continuousInfo.tickCount = continuousInfo.tickCount - 1
        if continuousInfo.tickCount <= 0 then 
          Hump.Gamestate.current():removeEntity(transform:getEntity())
        else
          continuousInfo.secondsUnitlNextTick = continuousInfo.secondsPerTick
        end
      end
    end
  end
end

function UpdateAreaSkill:damageEnemiesInArea(hero, damageInfo, areaX, areaY, areaR)
  local damage = hero:getDamageFromRatio(damageInfo.attackDamageRatio,
      damageInfo.realityPowerRatio, damageInfo.canCrit)

  local enemyEntities = Hump.Gamestate.current():getEntitiesWithComponent('Enemy')
  enemyEntities = Lume.filter(enemyEntities, function(enemyEntity)
    local x, y = enemyEntity:getComponent('Transform'):getGlobalPosition()
    return Lume.distance(x, y, areaX, areaY) <= areaR
  end)
  for _, enemyEntity in ipairs(enemyEntities) do
    enemyEntity:getComponent('Enemy'):takeDamage(damage, damageInfo.damageType)
  end
end

return UpdateAreaSkill