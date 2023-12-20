local System = require 'src.systems.system'

local UpdateAreaSkill = Class('UpdateAreaSkill', System)

function UpdateAreaSkill:initialize()
  System.initialize(self, 'Transform', 'AreaSkill')
end

function UpdateAreaSkill:update(transform, areaSkill, dt)
  areaSkill.secondsUntilDetonate = areaSkill.secondsUntilDetonate - dt
  if areaSkill.secondsUntilDetonate <= 0 then
    local stats = areaSkill.hero:getStats()
    local damageInfo = areaSkill.damageInfo

    local damage = stats.attackDamage * damageInfo.attackDamageRatio + stats.realityPower * damageInfo.realityPowerRatio
    if damageInfo.canCrit and math.random() < stats.critChance then damage = damage * stats.critDamage end

    local enemyEntities = Hump.Gamestate.current():getEntitiesWithComponent('Enemy')
    enemyEntities = Lume.filter(enemyEntities, function(enemyEntity)
      local x, y = enemyEntity:getComponent('Transform'):getGlobalPosition()
      return Lume.distance(x, y, areaSkill.x, areaSkill.y) <= areaSkill.range
    end)
    for _, enemyEntity in ipairs(enemyEntities) do
      print(('%s take %d %s damage'):format(
        tostring(enemyEntity), damage, areaSkill.damageInfo.damageType))
    end

    Hump.Gamestate.current():removeEntity(transform:getEntity())
  end
end

return UpdateAreaSkill