local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'
local Animator = require 'src.components.animator'
local Area = require 'src.components.area'
local Enemy = require 'src.components.enemy'
local Inspectable = require 'src.components.inspectable'
local Entity = require 'src.entities.entity'

local EnemyEntity = Class('EnemyEntity', Entity)

function EnemyEntity:initialize(image, name, speed, baseStats)
    Entity.initialize(self)

    self:addComponent(Transform(800, 270, 0, 2, 2))

    self:addComponent(Sprite(image, 10))

    self:addComponent(Animator())

    self:addComponent(Area(36, 36))

    local enemy = self:addComponent(Enemy(name, speed, baseStats))

    self:addComponent(Inspectable(nil, 3, 1, 'enemy', enemy))
end

return EnemyEntity