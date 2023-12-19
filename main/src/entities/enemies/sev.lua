local Enemy = require 'src.components.enemy'
local EnemyEntity = require 'src.entities.enemies.enemyEntity'

local Sev = Class('Sev', EnemyEntity)

function Sev:initialize()
    EnemyEntity.initialize(self, Images.enemies.fast, 'Sev', 40, Enemy.Stats(750, 750, 0.5, 0))

    local animator = self:getComponent('Animator')
    animator:setGrid(18, 18, Images.enemies.fast:getWidth(), Images.enemies.fast:getHeight())
    animator:addAnimation('move', {'5-8', 1}, 0.55, true)
    animator:setCurrentAnimationName('move')
end

return Sev
