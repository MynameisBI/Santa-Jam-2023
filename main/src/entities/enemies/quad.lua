local Enemy = require 'src.components.enemy'
local EnemyEntity = require 'src.entities.enemies.enemyEntity'

local Quad = Class('Quad', EnemyEntity)

function Quad:initialize()
    EnemyEntity.initialize(self, Images.enemies.gigantic, 'Quad', Enemy.Stats(3600, 0, 0, 40, 8))

    local animator = self:getComponent('Animator')
    animator:setGrid(18, 18, Images.enemies.gigantic:getWidth(), Images.enemies.gigantic:getHeight())
    animator:addAnimation('move', {'3-4', 1}, 0.55, true)
    animator:setCurrentAnimationName('move')
end

return Quad