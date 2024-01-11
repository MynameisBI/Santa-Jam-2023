local Enemy = require 'src.components.enemy'
local EnemyEntity = require 'src.entities.enemies.enemyEntity'

local Amber = Class('Amber', EnemyEntity)

function Amber:initialize()
    EnemyEntity.initialize(self, Images.enemies.mini, 'Amber', Enemy.Stats(240, 0.2, 0.2, 160, 3))

    local animator = self:getComponent('Animator')
    animator:setGrid(18, 18, Images.enemies.mini:getWidth(), Images.enemies.mini:getHeight())
    animator:addAnimation('move', {'5-6', 1}, 0.55, true)
    animator:setCurrentAnimationName('move')
end

return Amber

