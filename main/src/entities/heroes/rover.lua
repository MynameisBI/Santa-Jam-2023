local Hero = require 'src.components.hero'
local HeroEntity = require 'src.entities.heroes.heroEntity'
local AllyStats = require 'src.type.allyStats'
local AreaSkillEntity = require 'src.entities.skills.areaSkillEntity'
local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'

local Entity = require 'src.entities.entity'

local Rover = Class('Rover', HeroEntity)

Rover.SKILL_DESCRIPTION = "Enter a frenzy for 6s\nFrenzy: Basic attacks ignore 50% physical armor. Every third basic attack deal bonus 0.25 RP physical damage and slash in an arc"

function Rover:initialize(slot)
  Entity.initialize(self)

  HeroEntity.initialize(
    self, slot, Images.heroes.rover, 'Rover', 3, {'bigEar', 'trailblazer'},
    {
      [1] = Hero.Stats(40, 30, 3.0, 300, 0, 2),
      [2] = Hero.Stats(60, 45, 3.0, 300, 0, 2),
      [3] = Hero.Stats(90, 68, 3.0, 300, 0, 2),
      [4] = Hero.Stats(135, 101, 3.0, 300, 0, 2)
    },
    nil,
    Hero.Skill('Rover', 30, 15, function(hero)
      hero.secondsUntilEndFrenzy = 6

      local frenzyStats = hero.class.Stats(0, 0, 0, 0, 0, 0, 0, 0, 0.5, 0)
      frenzyStats.isFrenzy = true
      for i = #hero.temporaryModifierStatses, 1, -1 do
        if hero.temporaryModifierStatses[i].isFrenzy then
          table.remove(hero.temporaryModifierStatses, i)
        end
      end
      hero:addTemporaryModifierStats(frenzyStats, 5)
    end
    ),
    2, 0
  )

  local hero = self:getComponent('Hero')
  hero.secondsUntilEndFrenzy = 0
  hero.frenzyAttackCount = 0
  hero.onUpdate = function(hero, dt)
    hero.secondsUntilEndFrenzy = hero.secondsUntilEndFrenzy - dt
  end
  hero.onBasicAttack = function(hero, enemyEntity)
    local x, y = enemyEntity:getComponent('Transform'):getGlobalPosition()
    if hero.secondsUntilEndFrenzy > 0 then
      hero.frenzyAttackCount = hero.frenzyAttackCount + 1
      if hero.frenzyAttackCount == 3 then
        hero.frenzyAttackCount = 0 

        local x, y = x + 18, y + 18
        Hump.Gamestate.current():addEntity(AreaSkillEntity(hero, {x = x, y = y}, 60, 60,
            {damageType = 'physical', attackDamageRatio = 1, realityDamageRatio = 0.5,
            armorIgnoreRatio = 0.5, canCrit = true}, 0))
        
        local effect = Entity()
        effect:addComponent(Transform(x, y, 0, 2, 2, 6, 15))
        effect:addComponent(Sprite(Images.effects.roverSlash, 16, 'fade', 8, function()
            Hump.Gamestate.current():removeEntity(effect)
        end))
        Hump.Gamestate.current():addEntity(effect)

        return false
      end
    end
    return true
  end

  local animator = self:getComponent('Animator')
  animator:setGrid(18, 18, Images.heroes.rover:getWidth(), Images.heroes.rover:getHeight())
  animator:addAnimation('idle', {'1-4', 1}, 0.25, true)
  animator:addAnimation('attack', {'5-7', 1}, {0.075, 0.075, 0.075, 0.075, 0.075}, true)
  animator:setCurrentAnimationName('idle')
end

return Rover