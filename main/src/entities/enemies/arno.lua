local Enemy = require 'src.components.enemy'
local EnemyEntity = require 'src.entities.enemies.enemyEntity'

local Arno = Class('Arno', EnemyEntity)

function Arno:initialize()
    EnemyEntity.initialize(self, Images.enemies.gigantic, 'Arno', Enemy.Stats(3200, 0, 0, 40, 2))

    local animator = self:getComponent('Animator')
    animator:setGrid(18, 18, Images.enemies.gigantic:getWidth(), Images.enemies.gigantic:getHeight())
    animator:addAnimation('move', {'1-2', 1}, 0.55, true)
    animator:setCurrentAnimationName('move')
end

return Arno