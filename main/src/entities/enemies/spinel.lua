local Enemy = require 'src.components.enemy'
local EnemyEntity = require 'src.entities.enemies.enemyEntity'

local Spinel = Class('Spinel', EnemyEntity)

function Spinel:initialize()
    EnemyEntity.initialize(self, Images.enemies.heavy, 'Spinel', 25, Enemy.Stats(40, 0, 0))

    local animator = self:getComponent('Animator')
    animator:setGrid(18, 18, Images.enemies.heavy:getWidth(), Images.enemies.heavy:getHeight())
    animator:addAnimation('move', {'3-4', 1}, 0.55, true)
    animator:setCurrentAnimationName('move')
end

return Spinel

