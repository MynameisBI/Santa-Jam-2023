local Enemy = require 'src.components.enemy'
local EnemyEntity = require 'src.entities.enemies.enemyEntity'

local Rini = Class('Rini', EnemyEntity)

function Rini:initialize()
    EnemyEntity.initialize(self, Images.enemies.heavy, 'Rini', 25, Enemy.Stats(300, 300, 0, 0.25))

    local animator = self:getComponent('Animator')
    animator:setGrid(18, 18, Images.enemies.heavy:getWidth(), Images.enemies.heavy:getHeight())
    animator:addAnimation('move', {'1-2', 1}, 0.55, true)
    animator:setCurrentAnimationName('move')
end

return Rini

