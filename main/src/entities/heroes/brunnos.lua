local Hero = require 'src.components.hero'
local HeroEntity = require 'src.entities.heroes.heroEntity'
local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'
local Animator = require 'src.components.animator'
local Timer = require 'src.components.timer'
local TargetSkillEntity = require 'src.entities.skills.targetSkillEntity'

local Entity = require 'src.entities.entity'

local Brunnos = Class('Brunnos', HeroEntity)

Brunnos.SKILL_DESCRIPTION = "Basic attack the enemy with highest health 6 + 0.02 RP times"

function Brunnos:initialize(slot)
  Entity.initialize(self)

  HeroEntity.initialize(
    self, slot, Images.heroes.brunnos, 'Brunnos', 1, {'sentient', 'trailblazer'},
    {
        [1] = Hero.Stats(45, 20, 2.6, 375, 0, 2, 0, 0, 0, 0),
        [2] = Hero.Stats(60, 27, 2.6, 375, 0, 2, 0, 0, 0, 0),
        [3] = Hero.Stats(80, 36, 2.6, 375, 0, 2, 0, 0, 0, 0),
        [4] = Hero.Stats(107, 47, 2.6, 375, 0, 2, 0, 0, 0, 0),
        [5] = Hero.Stats(142, 63, 2.6, 375, 0, 2, 0, 0, 0, 0),
        [6] = Hero.Stats(190, 84, 2.6, 375, 0, 2, 0, 0, 0, 0),
    },

    nil,
    Hero.Skill('Brunnos', 20, 5, function(hero, mx, my)
      local enemies = Hump.Gamestate.current():getComponents('Enemy')
      local highestHealthEnemy
      local highestHealth = -math.huge
      for _, enemy in ipairs(enemies) do
        if enemy.stats.HP > highestHealth then
          highestHealthEnemy = enemy
          highestHealth = enemy.stats.HP
        end
      end
      if highestHealthEnemy == nil then return end

      local stats = hero:getStats()
      self:getComponent('Timer').timer:every(0.2, function()
        if highestHealthEnemy.stats.HP <= 0 then return end

        local targetSkillEntity = Hump.Gamestate.current():addEntity(
          TargetSkillEntity(hero, highestHealthEnemy:getEntity(),
              {damageType = 'physical', attackDamageRatio = 1, canCrit = true}, 0)
        )

        local effectEntity = Entity()
        local x, y = targetSkillEntity:getComponent('Transform'):getGlobalPosition()
        local transform = effectEntity:addComponent(Transform(x + 14, y + 14, 0, 2, 2, 7, 7))
        effectEntity:addComponent(Sprite(Images.effects.brunnosSlash, 16))
        local animator = effectEntity:addComponent(Animator())
        animator:setGrid(14, 14, Images.effects.brunnosSlash:getWidth(), 14)
        local randomFrameI = math.random(0, 1)
        animator:addAnimation('default',
            {('%d-%d'):format(1 + randomFrameI*2, 2 + randomFrameI*2), 1}, 0.1, false,
            function() Hump.Gamestate.current():removeEntity(effectEntity) end)
        animator:setCurrentAnimationName('default')
        Hump.Gamestate.current():addEntity(effectEntity)
      end, 6 + Lume.round(stats.realityPower * 0.02))
    end),
    3, 0
  )

  local animator = self:getComponent('Animator')
  animator:setGrid(18, 18, Images.heroes.brunnos:getWidth(), Images.heroes.brunnos:getHeight())
  animator:addAnimation('idle', {'1-2', 1}, 0.5, true)
  animator:addAnimation('attack', {'7-8', 1, '5-6', 1}, {0.075, 0.15, 0.15, 0.625}, true, function()
    animator:setCurrentAnimationName('idle') 
  end)
  animator:setCurrentAnimationName('idle')

  self:addComponent(Timer())
end

return Brunnos