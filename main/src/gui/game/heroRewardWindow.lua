local TeamSynergy = require 'src.components.teamSynergy'
local Resources = require 'src.components.resources'
-- uh
local Tier1 = {
  require 'src.entities.heroes.cole',
  require 'src.entities.heroes.raylee',
  require 'src.entities.heroes.brunnos',
  require 'src.entities.heroes.keon',
  require 'src.entities.heroes.cloud'
}
local Tier2 = {
  require 'src.entities.heroes.kori',
  require 'src.entities.heroes.soniya',
  require 'src.entities.heroes.nathanael',
  require 'src.entities.heroes.aurora'
}
local Tier3 = {
  require 'src.entities.heroes.brae',
  require 'src.entities.heroes.rover',
  require 'src.entities.heroes.sasami',
  require 'src.entities.heroes.hakiko'
}
local Tier4 = {
  require 'src.entities.heroes.tom',
  require 'src.entities.heroes.alestra',
  require 'src.entities.heroes.skott',
}

local HeroRewardWindow = Class('HeroRewardWindow')

function HeroRewardWindow:initialize()
  self.isOpened = false

  self.suit = Suit.new()

  self.heroRewards = {}
end

function HeroRewardWindow:open(value)
  local heroes = Hump.Gamestate.current():getComponents('Hero')

  if value == 1 then
    -- choose 3 hero
    -- for each hero, check if they're on the map or not
    -- if not on then add unlock hero reward
    -- if on then add xp hero reward
    self.heroRewards = {}

    local heroClasses = Lume.clone(Tier1)
    for i = 1, 3 do
      local heroClass = Lume.randomchoice(heroClasses)
      for i, v in ipairs(heroClasses) do
        if v == heroClass then table.remove(heroClasses, i) end
      end

      local rewardType = 'unlock'
      local xpAmount = 0
      if Lume.find(Lume.map(Hump.Gamestate.current():getEntitiesWithComponent('Hero'), 'class'), heroClass) then
        rewardType = 'xp'
        xpAmount = 1
      end

      table.insert(self.heroRewards, {
        heroClass = heroClass,
        rewardType = rewardType,
        xpAmount = xpAmount
      })
    end

  elseif value == 2 then

  elseif value == 3 then

  elseif value == 4 then

  elseif value == 5 then

  elseif value == 6 then

  else
    assert(false, 'Invalid hero reward value')
  end

  self.isOpened = true
end

function HeroRewardWindow:close()
  self.isOpened = false
  self.heroRewards = {}
end

function HeroRewardWindow:update(dt)
  
end

function HeroRewardWindow:draw()
  if not self.isOpened then return end

  love.graphics.setColor(0, 0, 0, 0.4)
  love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

  love.graphics.setColor(106/255, 112/255, 117/255)
  love.graphics.rectangle('fill', 271, 91, 319, 44)

  self.suit.layout:reset(307, 160)
  self.suit.layout:padding(14)
  for i = 1, #self.heroRewards do
    local reward = self.heroRewards[i]
    if self.suit:Button(tostring(reward.heroClass), self.suit.layout:row(246, 54)).hit then
      if reward.rewardType == 'unlock' then
        local emptyHeroSlots = Lume.filter(Hump.Gamestate.current():getComponents('DropSlot'),
            function(dropSlot) return dropSlot.slotType == 'bench' and dropSlot.draggable == nil end)

        if #emptyHeroSlots == 0 then
          emptyHeroSlots = Lume.filter(Hump.Gamestate.current():getComponents('DropSlot'),
              function(dropSlot) return dropSlot.slotType == 'team' and dropSlot.draggable == nil end)
        end

        local hero = reward.heroClass(emptyHeroSlots[1]:getEntity())
        hero:getComponent('Hero'):addExp(reward.xpAmount)

        Hump.Gamestate.current():addEntity(hero)

      elseif reward.rewardType == 'xp' then
        local heroes = Hump.Gamestate.current():getEntitiesWithComponent('Hero')
        for _, hero in ipairs(heroes) do
          if hero.class == reward.heroClass then
            hero:getComponent('Hero'):addExp(reward.xpAmount)
          end
        end
      end

      self:close()
      break
    end
  end

  self.suit:draw()
end

return HeroRewardWindow