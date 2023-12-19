local Enemy = require 'src.components.enemy'
local EnemyEntity = require 'src.entities.enemies.enemyEntity'

local Pepero = Class('Pepero', EnemyEntity)

function Pepero:initialize()
    EnemyEntity.initialize(self, Images.enemies.fast, 'Pepero', 40, Enemy.Stats(150, 150, 0.25, 0))

    local animator = self:getComponent('Animator')
    animator:setGrid(18, 18, Images.enemies.fast:getWidth(), Images.enemies.fast:getHeight())
    animator:addAnimation('move', {'1-4', 1}, 0.55, true)
    animator:setCurrentAnimationName('move')
end

return Pepero
