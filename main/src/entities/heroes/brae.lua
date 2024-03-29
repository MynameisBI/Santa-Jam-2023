local Hero = require 'src.components.hero'
local HeroEntity = require 'src.entities.heroes.heroEntity'
local BraeBullet = require 'src.entities.bullets.braeBullet'
local Transform = require 'src.components.transform'
local Area = require 'src.components.area'
local Sprite = require 'src.components.sprite'
local Trap = require 'src.components.skills.trap'
local AreaSkillEntity = require 'src.entities.skills.areaSkillEntity'
local EnemyEffect = require 'src.type.enemyEffect'
local Timer = require 'src.components.timer'
local Rectangle = require 'src.components.rectangle'
local AudioManager = require 'src.components.audioManager'

local Entity = require 'src.entities.entity'

local Brae = Class('Brae', HeroEntity)

Brae.SKILL_DESCRIPTION = "Create 5 ice pillars that detonate upon impact dealing 1.5 RP reality damage and freeze for 1s"

function Brae:initialize(slot)
  Entity.initialize(self)

  HeroEntity.initialize(
    self, slot, Images.heroes.brae, 'Brae', 3, {'bigEar', 'artificer'},
    {
      [1] = Hero.Stats(50, 60, 1.6, 450, 0, 2, 0, 0, 0, 0),
      [2] = Hero.Stats(67, 80, 1.6, 450, 0, 2, 0, 0, 0, 0),
      [3] = Hero.Stats(89, 107, 1.6, 450, 0, 2, 0, 0, 0, 0),
      [4] = Hero.Stats(119, 142, 1.6, 450, 0, 2, 0, 0, 0, 0),
      [5] = Hero.Stats(158, 190, 1.6, 450, 0, 2, 0, 0, 0, 0),
      [6] = Hero.Stats(211, 253, 1.6, 450, 0, 2, 0, 0, 0, 0),
    },
    BraeBullet,
    Hero.Skill('Brae', 85, 7, function(hero)
      local ys = {}
      for i = 1, 5 do ys[i] = math.random(220, 350) end
      table.sort(ys)
      for i = 1, 5 do
        local x, y = math.random(370, 810), ys[i]
        
        local pillar = Entity()
        local transform = pillar:addComponent(Transform(x, y - 200, 0, 2, 2, 0, 20))
        pillar:addComponent(Area(12, 16, 0, 2, 2))
        pillar:addComponent(Sprite(Images.pets.braeIcePillar, 14))
        pillar:addComponent(Trap(0.25, 5, function()
          local x, y = transform:getGlobalPosition()
          x, y = x + 6, y + 8
          
          Hump.Gamestate.current():addEntity(AreaSkillEntity(hero, {x = x, y = y}, 60, 26,
              {damageType = 'reality', realityPowerRatio = 1.5, effects = {EnemyEffect('stun', 1)}}))
              AudioManager:playSound('fall-down', 0.4)

          local effect = Entity()
          local transform = effect:addComponent(Transform(x, y, 0, 0, 0, 0, 0))
          local rect = effect:addComponent(Rectangle('line', {0.17, 0.48, 0.47, 0.9}, 8, 16))
          local timer = effect:addComponent(Timer())

          timer.timer:tween(0.25, rect.color, {[4] = 0}, 'cubic')
          timer.timer:tween(0.25, rect, {lineWidth = 0}, 'cubic')
          timer.timer:tween(0.25, transform, {sx = 42, sy = 18, ox = 21, oy = 9}, 'out-quad', function()
            Hump.Gamestate.current():removeEntity(effect)
          end)
          Hump.Gamestate.current():addEntity(effect)

          local effect = Entity()
          local transform = effect:addComponent(Transform(x, y, 0, 0, 0, 0))
          local rect = effect:addComponent(Rectangle('line', {1, 1, 1, 0.3}, 2, 16))
          local timer = effect:addComponent(Timer())

          timer.timer:tween(0.35, rect.color, {[4] = 0}, 'cubic')
          timer.timer:tween(0.35, transform, {sx = 60, sy = 26, ox = 30, oy = 13}, 'out-quad', function()
            Hump.Gamestate.current():removeEntity(effect)
          end)
          Hump.Gamestate.current():addEntity(effect)


        end))
        local timer = pillar:addComponent(Timer())
        timer.timer:tween(0.25, transform, {y = y}, 'quad')

        Hump.Gamestate.current():addEntity(pillar)
      end
    end),
    2, 0
  )

  local animator = self:getComponent('Animator')
  animator:setGrid(18, 18, Images.heroes.brae:getWidth(), Images.heroes.brae:getHeight())
  animator:addAnimation('idle', {'1-2', 1}, {1.5, 2}, true)
  animator:addAnimation('attack', {'3-4', 1, 3, 1}, {0.05, 0.3, 0.7}, true, function()
    animator:setCurrentAnimationName('idle') 
  end)
  animator:setCurrentAnimationName('idle')
end

return Brae