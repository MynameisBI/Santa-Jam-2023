local Enemy = require 'src.components.enemy'
local EnemyEntity = require 'src.entities.enemies.enemyEntity'

local Mino = Class('Mino', EnemyEntity)

function Mino:initialize()
    EnemyEntity.initialize(self, Images.enemies.mini, 'Mino', Enemy.Stats(80, 0, 0, 100, 1))

    local animator = self:getComponent('Animator')
    animator:setGrid(18, 18, Images.enemies.mini:getWidth(), Images.enemies.mini:getHeight())
    animator:addAnimation('move', {'1-2', 1}, 0.55, true)
    animator:setCurrentAnimationName('move')
end

return Mino

