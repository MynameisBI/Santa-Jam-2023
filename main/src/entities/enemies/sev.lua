local Enemy = require 'src.components.enemy'
local EnemyEntity = require 'src.entities.enemies.enemyEntity'

local Sev = Class('Sev', EnemyEntity)

function Sev:initialize()
    EnemyEntity.initialize(self, Images.enemies.fast, 'Sev', Enemy.Stats(225, 0.5, 0, 150, 4))

    local animator = self:getComponent('Animator')
    animator:setGrid(18, 18, Images.enemies.fast:getWidth(), Images.enemies.fast:getHeight())
    animator:addAnimation('move', {'5-8', 1}, 0.075, true)
    animator:setCurrentAnimationName('move')
end

return Sev
