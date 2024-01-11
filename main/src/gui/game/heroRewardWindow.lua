local TeamSynergy = require 'src.components.teamSynergy'
local Resources = require 'src.components.resources'
local HUD = require 'src.gui.game.hud'
local Hero = require 'src.components.hero'
-- uh
local TieredHeroes = {
  {
    require 'src.entities.heroes.cole',
    require 'src.entities.heroes.raylee',
    require 'src.entities.heroes.brunnos',
    require 'src.entities.heroes.keon',
    require 'src.entities.heroes.cloud'
  },
  {
    require 'src.entities.heroes.kori',
    require 'src.entities.heroes.soniya',
    require 'src.entities.heroes.nathanael',
    require 'src.entities.heroes.aurora'
  },
  {
    require 'src.entities.heroes.brae',
    require 'src.entities.heroes.rover',
    require 'src.entities.heroes.sasami',
    require 'src.entities.heroes.hakiko'
  },
  {
    require 'src.entities.heroes.tom',
    require 'src.entities.heroes.alestra',
    require 'src.entities.heroes.skott',
  }
}

local HeroRewardWindow = Class('HeroRewardWindow')

local STANDARD_WEIGHTS = {
  {10, 0, 0, 0},
  {6, 4, 0, 0},
  {5, 2.5, 2.5, 0},
  {4, 3, 1, 2},
  {3, 2, 3, 2},
  {2, 3, 3, 2},
}

local STANDARD_ADDITIONAL_WEIGHTS = {
  {8, 0, -1, -1},
  {5, 2, 0, -1},
  {3, 3, 0, 0},
  {0, 4, 2, 0},
  {0, 2, 3, 1},
  {0, 1, 3, 2},
  {-1, 0, 4, 3},
  {-2, -1, 5, 4},
}

function HeroRewardWindow:initialize()
  self.isOpened = false
  self.isOn = false

  self.suit = Suit.new()

  self.heroRewards = {}
end

function HeroRewardWindow:open(value)
  local heroes = Hump.Gamestate.current():getComponents('Hero')

  local value = 3

  -- choose 3 hero
  -- for each hero, check if they're on the map or not
  -- if not on then add unlock hero reward
  -- if on then add xp hero reward
  self.heroRewards = {}

  local weights = STANDARD_WEIGHTS[value]
  local additionalWeights = self:getAdditionalWeights(Resources():getStyle())
  local totalWeights = {}
  for i = 1, 4 do
    totalWeights[i] = math.max(weights[i] + additionalWeights[i], 0)
  end
  -- print(('W: %d %d %d %d\t'):format(unpack(weights)))
  -- print(('A: %d %d %d %d\t'):format(unpack(additionalWeights)))
  -- print(('T: %d %d %d %d\t'):format(unpack(totalWeights)))
  -- print()
  local rewardTier = Lume.weightedchoice(totalWeights)

  local heroClasses = Lume.clone(TieredHeroes[rewardTier])  
  for i = 1, 3 do
    local rewardType, xpAmount

    local heroClass 
    while heroClass == nil do
      local toCheckHeroClass = Lume.randomchoice(heroClasses)
      local heroEntities = Hump.Gamestate.current():getEntitiesWithComponent('Hero')
      local heroEntityIndex = Lume.find(Lume.map(heroEntities, 'class'), toCheckHeroClass)

      if not heroEntityIndex then
        heroClass = toCheckHeroClass
        rewardType, xpAmount = 'unlock', 0

      else
        local heroEntity = heroEntities[heroEntityIndex]
        if not heroEntity:getComponent('Hero'):isMaxLevel() then
          heroClass = toCheckHeroClass
          rewardType, xpAmount = 'xp', math.max(Lume.round(value / rewardTier), 1)
        else
          for i, v in ipairs(heroClasses) do
            if v == toCheckHeroClass then table.remove(heroClasses, i) end
          end      
        end
      end
    end

    for i, v in ipairs(heroClasses) do
      if v == heroClass then table.remove(heroClasses, i) end
    end

    table.insert(self.heroRewards, {
      heroObject = heroClass(),
      rewardType = rewardType,
      xpAmount = xpAmount
    })
  end

  self.isOpened = true
  self.isOn = true
end

function HeroRewardWindow:getAdditionalWeights(style)
  local weights = {}

  local styleLerpAmount = style
  local styleMark = 1
  while styleLerpAmount > 100 and styleMark < #STANDARD_ADDITIONAL_WEIGHTS do
    styleLerpAmount = styleLerpAmount - 100
    styleMark = styleMark + 1
  end
  
  if styleMark < #STANDARD_ADDITIONAL_WEIGHTS then
    local additionalWeights = {}
    for tier = 1, 4 do
      additionalWeights[tier] = Lume.lerp(
        STANDARD_ADDITIONAL_WEIGHTS[styleMark][tier],
        STANDARD_ADDITIONAL_WEIGHTS[styleMark+1][tier],
        styleLerpAmount / 100
      )
    end
    return additionalWeights
  else
    return {
      STANDARD_ADDITIONAL_WEIGHTS[#STANDARD_ADDITIONAL_WEIGHTS][1],
      STANDARD_ADDITIONAL_WEIGHTS[#STANDARD_ADDITIONAL_WEIGHTS][2],
      STANDARD_ADDITIONAL_WEIGHTS[#STANDARD_ADDITIONAL_WEIGHTS][3],
      STANDARD_ADDITIONAL_WEIGHTS[#STANDARD_ADDITIONAL_WEIGHTS][4],
    }
  end
end

function HeroRewardWindow:close()
  self.isOpened = false
  self.isOn = false
  self.heroRewards = {}
end

function HeroRewardWindow:update(dt)
  
end

function HeroRewardWindow:draw()
  if not self.isOpened then return end

  if self.isOn then
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setColor(96/255, 102/255, 107/255)
    love.graphics.rectangle('fill', 251, 81, 359, 64)

    love.graphics.setColor(0.9, 0.915, 0.93)
    love.graphics.setFont(Fonts.big)
    love.graphics.printf('Choose a Hero', 251, 112 - Fonts.big:getHeight() / 2, 359, 'center', 0)

    self.suit.layout:reset(287, 172)
    self.suit.layout:padding(20)
    for i = 1, #self.heroRewards do
      local reward = self.heroRewards[i]
      if self.suit:Button(reward, {draw = self.drawHeroReward}, self.suit.layout:row(286, 64)).hit then
        if reward.rewardType == 'unlock' then
          local emptyHeroSlots = Lume.filter(Hump.Gamestate.current():getComponents('DropSlot'),
              function(dropSlot) return dropSlot.slotType == 'bench' and dropSlot.draggable == nil end)

          if #emptyHeroSlots == 0 then
            emptyHeroSlots = Lume.filter(Hump.Gamestate.current():getComponents('DropSlot'),
                function(dropSlot) return dropSlot.slotType == 'team' and dropSlot.draggable == nil end)
          end

          local hero = reward.heroObject.class(emptyHeroSlots[1]:getEntity())
          hero:getComponent('Hero'):addExp(reward.xpAmount)

          Hump.Gamestate.current():addEntity(hero)

        elseif reward.rewardType == 'xp' then
          local heroes = Hump.Gamestate.current():getEntitiesWithComponent('Hero')
          for _, hero in ipairs(heroes) do
            if hero.class == reward.heroObject.class then
              hero:getComponent('Hero'):addExp(reward.xpAmount)
            end
          end
        end

        self:close()
        break
      end
    end

    love.graphics.setFont(Fonts.medium)
    if self.suit:Button('View team', 340, 425, 180, 40).hit then
      self.isOn = false
    end

  else
    love.graphics.setFont(Fonts.medium)
    if self.suit:Button('Back', 340, 425, 180, 40).hit then
      self.isOn = true
    end

  end


  self.suit:draw()
end

function HeroRewardWindow.drawHeroReward(reward, opt, x, y, w, h)
  if opt.state == 'normal' then
    love.graphics.setColor(0.25, 0.25, 0.25)
  elseif opt.state == 'hovered' then
    love.graphics.setColor(0.19, 0.6, 0.73)
  elseif opt.state == 'active' then
    love.graphics.setColor(1, 0.6, 0)
  end
  love.graphics.rectangle('fill', x, y, w, h, 6, 6)


  local heroObject = reward.heroObject
  
  local inspectable = heroObject:getComponent('Inspectable')
  inspectable:entityadded()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(inspectable.image, inspectable.quad, x + 16, y + 11, 0, 3, 3)
    
  -- love.graphics.setColor(opt.state == 'normal' and {0.85, 0.85, 0.85} or {1, 1, 1})
  local color = Lume.clone(Hero.TIER_COLORS[heroObject:getComponent('Hero').tier])
  love.graphics.setColor(opt.state == 'normal' and color or
      {color[1] + 0.1, color[2] + 0.1, color[3] + 0.1})
  love.graphics.setFont(Fonts.medium)
  love.graphics.print(heroObject:getComponent('Hero').name, x + 74, y + 22, 0, 1, 1,
      0, Fonts.medium:getHeight() / 2)
  
  if reward.rewardType == 'unlock' then
    love.graphics.print('Unlock this Hero', x + 74, y + 43, 0, 1, 1,
        0, Fonts.medium:getHeight() / 2)

  elseif reward.rewardType == 'xp' then
    love.graphics.print('+ '..tostring(reward.xpAmount)..' XP', x + 74, y + 43, 0, 1, 1,
        0, Fonts.medium:getHeight() / 2)

  end


  if opt.state == 'hovered' then
    local hero = heroObject:getComponent('Hero')

    love.graphics.setColor(0.2, 0.2, 0.2, 0.6)
    love.graphics.rectangle('fill', x + w + 10, y + h/2 - 8 - #hero.traits * 18 / 2,
        165, 16 + #hero.traits * 18)
    
    for i = 1, #hero.traits do
      local y = y + h/2 - 18 * #hero.traits / 2 + 2

      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(Images.icons[hero.traits[i]..'Icon'], x + w + 20, y + 1 + (i-1) * 18)

      love.graphics.setColor(0.8, 0.8, 0.8)
      love.graphics.setFont(Fonts.medium)
      love.graphics.print(HUD.TRAIT_DESCRIPTIONS[hero.traits[i]].title, x + w + 38, y + (i-1) * 18)
    end
  end
end

return HeroRewardWindow