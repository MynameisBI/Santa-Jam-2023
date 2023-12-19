local Enemy = require 'src.components.enemy'
local EnemyEntity = require 'src.entities.enemies.enemyEntity'

local Amber = Class('Amber', EnemyEntity)

function Amber:initialize()
    EnemyEntity.initialize(self, Images.enemies.mini, 'Amber', 10, Enemy.Stats(30, 40, 100, 100))

    local animator = self:getComponent('Animator')
    animator:setGrid(18, 18, Images.enemies.mini:getWidth(), Images.enemies.mini:getHeight())
    animator:addAnimation('move', {'5-6', 1}, 0.55, true)
    animator:setCurrentAnimationName('move')
end

return Amber

