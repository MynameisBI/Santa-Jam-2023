local Enemy = require 'src.components.enemy'
local EnemyEntity = require 'src.entities.enemies.enemyEntity'

local Pepero = Class('Pepero', EnemyEntity)

function Pepero:initialize()
    EnemyEntity.initialize(self, Images.enemies.fast, 'Pepero', 10, Enemy.Stats(30, 40, 100, 100))

    local animator = self:getComponent('Animator')
    animator:setGrid(18, 18, Images.enemies.fast:getWidth(), Images.enemies.fast:getHeight())
    animator:addAnimation('move', {'1-4', 1}, 0.55, true)
    animator:setCurrentAnimationName('move')
end

return Pepero
