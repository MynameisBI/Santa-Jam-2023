local Component = require 'src.components.component'

local Hero = Class('Hero', Component)

-- `traits` is a table of `trait`
  -- `trait` can be
    -- bigEar, sentient, defect, candyhead
    -- coordinator, artificer, trailblazer, droneMaestro, cracker
-- `baseStats` is a table of objects of class Hero.Stats
-- `skill` is an object of class Hero.Skill
function Hero:initialize(name, traits, baseStats, skill)
  Component.initialize(self)

  self.name = name
  self.traits = traits or {}

  self.level = 1
  self.exp = 1
  self.baseStats = baseStats or {
    [1] = Hero.Stats(),
    [2] = Hero.Stats(),
    [3] = Hero.Stats(),
    [4] = Hero.Stats(),
  }

  self.modifierStatses = {}
  self.passive = {}

  self.skill = skill or Hero.Skill()

  self.modEntities = nil
  self.tier1ModIds = {}
end


Hero.EXPERIENCE_THRESHOLD = {
  2, 4, 8
}

function Hero:addExp(exp)
  self.exp = self.exp + exp
  if self.exp >= Hero.EXPERIENCE_THRESHOLD[self.level] then
    self.exp = self.exp - Hero.EXPERIENCE_THRESHOLD[self.level]
    self.level = self.level + 1
  end
end


Hero.Stats = Class('Hero Stats')

function Hero.Stats:initialize(attackDamage, realityPower, attackSpeed, range, critChance, critDamage)
  self.attackDamage = attackDamage or 33
  self.realityPower = realityPower or 0
  self.attackSpeed = attackSpeed or 0
  self.range = range or 300
  self.critChance = critChance or 0
  self.critDamage = critDamage or 0
end

function Hero.Stats:__add(otherStats)
  return Hero.Stats(
    self.attackDamage + otherStats.attackDamage,
    self.realityPower + otherStats.realityPower,
    self.attackSpeed + otherStats.attackSpeed,
    self.range + otherStats.range,
    self.critChance + otherStats.critChance,
    self.critDamage + otherStats.critDamage
  )
end

function Hero.Stats:getValues()
  return {
    attackDamage = self.attackDamage,
    realityPower = self.realityPower,
    attackSpeed = self.attackSpeed,
    range = self.range,
    critChance = self.critChance,
    critDamage = self.critDamage,
  }
end

-- Usage:
-- `hero:addBaseStats(level, Hero.Stats(...))`
function Hero:addBaseStats(level, stats)
  assert(stats.class.name == 'Hero Stats', 'stat parameter must be instance of Hero.Stats')
  self.baseStats[level] = stats
end

function Hero:getBaseStats()
  return self.baseStats[self.level]
end

function Hero:resetModifierStatses()
  self.modifierStatses = {}
end

-- Usage:
-- `hero:addModifierStats(Hero.Stats(...))`
function Hero:addModifierStats(stats)
  assert(stats.class.name == 'Hero Stats', 'stat parameter must be instance of Hero.Stats')
  table.insert(self.modifierStatses, stats)
end

function Hero:getStats()
  local stats = self.baseStats[self.level]
  if self.modEntity then
    stats = stats + self.modEntity:getComponent('Mod').stats
  end
  for i, modifierStats in ipairs(self.modifierStatses) do
    stats = stats + modifierStats
  end
  return stats
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


-- N = 1, P = 2, B = 4
-- tier2Mods[N+N] = NN
local tier2Mods = {
  [2] = HarmonizerUnit,
  [3] = QuantumToken,
  [5] = HullTransformer,
  [4] = BrainImplant,
  [6] = SyntheticCore,
  [8] = NoradInhaler,
}
-- N = 1, P = 3, B = 9
local tier3Mods = {
  [3] = TheConductor,
  [5] = SkaterayEqualizer,
  [10] = RadioPopper,
  [7] = AsymframeVisionary,
  [13] = AbovesSliver,
  [19] = SubcellularSupervisor,
  [9] = NeuralProcessor,
  [15] = BionicColumn,
  [21] = EnhancerFumes,
  [27] = DeathsPromise,
}

function Hero:addMod(modEntity)
  if self.modEntity == nil then
    self.modEntity = modEntity
  else

  end
end

return Hero
