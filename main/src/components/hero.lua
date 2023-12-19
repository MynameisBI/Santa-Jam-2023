local HarmonizerUnit = require 'src.entities.mods.harmonizerUnit'
local QuantumToken = require 'src.entities.mods.quantumToken'
local HullTransformer = require 'src.entities.mods.hullTransformer'
local BrainImplant = require 'src.entities.mods.brainImplant'
local SyntheticCore = require 'src.entities.mods.syntheticCore'
local NoradInhaler = require 'src.entities.mods.noradInhaler'
local TheConductor = require 'src.entities.mods.theConductor'
local SkaterayEqualizer = require 'src.entities.mods.skaterayEqualizer'
local RadioPopper = require 'src.entities.mods.radioPopper'
local AsymframeVisionary = require 'src.entities.mods.asymframeVisionary'
local AbovesSliver = require 'src.entities.mods.abovesSliver'
local SubcellularSupervisor = require 'src.entities.mods.subcellularSupervisor'
local NeuralProcessor = require 'src.entities.mods.neuralProcessor'
local BionicColumn = require 'src.entities.mods.bionicColumn'
local EnhancerFumes = require 'src.entities.mods.enhancerFumes'
local DeathsPromise = require 'src.entities.mods.deathsPromise'
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

  self.modEntity = nil
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


Hero.Stats = require 'src.type.allyStats'

-- Usage:
-- `hero:addBaseStats(level, AllyStats(...))`
function Hero:addBaseStats(level, stats)
  assert(stats.class.name == 'Hero Stats', 'stat parameter must be instance of AllyStats')
  self.baseStats[level] = stats
end

function Hero:getBaseStats()
  return self.baseStats[self.level]
end

function Hero:resetModifierStatses()
  self.modifierStatses = {}
end

-- Usage:
-- `hero:addModifierStats(AllyStats(...))`
function Hero:addModifierStats(stats)
  assert(stats.class.name == 'Hero Stats', 'stat parameter must be instance of AllyStats')
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


-- S = 1, P = 2, B = 4
-- tier2Mods[N+N] = NN
local TIER_2_MODS = {
  [2] = HarmonizerUnit,
  [3] = QuantumToken,
  [5] = HullTransformer,
  [4] = BrainImplant,
  [6] = SyntheticCore,
  [8] = NoradInhaler,
}
-- S = 1, P = 3, B = 9
local TIER_3_MODS = {
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
  assert(type(modEntity), 'Invalid mod entity')

  if self.modEntity == nil then
    self.modEntity = modEntity
    return true

  else
    local currentMod = self.modEntity:getComponent('Mod')
    local toAddedMod = modEntity:getComponent('Mod')
    local newModEntity = Hero.getModEntityFromModCombination(currentMod, toAddedMod)
    if newModEntity then
      self.modEntity = newModEntity
      return true
    else
      return false
    end
  end
end

function Hero.getModEntityFromModCombination(mod1, mod2)
  local resultModId = mod1.id..mod2.id

  if #resultModId == 2 then
    local modIndex = 0
    for i = 1, 2 do
      local char = resultModId:sub(i, i)
      if char == 'S' then modIndex = modIndex + 1
      elseif char == 'P' then modIndex = modIndex + 2
      elseif char == 'B' then modIndex = modIndex + 4
      end
    end
    return TIER_2_MODS[modIndex]()

  elseif #resultModId == 3 then
    local modIndex = 0
    for i = 1, 3 do
      local char = resultModId:sub(i, i)
      if char == 'S' then modIndex = modIndex + 1
      elseif char == 'P' then modIndex = modIndex + 3
      elseif char == 'B' then modIndex = modIndex + 9
      end
    end
    return TIER_3_MODS[modIndex]()

  else
    return false
  end
end

return Hero
