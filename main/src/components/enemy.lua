local Component = require 'src.components.component'

local Enemy = Class('Enemy', Component)

function Enemy:initialize(name, speed, stats)
    Component.initialize(self)

    self.name = name
    -- speed (slow = 10, medium = 25, fast = 40)
    self.speed = speed
    self.stats = baseStats or Enemy.Stats()
end

Enemy.Stats = Class('Enemy Stats')

function Enemy.Stats:initialize(physicalArmor, psychicArmor, HP, maxHP)
    self.HP = HP
    self.maxHP = maxHP
    self.physicalArmor = physicalArmor
    self.psychicArmor = psychicArmor
end

function Enemy.Stats:getValues()
    return {
        HP = self.HP,
        maxHP = self.maxHP,
        physicalArmor = self.physicalArmor,
        psychicArmor = self.psychicArmor
    }
end

return Enemy
