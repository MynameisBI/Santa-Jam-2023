local Enemy = require 'src.components.enemy'
local EnemyEntity = require 'src.entities.enemies.enemyEntity'

local Leo = Class('Leo', EnemyEntity)

function Leo:initialize()
    EnemyEntity.initialize(self, Images.enemies.fast, 'Leo', Enemy.Stats(4000, 0.75, 0, 40, 2))

    local animator = self:getComponent('Animator')
    animator:setGrid(18, 18, Images.enemies.fast:getWidth(), Images.enemies.fast:getHeight())
    animator:addAnimation('move', {'9-12', 1}, 0.075, true)
    animator:setCurrentAnimationName('move')
end

return Leo
