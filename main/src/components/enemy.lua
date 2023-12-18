local Component = require 'src.components.component'

local Enemy = Class('Enemy', Component)

function Enemy:initialize(name, speed, stats)
    Component.initialize(self)

    self.name = name
    self.speed = speed or 10
    self.stats = stats or Enemy.Stats()
end

Enemy.Stats = Class('Stats')

function Enemy.Stats:initialize(physicalArmor, psychicArmor, HP, maxHP)
    self.HP = HP or 100
    self.maxHP = maxHP or 100
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
