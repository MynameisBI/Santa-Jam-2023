local Hero = require 'src.components.hero'
local Timer = require 'src.components.timer'
local ProjectileEntity = require 'src.entities.bullets.projectileEntity'
local Entity = require 'src.entities.entity'

local HeroEntity = require 'src.entities.heroes.heroEntity'

local Alestra = Class('Alestra', HeroEntity)

Alestra.SKILL_DESCRIPTION = "Summon 6 waves of bullets each dealing 0.75 AD + 0.2 RP physical damage"

function Alestra:initialize(slot)
  Entity.initialize(self)

  HeroEntity.initialize(
    self, slot, Images.heroes.alestra, 'Alestra', 4, {'sentient', 'coordinator'},
    {
      [1] = Hero.Stats(90, 30, 1.0, 400, 0, 2),
      [2] = Hero.Stats(120, 40, 1.0, 400, 0, 2),
      [3] = Hero.Stats(160, 53, 1.0, 400, 0, 2),
      [4] = Hero.Stats(213, 71, 1.0, 400, 0, 2),
      [5] = Hero.Stats(284, 95, 1.0, 400, 0, 2),
      [6] = Hero.Stats(379, 126, 1.0, 400, 0, 2),
    },
    nil,
    Hero.Skill('Alestra', 140, 14, function(hero)
      local timer = hero:getEntity():getComponent('Timer').timer

      timer:every(0.15, function()
        for x = 0, 6 do 
          local dirX, dirY = Lume.vector(math.pi/4 + 0.15 - 0.05 * x, 1)
          local bullet = ProjectileEntity(hero, Images.pets.alestraBullet,
              {damageType = 'physical', attackDamageRatio = 0.75, realityPowerRatio = 0.2},
              240 + 45 * x, -40, 18, 18, dirX, dirY, 1000)
          Hump.Gamestate.current():addEntity(bullet)

          local dirX, dirY = Lume.vector(-math.pi/4 - 0.15 + 0.05 * x, 1)
          local bullet = ProjectileEntity(hero, Images.pets.alestraBullet,
              {damageType = 'physical', attackDamageRatio = 0.75, realityPowerRatio = 0.2},
              240 + 45 * x, love.graphics.getHeight() + 40, 18, 18, dirX, dirY, 1000)
          Hump.Gamestate.current():addEntity(bullet)
        end
      end, 6)
    end)
  )

  self:addComponent(Timer())

  local animator = self:getComponent('Animator')
  animator:setGrid(18, 18, Images.heroes.alestra:getWidth(), Images.heroes.alestra:getHeight())
  animator:addAnimation('idle', {'1-2', 1}, 0.65, true)
  animator:addAnimation('attack', {'3-6', 1}, {0.5, 0.5, 0.5, 0.5}, true, function()
    animator:setCurrentAnimationName('idle') 
  end)
  animator:setCurrentAnimationName('idle')
end

return Alestra