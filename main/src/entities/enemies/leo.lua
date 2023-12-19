local Enemy = require 'src.components.enemy'
local EnemyEntity = require 'src.entities.enemies.enemyEntity'

local Leo = Class('Leo', EnemyEntity)

function Leo:initialize()
    EnemyEntity.initialize(self, Images.enemies.fast, 'Leo', 40, Enemy.Stats(4000, 4000, 0.75, 0))

    local animator = self:getComponent('Animator')
    animator:setGrid(18, 18, Images.enemies.fast:getWidth(), Images.enemies.fast:getHeight())
    animator:addAnimation('move', {'9-12', 1}, 0.55, true)
    animator:setCurrentAnimationName('move')
end

return Leo
