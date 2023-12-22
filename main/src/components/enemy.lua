local Component = require 'src.components.component'
local Input = require 'src.components.input'

local Enemy = Class('Enemy', Component)

function Enemy:initialize(name, speed, stats)
    Component.initialize(self)
    self.input = Input()

    self.name = name
    -- speed (slow = 10, medium = 25, fast = 40)
    self.speed = speed
    self.stats = stats or Enemy.Stats()
end

Enemy.Stats = Class('Enemy Stats')

function Enemy.Stats:initialize(maxHP, physicalArmor, realityArmor, speed, damage)
    assert(type(maxHP) == 'number', 'Invalid max HP')
    self.HP = maxHP
    self.maxHP = maxHP

    assert(type(physicalArmor) == 'number' and 0 <= physicalArmor and physicalArmor <= 1,
        'Invalid physical armor')
    self.physicalArmor = physicalArmor

    assert(type(realityArmor) == 'number' and 0 <= realityArmor and realityArmor <= 1,
        'Invalid physical armor')
    self.realityArmor = realityArmor

    self.speed = speed or 25
    self.damage = damage or 2
end

function Enemy.Stats:getValues()
    return {
        HP = self.maxHP,
        maxHP = self.maxHP,
        physicalArmor = self.physicalArmor,
        psychicArmor = self.psychicArmor
    }
end

function Enemy:takeDamage(damage, damageType)
    assert(damageType == 'physical' or damageType == 'reality' or damageType == 'true', 'Invalid damage type')
    if damageType == 'physical' then
        damage = damage * (1 - self.stats.physicalArmor) 
    elseif damageType == 'reality' then
        damage = damage * (1 - self.stats.realityArmor)
    elseif damageType == 'true' then
        damage = damage
    end

    self.stats.HP = self.stats.HP - damage
end

return Enemy
