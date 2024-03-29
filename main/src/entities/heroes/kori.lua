local Hero = require 'src.components.hero'
local HeroEntity = require 'src.entities.heroes.heroEntity'
local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'
local Animator = require 'src.components.animator'
local Timer = require 'src.components.timer'
local EnemyEffect = require 'src.type.enemyEffect'

local Entity = require 'src.entities.entity'

local Kori = Class('Kori', HeroEntity)

Kori.SKILL_DESCRIPTION = "Call a rain of claws dealing 2.0 AD + 2.0 RP physical damage and stun enemies for 3s"

function Kori:initialize(slot)
  Entity.initialize(self)

  HeroEntity.initialize(
    self, slot, Images.heroes.kori, 'Kori', 2, {'bigEar', 'defect', 'trailblazer'},
    {
      [1] = Hero.Stats(45, 45, 2.5, 275, 0, 2, 0, 0, 0, 0),
      [2] = Hero.Stats(60, 60, 2.5, 275, 0, 2, 0, 0, 0, 0),
      [3] = Hero.Stats(80, 80, 2.5, 275, 0, 2, 0, 0, 0, 0),
      [4] = Hero.Stats(107, 107, 2.5, 275, 0, 2, 0, 0, 0, 0),
      [5] = Hero.Stats(142, 142, 2.5, 275, 0, 2, 0, 0, 0, 0),
      [6] = Hero.Stats(190, 190, 2.5, 275, 0, 2, 0, 0, 0, 0),
    },
    nil,
    Hero.Skill('Kori', 120, 10, function(hero)
      local stats = hero:getStats()
      local hx, hy = hero:getEntity():getComponent('Transform'):getGlobalPosition()
      
      self:getComponent('Timer').timer:after(0.25, function()
        local enemyEntities = Hump.Gamestate.current():getEntitiesWithComponent('Enemy')
        enemyEntities = Lume.filter(enemyEntities, function(enemyEntity)
          local ex, ey = enemyEntity:getComponent('Transform'):getGlobalPosition()
          return Lume.distance(hx, hy, ex, ey, true) < 96100 -- 310^2 = 96100
        end)
        for i, enemyEntity in ipairs(enemyEntities) do
          enemyEntity:getComponent('Enemy'):applyEffect(EnemyEffect('stun', 3))
          enemyEntity:getComponent('Enemy'):takeDamage(
              stats.attackDamage * 2 + stats.realityPower * 2, 'reality', stats.realityArmorIgnoreRatio, hero)
        end
      end)

      for x = 330, 530, 50 do
        self:getComponent('Timer').timer:after((x - 330) / 50 * 0.075, function()
          for y = 200, 315, 55 do
            local clawEntity = Entity()
            local clawTransform = clawEntity:addComponent(Transform(x - 50, y - 400, 0, 2, 2))
            clawEntity:addComponent(Sprite(Images.effects.koriClaw, 17))
            local clawTimer = clawEntity:addComponent(Timer())
            clawTimer.timer:tween(0.25, clawTransform, {x = x, y = y}, 'cubic', function()
              clawTimer.timer:after(0.5, function() Hump.Gamestate.current():removeEntity(clawEntity) end)
            end)
            clawTimer.timer:every(0.01, function()
              local clawGhost = Entity()
              local cx, cy = clawTransform:getGlobalPosition()
              clawGhost:addComponent(Transform(cx, cy, 0, 2, 2))
              clawGhost:addComponent(Sprite(Images.effects.koriClaw, 16, 'fade', 7.5,
                  function(sprite) Hump.Gamestate.current():removeEntity(sprite:getEntity()) end))
              Hump.Gamestate.current():addEntity(clawGhost)
            end)
            Hump.Gamestate.current():addEntity(clawEntity)
          end
        end)
      end
    end)
  )

  self:addComponent(Timer())

  local animator = self:getComponent('Animator')
  animator:setGrid(18, 18, Images.heroes.kori:getWidth(), Images.heroes.kori:getHeight())
  animator:addAnimation('idle', {'1-2', 1}, 0.3, true)
  animator:addAnimation('attack', {'3-5', 1}, {0.05, 0.125, 0.825}, true, function()
    animator:setCurrentAnimationName('idle') 
  end)
  animator:setCurrentAnimationName('idle')
end

return Kori