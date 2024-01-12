local Enemy = require 'src.components.enemy'
local EnemyEntity = require 'src.entities.enemies.enemyEntity'

local Elio = Class('Elio', EnemyEntity)

function Elio:initialize()
    EnemyEntity.initialize(self, Images.enemies.heavy, 'Elio', Enemy.Stats(1125, 0, 0.75, 70, 6))

    local animator = self:getComponent('Animator')
    animator:setGrid(18, 18, Images.enemies.heavy:getWidth(), Images.enemies.heavy:getHeight())
    animator:addAnimation('move', {'5-6', 1}, 0.55, true)
    animator:setCurrentAnimationName('move')
end

return Elio