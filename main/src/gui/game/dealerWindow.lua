local TeamSynergy = require 'src.components.teamSynergy'
local Resources = require 'src.components.resources'
local HUD = require 'src.gui.game.hud'
local Hero = require 'src.components.hero'
local DrawSlot = require 'src.systems.drawSlot'
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
local TieredMods = {
  {
    require 'src.entities.mods.scrapPack',
    require 'src.entities.mods.psychePack',
    require 'src.entities.mods.bioPack',
  },
  {
    require 'src.entities.mods.harmonizerUnit',
    require 'src.entities.mods.quantumToken',
    require 'src.entities.mods.hullTransformer',
    require 'src.entities.mods.brainImplant',
    require 'src.entities.mods.syntheticCore',
    require 'src.entities.mods.noradInhaler',  
  },
  {
    require 'src.entities.mods.theConductor',
    require 'src.entities.mods.skaterayEqualizer',
    require 'src.entities.mods.radioPopper',
    require 'src.entities.mods.asymframeVisionary',
    require 'src.entities.mods.abovesSliver',
    require 'src.entities.mods.subcellularSupervisor',
    require 'src.entities.mods.neuralProcessor',
    require 'src.entities.mods.bionicColumn',
    require 'src.entities.mods.enhancerFumes',
    require 'src.entities.mods.deathsPromise',
  }
}

local DealerWindow = Class('DealerWindow')

function DealerWindow:initialize()
  self.isOpened = false
  self.isOn = false

  self.suit = Suit.new()

  self.items = {}
end

function DealerWindow:open(value)
  self.isOpened = true
  self.isOn = true

  if value == 1 then
    local tier1s = self:getHeroItems(1, 2, 3)
    local tier2s = self:getHeroItems(2, 1, 2)
    local tier3s = self:getHeroItems(3, 1)
    self.items = {
      tier1s[1], tier1s[2], tier1s[3], tier3s[1],
      tier2s[1], tier2s[2],
      self:getModItem(1), self:getModItem(1)
    }

    
  elseif value == 2 then
    local tier1s = self:getHeroItems(1, 2, 3)
    local tier2s = self:getHeroItems(2, 1, 2)
    local tier3s = self:getHeroItems(3, 1)
    self.items = {
      tier1s[1], tier1s[2], tier1s[3], tier3s[1],
      tier2s[1], tier2s[2],
      self:getModItem(1), self:getModItem(1)
    }

  elseif value == 3 then
    local tier1s = self:getHeroItems(1, 2, 3)
    local tier2s = self:getHeroItems(2, 1, 2)
    local tier3s = self:getHeroItems(3, 1)
    self.items = {
      tier1s[1], tier1s[2], tier1s[3], tier3s[1],
      tier2s[1], tier2s[2],
      self:getModItem(1), self:getModItem(1)
    }

  end
end

function DealerWindow:getHeroItems(tier, xpAmount, count)
  local count = count or 1

  local heroItems = {}

  local heroClasses = Lume.clone(TieredHeroes[tier])
  for i = 1, count do
    local rewardType, finalXpAmount

    local heroClass 
    while heroClass == nil do
      local toCheckHeroClass = Lume.randomchoice(heroClasses)
      local heroEntities = Hump.Gamestate.current():getEntitiesWithComponent('Hero')
      local heroEntityIndex = Lume.find(Lume.map(heroEntities, 'class'), toCheckHeroClass)

      if not heroEntityIndex then
        heroClass = toCheckHeroClass
        rewardType, finalXpAmount = 'unlock', 0

      else
        local heroEntity = heroEntities[heroEntityIndex]
        if not heroEntity:getComponent('Hero'):isMaxLevel() then
          heroClass = toCheckHeroClass
          rewardType, finalXpAmount = 'xp', xpAmount
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

    table.insert(heroItems, {
      heroObject = heroClass(),
      rewardType = rewardType,
      xpAmount = finalXpAmount,
      price = tier * xpAmount
    })
  end

  return heroItems
end

function DealerWindow:getModItem(tier)
  return {
    modEntity = Lume.randomchoice(TieredMods[tier])(),
    price = 4 * tier - tier + 1,
  }
end

function DealerWindow:close()
  self.isOpened = false
  self.isOn = false
  self.items = {}
end

function DealerWindow:update()

end

function DealerWindow:draw()
  if not self.isOpened then return end

  love.graphics.setColor(0.28, 0.28, 0.28, 0.5)
  love.graphics.rectangle('fill', 75, 60, love.graphics.getWidth() - 150, love.graphics.getHeight() - 120)
  
  if self.items[1] ~= 0 and self.suit:Button(self.items[1], {draw = self.drawHeroItem}, 100, 74, 286, 64).hit then
    self:buyHeroItem(self.items[1])
  end
  if self.items[2] ~= 0 and self.suit:Button(self.items[2], {draw = self.drawHeroItem}, 100, 176, 286, 64).hit then
    self:buyHeroItem(self.items[2])
  end
  if self.items[3] ~= 0 and self.suit:Button(self.items[3], {draw = self.drawHeroItem}, 100, 278, 286, 64).hit then
    self:buyHeroItem(self.items[3])
  end
  if self.items[4] ~= 0 and self.suit:Button(self.items[4], {draw = self.drawHeroItem}, 100, 380, 286, 64).hit then
    self:buyHeroItem(self.items[4])
  end
  if self.items[5] ~= 0 and self.suit:Button(self.items[5], {draw = self.drawHeroItem}, 425, 74, 286, 64).hit then
    self:buyHeroItem(self.items[5])
  end
  if self.items[6] ~= 0 and self.suit:Button(self.items[6], {draw = self.drawHeroItem}, 425, 176, 286, 64).hit then
    self:buyHeroItem(self.items[6])
  end

  if self.items[7] ~= 0 and self.suit:Button(self.items[7], {draw = self.drawModItem}, 425, 288, 208, 41).hit then
    self:buyModItem(self.items[7])
  end
  if self.items[8] ~= 0 and self.suit:Button(self.items[8], {draw = self.drawModItem}, 425, 378, 208, 41).hit then
    self:buyModItem(self.items[8])
  end
  

  if self.suit:Button('Close', 670, 424, 90, 36).hit then
    self:close()
  end

  self.suit:draw()
end

function DealerWindow.drawHeroItem(heroItem, opt, x, y, w, h)
  if opt.state == 'normal' then love.graphics.setColor(0.2, 0.2, 0.2)
  elseif opt.state == 'hovered' then love.graphics.setColor(0.19, 0.6, 0.73)
  elseif opt.state == 'active' then love.graphics.setColor(1, 0.6, 0)
  end
  love.graphics.rectangle('fill', x, y, w, h, 6, 6)

  local heroObject = heroItem.heroObject

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
  
  if heroItem.rewardType == 'unlock' then
    love.graphics.print('Unlock this Hero', x + 74, y + 43, 0, 1, 1,
        0, Fonts.medium:getHeight() / 2)

  elseif heroItem.rewardType == 'xp' then
    love.graphics.print('+ '..tostring(heroItem.xpAmount)..' XP', x + 74, y + 43, 0, 1, 1,
        0, Fonts.medium:getHeight() / 2)

  end

  -- Price
  love.graphics.setColor(Resources():getMoney() >= heroItem.price and {0.85, 0.85, 0.85} or {0.81, 0.34, 0.34})
  love.graphics.setFont(Fonts.medium)
  love.graphics.print(heroItem.price, x + w/2 - 6, y + h + 8, 0, 1, 1, Fonts.medium:getWidth(tostring(heroItem.price)))
  love.graphics.setColor(Resources():getMoney() >= heroItem.price and {1, 1, 1} or {0.95, 0.4, 0.4})
  love.graphics.draw(Images.icons.moneyIcon, x + w/2 - 2, y + h + 5, 0, 2, 2)

  -- Trait tooltip
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

function DealerWindow:buyHeroItem(heroItem)
  if not Resources():modifyMoney(-heroItem.price) then return end

  if heroItem.rewardType == 'unlock' then
    local emptyHeroSlots = Lume.filter(Hump.Gamestate.current():getComponents('DropSlot'),
        function(dropSlot) return dropSlot.slotType == 'bench' and dropSlot.draggable == nil end)

    if #emptyHeroSlots == 0 then
      emptyHeroSlots = Lume.filter(Hump.Gamestate.current():getComponents('DropSlot'),
          function(dropSlot) return dropSlot.slotType == 'team' and dropSlot.draggable == nil end)
    end

    local hero = heroItem.heroObject.class(emptyHeroSlots[1]:getEntity())
    hero:getComponent('Hero'):addExp(heroItem.xpAmount)

    Hump.Gamestate.current():addEntity(hero)

  elseif heroItem.rewardType == 'xp' then
    local heroes = Hump.Gamestate.current():getEntitiesWithComponent('Hero')
    for _, hero in ipairs(heroes) do
      if hero.class == heroItem.heroObject.class then
        hero:getComponent('Hero'):addExp(heroItem.xpAmount)
      end
    end
  end

  for i = 1, 6 do
    if self.items[i] == heroItem then
      self.items[i] = 0
      break
    end
  end
end

function DealerWindow.drawModItem(modItem, opt, x, y, w, h)
  if opt.state == 'normal' then love.graphics.setColor(0.2, 0.2, 0.2)
  elseif opt.state == 'hovered' then love.graphics.setColor(0.19, 0.6, 0.73)
  elseif opt.state == 'active' then love.graphics.setColor(1, 0.6, 0)
  end
  love.graphics.rectangle('fill', x, y, w, h, 6, 6)

  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(modItem.modEntity:getComponent('Sprite').image, x + 24, y + math.floor(h/2), 0, 2, 2, 6, 6)
  love.graphics.setColor(opt.state == 'normal' and {0.85, 0.85, 0.85} or {1, 1, 1})

  love.graphics.setFont(Fonts.medium)
  local name = modItem.modEntity:getComponent('Mod').name
  name = Fonts.medium:getWidth(name) < w - 50 and name or (function()
    return name:sub(1, 16)..'.'
  end)()
  love.graphics.print(name, x + 48, y + math.floor(h/2) + 1, 0, 1, 1,
      0, Fonts.medium:getHeight() / 2)

  -- Price
  love.graphics.setColor(Resources():getMoney() >= modItem.price and {0.85, 0.85, 0.85} or {0.81, 0.34, 0.34})
  love.graphics.setFont(Fonts.medium)
  love.graphics.print(modItem.price, x + w/2 - 10, y + h + 8, 0, 1, 1, Fonts.medium:getWidth(tostring(modItem.price)))
  love.graphics.setColor(Resources():getMoney() >= modItem.price and {1, 1, 1} or {0.95, 0.4, 0.4})
  love.graphics.draw(Images.icons.moneyIcon, x + w/2 - 6, y + h + 5, 0, 2, 2)
end

function DealerWindow:buyModItem(modItem)
  if not Resources():modifyMoney(-modItem.price) then return end

  local emptyModSlotEntity = DrawSlot.getEmptyModSlotEntity()
  modItem.modEntity:getComponent('Draggable'):setSlot(emptyModSlotEntity)
  Hump.Gamestate.current():addEntity(modItem.modEntity)

  for i = 7, 8 do
    if self.items[i] == modItem then
      self.items[i] = 0
      break
    end
  end
end

return DealerWindow