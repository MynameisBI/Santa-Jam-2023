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
local Resources = require 'src.components.resources'
local CurrentSkill = require 'src.components.skills.currentSkill'

local Component = require 'src.components.component'

local Hero = Class('Hero', Component)

Hero.TIER_COLORS = {
  {0.85, 0.85, 0.85},
  {136/255, 192/255, 220/255},
  {227/255, 150/255, 191/255},
  {220/255, 209/255, 125/255},
}

-- `traits` is a table of `trait`
  -- `trait` can be
    -- bigEar, sentient, defect, candyhead
    -- coordinator, artificer, trailblazer, droneMaestro, cracker
-- `baseStats` is a table of objects of class Hero.Stats
-- `skill` is an object of class Hero.Skill
function Hero:initialize(name, tier, traits, baseStats, bulletClass, skill)
  Component.initialize(self)

  self.name = name

  self.tier = tier

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
  -- TemporaryStats is just AllyStats with a `duration` properties
  self.temporaryModifierStatses = {}

  self.bulletClass = bulletClass
  self.secondsUntilAttackReady = 0

  self.skill = skill or Hero.Skill()
  self.skill.hero = self

  self.modEntity = nil

  -- Overridable functions for traits:
    -- getStats(hero), getBasicAttackDamage(hero, enemyEntity),
    -- getDamageFromRatio(hero, attackDamageRatio, realityDamageRatio, canCrit, enemyEntity)
    -- onSkillCast(skill), getMaxChargeCount(skill)
  self.overrides = {}

  -- Overridable functions for skills:
  self.onUpdate = function(self, dt) end
  self.onBasicAttack = function(self, enemyEntity) return true end -- return false to cancel the attack
  self.onBattleStart = function(self, isInTeam, teamHeroes) end
  self.onBattleEnd = function(self, isInTeam, teamHeroes) end
end

function Hero:getSellPrice()
  return self.tier * self.level
end

function Hero:hasTrait(trait)
  return Lume.find(self.traits, trait) and true or false
end


Hero.EXPERIENCE_THRESHOLD = {
  2, 4, 8, 16, 32
}
Hero.MAX_LEVEL = #Hero.EXPERIENCE_THRESHOLD + 1

function Hero:addExp(exp)
  if self:isMaxLevel() then return end

  self.exp = self.exp + exp
  while self.exp >= Hero.EXPERIENCE_THRESHOLD[self.level] do
    self.exp = self.exp - Hero.EXPERIENCE_THRESHOLD[self.level]
    self.level = self.level + 1
    if self:isMaxLevel() then
      break
    end
  end
end

function Hero:isMaxLevel()
  return self.level >= Hero.MAX_LEVEL
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

function Hero:addModiferStats(stats)
  table.insert(self.modifierStatses, stats)
end

function Hero:addTemporaryModifierStats(stats, duration)
  stats.duration = duration or 3
  table.insert(self.temporaryModifierStatses, stats)
end

function Hero:getStats()
  if self.overrides.getStats then return self.overrides.getStats(self) end

  local stats = self.baseStats[self.level]
  if self.modEntity then
    stats = stats + self.modEntity:getComponent('Mod').stats
  end
  for _, modifierStats in ipairs(self.modifierStatses) do
    stats = stats + modifierStats
  end
  for _, temporaryModifierStats in ipairs(self.temporaryModifierStatses) do
    stats = stats + temporaryModifierStats
  end
  return stats
end

function Hero:getBasicAttackDamage(enemyEntity)
  if self.overrides.getBasicAttackDamage then return self.overrides.getBasicAttackDamage(self, enemyEntity) end

  return self:getDamageFromRatio(1, 0, true, enemyEntity)
end

function Hero:getDamageFromRatio(attackDamageRatio, realityPowerRatio, canCrit, enemyEntity)
  local canCrit = (self.modEntity ~= nil and self.modEntity:getComponent('Mod').id == 'SPP') and true or canCrit

  if self.overrides.getDamageFromRatio then
    return self.overrides.getDamageFromRatio(self, attackDamageRatio, realityPowerRatio, canCrit, enemyEntity)
  end

  local stats = self:getStats()
  return (stats.attackDamage * attackDamageRatio + stats.realityPower * realityPowerRatio) *
      ((math.random() > stats.critChance) and 1 or stats.critDamage)
end


Hero.Skill = Class('Skill')

function Hero.Skill:initialize(description, energy, cooldown, fn, hasSecondaryCast, secondaryW, secondaryH, secondaryCenterW, secondaryCenterH)
  self.description = description or ''

  self.energy = energy or 60

  self._baseCooldown = cooldown or 8
  self.secondsUntilSkillReady = 0

  self._fn = fn or function() end
  self.hasSecondaryCast = hasSecondaryCast or false
  self.secondaryW, self.secondaryH = secondaryW or 200, secondaryH or 60
  self.secondaryCenterW, self.secondaryCenterH = secondaryCenterW or 0, secondaryCenterH or 0

  self.chargeCount = nil

  self.hero = nil
end

function Hero.Skill:getCooldown()
  return self._baseCooldown * (1 - self.hero:getStats().cooldownReduction)
end

function Hero.Skill:getMaxChargeCount()
  if self.hero.overrides.getMaxChargeCount then return self.hero.overrides.getMaxChargeCount(self) end

  return 0
end

function Hero.Skill:isSKillReady()
  return self.secondsUntilSkillReady <= 0
end

function Hero.Skill:getPercentTimeLeft()
  return self.secondsUntilSkillReady / self:getCooldown()
end

function Hero.Skill:cast()
  if not (self.chargeCount >= 1 or self.secondsUntilSkillReady <= 0) then return false end

  if not Resources():modifyEnergy(-self.energy) then return false end

  if self.chargeCount >= 1 then
    self.chargeCount = self.chargeCount - 1
    if self.secondsUntilSkillReady <= 0 then
      self.chargeCount = self.chargeCount + 1
      self.secondsUntilSkillReady = self.secondsUntilSkillReady + self:getCooldown()
    end

  elseif self.secondsUntilSkillReady <= 0 then
    local stats = self.hero:getStats()
    self.secondsUntilSkillReady = self:getCooldown()
  end

  if not self.hasSecondaryCast then
    self._fn(self.hero)
    if self.hero.overrides.onSkillCast then return self.hero.overrides.onSkillCast(self) end
  else
    CurrentSkill().currentSkill = self
  end

  return true
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
  [11] = RadioPopper,
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
