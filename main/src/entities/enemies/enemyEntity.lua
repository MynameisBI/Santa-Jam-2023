local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'
local Animator = require 'src.components.animator'
local Area = require 'src.components.area'
local Enemy = require 'src.components.enemy'
local Inspectable = require 'src.components.inspectable'
local Entity = require 'src.entities.entity'
local Phase = require 'src.components.phase'

local EnemyEntity = Class('EnemyEntity', Entity)

EnemyEntity.HP_SCALE_PER_ROUND = 0.05

function EnemyEntity:initialize(image, name, baseStats)
    Entity.initialize(self)

    self:addComponent(Transform(800, 270, 0, 2, 2))

    self:addComponent(Sprite(image, 10))

    self:addComponent(Animator())

    self:addComponent(Area(36, 36))

    baseStats.HP = baseStats.HP * (1 + (Phase():getCurrentRoundIndex()-1) * EnemyEntity.HP_SCALE_PER_ROUND)
    baseStats.maxHP = baseStats.maxHP * (1 + (Phase():getCurrentRoundIndex()-1) * EnemyEntity.HP_SCALE_PER_ROUND)
    local enemy = self:addComponent(Enemy(name, baseStats))

    self:addComponent(Inspectable(nil, 3, 1, 'enemy', enemy))
end

return EnemyEntity