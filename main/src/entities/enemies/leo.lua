local Enemy = require 'src.components.enemy'
local EnemyEntity = require 'src.entities.enemies.enemyEntity'

local Leo = Class('Leo', EnemyEntity)

function Leo:initialize()
    EnemyEntity.initialize(self, Images.enemies.fast, 'Leo', 10, Enemy.Stats(30, 40, 100, 100))

    local animator = self:getComponent('Animator')
    animator:setGrid(18, 18, Images.enemies.fast:getWidth(), Images.enemies.fast:getHeight())
    animator:addAnimation('move', {'9-12', 1}, 0.55, true)
    animator:setCurrentAnimationName('move')
end

return Leo
