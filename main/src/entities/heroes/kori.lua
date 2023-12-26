local Hero = require 'src.components.hero'
local HeroEntity = require 'src.entities.heroes.heroEntity'
local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'
local Animator = require 'src.components.animator'
local Timer = require 'src.components.timer'
local EnemyEffect = require 'src.type.enemyEffect'

local Entity = require 'src.entities.entity'

local Kori = Class('Kori', HeroEntity)

function Kori:initialize(slot)
  Entity.initialize(self)

  HeroEntity.initialize(
    self, slot, Images.heroes.kori, 'Kori', {'bigEar', 'defect', 'trailblazer'},
    {
        [1] = Hero.Stats(40, 30, 1.0, 300, 0, 0),
        [2] = Hero.Stats(60, 45, 1.0, 300, 0, 0),
        [3] = Hero.Stats(90, 68, 1.0, 300, 0, 0),
        [4] = Hero.Stats(135, 101, 1.0, 300, 0, 0)
    },
    nil,
    Hero.Skill('Kori', 100, 15, function(hero)
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
              stats.attackDamage * 2 + stats.realityPower * 2, 'reality')
        end
      end)

      for ox = 50, 250, 50 do
        for y = 200, 315, 55 do
          local clawEntity = Entity()
          local clawTransform = clawEntity:addComponent(Transform(hx + ox - 50, y - 400, 0, 2, 2))
          clawEntity:addComponent(Sprite(Images.effects.koriClaw, 17))
          local clawTimer = clawEntity:addComponent(Timer())
          clawTimer.timer:tween(0.25, clawTransform, {x = hx + ox, y = y}, 'cubic', function()
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
      end
    end)
  )

  self:addComponent(Timer())

  local animator = self:getComponent('Animator')
  animator:setGrid(18, 18, Images.heroes.kori:getWidth(), Images.heroes.kori:getHeight())
  animator:addAnimation('idle', {'1-2', 1}, 0.3, true)
  animator:addAnimation('attack', {'3-5', 1}, {1, 0.075, 0.075}, true)
  animator:setCurrentAnimationName('idle')
end

return Kori