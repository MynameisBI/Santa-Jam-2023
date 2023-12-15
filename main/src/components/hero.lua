local Component = require 'src.components.component'

local Hero = Class('Hero', Component)

-- `traits` is a table of `trait`
  -- `trait` can be 
    -- bigEar, sentient, defect, candyhead
    -- coordinator, artificer, trailblazer, droneMaestro, cracker
-- `levelStats` is a table of objects of class Hero.Stats
-- `skill` is an object of class Hero.Skill
function Hero:initialize(name, traits, levelStats, skill)
  Component.initialize(self)

  self.name = name
  self.traits = traits or {}

  self.level = 1
  self.exp = 0
  self.levelStats = levelStats or {
    [1] = Hero.Stats(),
    [2] = Hero.Stats(),
    [3] = Hero.Stats(),
    [4] = Hero.Stats(),
  }

  self.modifiers = {}

  self.skill = skill or Hero.Skill()
end


Hero.EXPERIENCE_THRESHOLD = {
  2, 4, 8
}

function Hero:addExp(exp)
  self.exp = self.exp + exp
  if self.exp >= Hero.EXPERIENCE_THRESHOLD[self.level] then
    print('level up')
    self.exp = self.exp - Hero.EXPERIENCE_THRESHOLD[self.level]
    self.level = self.level + 1
  end
end


Hero.Stats = Class('Stats')

function Hero.Stats:initialize(attackDamage, realityPower, attackSpeed, range, critChance, critDamage)
  self.attackDamage = attackDamage or 33
  self.realityPower = realityPower or 0
  self.attackSpeed = attackSpeed or 0
  self.range = range or 300
  self.critChance = critChance or 0
  self.critDamage = critDamage or 0
end

function Hero:addStats(level, attackDamage, realityPower, attackSpeed, range, critChance, critDamage)
  self.levelStats[level] = Hero.Stats(attackDamage, realityPower, attackSpeed, range, critChance, critDamage)
end


function Hero:resetModifiers()
  self.modifiers = {}
end

-- `stat` can be attackDamage, realityPower, attackSpeed, range, critChance, critDamage
-- `modifier` is a number
function Hero:addModifier(stat, modifier)
  assert(type(stat) == 'string' and type(modifier) == 'number', 'Invalid stat or modifier')
  table.insert(self.modifiers, {stat = stat, modifier = modifier})
end


Hero.Skill = Class('Skill')

function Hero.Skill:initialize(description, energy, cooldown, fn)
  self.description = description or ''

  self.energy = energy or 60

  self.cooldown = cooldown or 8
  self.secondsUntilSkillReady = 0

  self.fn = fn or function() end
end

function Hero.Skill:isSKillReady()
  return self.secondsUntilSkillReady <= 0
end

function Hero.Skill:getPercentTimeLeft()
  return self.secondsUntilSkillReady / self.cooldown
end


return Hero
