local Hero = require 'src.components.hero'
local HeroEntity = require 'src.entities.heroes.heroEntity'
local AllyStats = require 'src.type.allyStats'
local TeamSynergy = require 'src.components.teamSynergy'
local Transform = require 'src.components.transform'
local Rectangle = require 'src.components.rectangle'
local Timer = require 'src.components.timer'
local Resources = require 'src.components.resources'
local AudioManager = require 'src.components.audioManager'

local Entity = require 'src.entities.entity'

local Tom = Class('Tom', HeroEntity)

Tom.SKILL_DESCRIPTION = "Tom switch his music to the next phase\nPink phase: Tom gives his team 0.035 RP bonus attack speed\nPurple phase: Tom gives his team 0.5 RP bonus reality power\nBlue phase: Upon reaching this phase, your team gains 15 style"

local COLORS = {
  pink = {241/255, 135/255, 180/255, 0.75},
  purple = {173/255, 150/255, 230/255, 0.75},
  blue = {103/255, 177/255, 250/255, 0.75}
}

function Tom:initialize(slot)
  Entity.initialize(self)

  HeroEntity.initialize(
    self, slot, Images.heroes.tom, 'Tom', 4, {'bigEar', 'droneMaestro'},
    {
      [1] = Hero.Stats(0, 80, 1, 0, 0, 2),
      [2] = Hero.Stats(0, 107, 1, 0, 0, 2),
      [3] = Hero.Stats(0, 142, 1, 0, 0, 2),
      [4] = Hero.Stats(0, 190, 1, 0, 0, 2),
      [5] = Hero.Stats(0, 253, 1, 0, 0, 2),
      [6] = Hero.Stats(0, 337, 1, 0, 0, 2),
    },
    nil,
    Hero.Skill('Tom', 50, 5, function(hero)
      if hero.currentMusicPhase == 'pink' then
        hero.currentMusicPhase = 'purple'
      elseif hero.currentMusicPhase == 'purple' then
        hero.currentMusicPhase = 'blue'
      elseif hero.currentMusicPhase == 'blue' then
        hero.currentMusicPhase = 'pink'
      end

      hero:getEntity():getComponent('Animator'):setCurrentAnimationName('switchMusic')

      local musicStats = hero:getCurrentMusicPhaseStats()
      musicStats.isMusic = true
      hero:removeTeamMusicStats(TeamSynergy():getHeroComponentsInTeam())
      hero:addTeamMusicStats(TeamSynergy():getHeroComponentsInTeam(), musicStats)

      local transform = hero.aura:getComponent('Transform')
      local timer = hero.aura:getComponent('Timer')
      local rectangle = hero.aura:getComponent('Rectangle')
      rectangle.spinSpeed = 0
      if timer.tomHandles then
        for k, tomHandle in ipairs(timer.tomHandles) do
          timer.timer:cancel(timer.tomHandles[k])
        end
      end
      timer.tomHandles = {}
      timer.tomHandles[1] = timer.timer:tween(0.2, transform, {sx = 20, sy = 20, ox = 10, oy = 10}, 'linear', function()
        if hero.currentMusicPhase == 'blue' then
          Resources():modifyStyle(15 + math.random(-3, 3))
        end

        rectangle.color = COLORS[hero.currentMusicPhase]
        transform.sx, transform.sy, transform.ox, transform.oy = 50, 50, 25, 25
        timer.tomHandles[2] = timer.timer:tween(0.9, transform, {sx = 30, sy = 30, ox = 15, oy = 15}, 'out-in-elastic', nil)
        rectangle.spinSpeed, rectangle.lineWidth = 7.5, 4
        timer.tomHandles[3] = timer.timer:tween(0.9, rectangle, {spinSpeed = 2.5, lineWidth = 2}, 'cubic')

        local effect = Entity()
        local x, y = transform:getGlobalPosition()
        local eTransform = effect:addComponent(Transform(x, y, math.pi/4, 0, 0, 0))
        local eRectangle = effect:addComponent(Rectangle('line', Lume.clone(COLORS[hero.currentMusicPhase]), 4, 16))
        eRectangle.update = function(rect, dt) eTransform.r = transform.r end
        local eTimer = effect:addComponent(Timer())
        eTimer.timer:tween(0.75, eTransform, {sx = 100, sy = 100, ox = 50, oy = 50}, 'out-cubic')
        eTimer.timer:tween(0.75, eRectangle.color, {[4] = 0}, 'linear', function()
          Hump.Gamestate.current():removeEntity(effect)
        end)
        Hump.Gamestate.current():addEntity(effect)
      end)
    end)
  )


  local hero = self:getComponent('Hero')
  hero.secondsUntilAttackReady = math.huge
  hero.currentMusicPhase = 'pink'

  hero.onBattleStart = function(hero, isInTeam, teamHeroes)
    if not isInTeam then return end

    local musicStats = hero:getCurrentMusicPhaseStats()
    musicStats.isMusic = true

    hero:removeTeamMusicStats(teamHeroes)
    hero:addTeamMusicStats(teamHeroes, musicStats)
  end

  hero.onBattleEnd = function(hero, isInTeam, teamHeroes)
    if not isInTeam then return end
    hero:removeTeamMusicStats(teamHeroes)
  end

  hero.getCurrentMusicPhaseStats = function(hero)
    local stats = hero:getStats()
    if hero.currentMusicPhase == 'pink' then
      return AllyStats(0, 0, stats.realityPower * 0.0035, 0, 0, 0, 0, 0)
    elseif hero.currentMusicPhase == 'purple' then
      return AllyStats(0, stats.realityPower * 0.5, 0, 0, 0, 0, 0, 0)
    elseif hero.currentMusicPhase == 'blue' then
      return AllyStats(0, 0, 0, 0, 0, 0, 0, 0)
    end
  end

  hero.removeTeamMusicStats = function(hero, teamHeroes)
    for _, teamHero in ipairs(teamHeroes) do
      for i = #teamHero.temporaryModifierStatses, 1, -1 do
        if teamHero.temporaryModifierStatses[i].isMusic then
          table.remove(teamHero.temporaryModifierStatses, i)
        end
      end
    end
  end

  hero.addTeamMusicStats = function(hero, teamHeroes, stats)
    for _, teamHero in ipairs(teamHeroes) do
      teamHero:addTemporaryModifierStats(stats, math.huge)
    end
  end


  local aura = Entity()
  hero.aura = aura
  local transform = aura:addComponent(Transform(20, 32, 0, 30, 30, 15, 15))
  transform:setParent(self:getComponent('Transform'))
  rectangle = aura:addComponent(Rectangle('line', COLORS.pink, 2, 8))
  rectangle.spinSpeed = 2.5
  rectangle.update = function(rectangle, dt)
    transform.r = transform.r + dt * rectangle.spinSpeed
  end
  timer = aura:addComponent(Timer())
  -- Hump.Gamestate.current():addEntity(aura)


  local animator = self:getComponent('Animator')
  animator:setGrid(18, 18, Images.heroes.tom:getWidth(), Images.heroes.tom:getHeight())
  animator:addAnimation('idle', {'1-2', 1}, 0.2, true)
  animator:addAnimation('switchMusic', {'3-7', 1}, {0.2, 0.125, 0.75, 0.075, 0.2}, true, function()
    animator:setCurrentAnimationName('idle')  
  end)
  animator:setCurrentAnimationName('idle')
end

return Tom