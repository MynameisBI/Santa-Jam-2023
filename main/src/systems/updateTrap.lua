local CurrentSkill = require 'src.components.skills.currentSkill'
local Phase = require 'src.components.phase'

local System = require 'src.systems.system'

local UpdateTrap = Class('UpdateTrap', System)

function UpdateTrap:initialize()
  System.initialize(self, 'Transform', 'Area', 'Trap')
end

function UpdateTrap:update(transform, area, trap, dt)
  if Phase():current() ~= 'battle' then
    trap:onActivation({})
    return
  end

  if trap.secondsUntilArmed > 0 then
    trap.secondsUntilArmed = trap.secondsUntilArmed - dt
    return
  end

  if trap.secondsUntilDetonate > 0 then
    trap.secondsUntilDetonate = trap.secondsUntilDetonate - dt
  else
    trap:onActivation({})
    Hump.Gamestate.current():removeEntity(transform:getEntity())
    return
  end

  local areaX, areaY = transform:getGlobalPosition()
  local areaW, areaH = area:getSize()
  local enemyEntities = Hump.Gamestate.current():getEntitiesWithComponent('Enemy')
  enemyEntities = Lume.filter(enemyEntities, function(enemyEntity)
    local x, y = enemyEntity:getComponent('Transform'):getGlobalPosition()
    local w, h = enemyEntity:getComponent('Area'):getSize()
    return x < areaX + areaW and x + w > areaX and y < areaY + h and y + h > areaY
  end)

  if #enemyEntities >= 1 then
    trap:onActivation(enemies)
    Hump.Gamestate.current():removeEntity(transform:getEntity())
  end
end

return UpdateTrap