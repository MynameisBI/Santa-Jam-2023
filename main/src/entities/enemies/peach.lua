local Enemy = require 'src.components.enemy'
local EnemyEntity = require 'src.entities.enemies.enemyEntity'

local Peach = Class('Peach', EnemyEntity)

function Peach:initialize()
    EnemyEntity.initialize(self, Images.enemies.mini, 'Peach', 10, Enemy.Stats(30, 40, 100, 100))

    local animator = self:getComponent('Animator')
    animator:setGrid(18, 18, Images.enemies.mini:getWidth(), Images.enemies.mini:getHeight())
    animator:addAnimation('move', {'3-4', 1}, 0.55, true)
    animator:setCurrentAnimationName('move')
end

return Peach

