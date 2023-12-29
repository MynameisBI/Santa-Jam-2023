local Component = require 'src.components.component'
local Input = require 'src.components.input'
local EnemyEffect = require 'src.type.enemyEffect'
local Resources = require 'src.components.resources'

local Enemy = Class('Enemy', Component)

function Enemy:initialize(name, stats)
    Component.initialize(self)
    self.input = Input()

    self.name = name
    self.stats = stats or Enemy.Stats()
    self.stats.enemy = self
    self.effects = {}

    self.isDestroyed = false

    self.isBeingKnocked = false
    self.timer = Hump.Timer()
    self.knockHandle = nil
end

function Enemy:knockBack(dist)
  local transform = self:getEntity():getComponent('Transform')
  local x, y = transform:getGlobalPosition()

  self.isBeingKnocked = true
  if self.knockHandle then
    self.timer:cancel(self.knockHandle)
  end
  self.knockHandle = self.timer:tween(0.25, transform, {x = math.min(x + dist, 880)}, 'out-cubic', function()
    self.isBeingKnocked = false
    self.knockHandle = nil
  end)
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

    self.enemy = nil
end

function Enemy.Stats:getValues()
    return {
        HP = self.HP,
        maxHP = self.maxHP,
        physicalArmor = self.enemy:getArmor('physical'),
        realityArmor = self.enemy:getArmor('reality'),
        speed = self.enemy:getSpeed(),
        damage = self.damage,
    }
end

function Enemy:takeDamage(damage, damageType, armorIgnoreRatio, hero)
    assert(damageType == 'physical' or damageType == 'reality' or damageType == 'true', 'Invalid damage type')
    assert((hero.class ~= nil and (hero.class.name == 'Hero' or hero.class.name == 'Drone')) or hero == 'candy', 'Invalid hero: '..tostring(hero))

    local hasSkottMark, skottMark = self:getAppliedEffect('skottMark')
    if hasSkottMark then
      for i, effect in ipairs(self.effects) do
        if effect == skottMark then
          table.remove(self.effects, i)
          break
        end
      end
      self:takeDamage(skottMark.damage, skottMark.damageType, skottMark.armorIgnoreRatio, hero)
      self:applyEffect(EnemyEffect('stun', skottMark.stunDuration))
      Resources():modifyEnergy(skottMark.energy)
    end

    if type(hero) == 'table' and hero.modEntity then
      local mod = hero.modEntity:getComponent('Mod')
      if mod.id == 'SBB' then
        self:applyEffect(EnemyEffect('reducePhysicalArmor', math.huge))
      elseif mod.id == 'PPB' then
        self:applyEffect(EnemyEffect('reduceRealityArmor', math.huge))
      end
    end

    local armorIgnoreRatio = armorIgnoreRatio or 0

    -- `getArmor()` already calculate the reduced armor ratio from debuffs etc
    if damageType == 'physical' then
        damage = damage * (1 - self:getArmor('physical') * (1 - armorIgnoreRatio))
    elseif damageType == 'reality' then
        damage = damage * (1 - self:getArmor('reality') * (1 - armorIgnoreRatio))
    elseif damageType == 'true' then
        damage = damage
    end

    self.stats.HP = self.stats.HP - damage
end

function Enemy:getArmor(armorType)
  return self.stats[armorType..'Armor'] *
      (1 - (self:getAppliedEffect('reduce'..armorType:gsub("^%l", string.upper)..'Armor') and 0.5 or 0))
end

function Enemy:getSpeed()
  local isStunned = self:getAppliedEffect('stun')
  if isStunned then return 0 end

  local isSlowed, strength = self:getAppliedEffect('slow')
  strength = strength or 0
  return self.stats.speed * (1 - strength)
end


function Enemy:applyEffect(enemyEffect)
  table.insert(self.effects, enemyEffect)
end

function Enemy:getAppliedEffect(effectType)
  local effects = Lume.filter(self.effects, function(effect) return effect.effectType == effectType end)

  if #effects == 0 then
    return false
  else
    if effectType ~= 'slow' then
      local shortestDuration = math.huge
      local shortestEffect = nil
      for _, effect in ipairs(effects) do
        if effect.duration < shortestDuration then
          shortestEffect = effect
          shortestDuration = effect.duration
        end
      end
      return true, shortestEffect
    else
      return true, math.max(unpack(
        Lume.map(effects, function(slowEffect) return slowEffect.strength end)))
    end
  end
end

return Enemy
