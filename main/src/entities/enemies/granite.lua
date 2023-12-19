local Enemy = require 'src.components.enemy'
local EnemyEntity = require 'src.entities.enemies.enemyEntity'

local Granite = Class('Granite', EnemyEntity)

function Granite:initialize()
    EnemyEntity.initialize(self, Images.enemies.gigantic, 'Granite', 10, Enemy.Stats(30, 40, 100, 100))

    local animator = self:getComponent('Animator')
    animator:setGrid(18, 18, Images.enemies.gigantic:getWidth(), Images.enemies.gigantic:getHeight())
    animator:addAnimation('move', {'5-6', 1}, 0.55, true)
    animator:setCurrentAnimationName('move')
end

return Granite