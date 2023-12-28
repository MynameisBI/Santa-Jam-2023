local TeamSynergy = require 'src.components.teamSynergy'
local Resources = require 'src.components.resources'
-- uh
local Tier1 = {
  Cole = require 'src.entities.heroes.cole',
  Raylee = require 'src.entities.heroes.raylee',
  Brunnos = require 'src.entities.heroes.brunnos',
  Keon = require 'src.entities.heroes.keon',
  Cloud = require 'src.entities.heroes.cloud'
}
local Tier2 = {
  Kori = require 'src.entities.heroes.kori',
  Soniya = require 'src.entities.heroes.soniya',
  Nathanael = require 'src.entities.heroes.nathanael',
  Aurora = require 'src.entities.heroes.aurora'
}
local Tier3 = {
  Brae = require 'src.entities.heroes.brae',
  Rover = require 'src.entities.heroes.rover',
  Sasami = require 'src.entities.heroes.sasami',
  Hakiko = require 'src.entities.heroes.hakiko'
}
local Tier4 = {
  Tom = require 'src.entities.heroes.tom',
  Alestra = require 'src.entities.heroes.alestra',
  Skott = require 'src.entities.heroes.skott',
}

local HeroRewardWindow = Class('HeroRewardWindow')

function HeroRewardWindow:initialize()
  self.isOpened = false

  self.suit = Suit.new()

  self.heroRewards = {}
end

function HeroRewardWindow:open(value)
  if value == 1 then

  elseif value == 2 then

  elseif value == 3 then

  elseif value == 4 then

  elseif value == 5 then

  elseif value == 6 then

  end
  self.heroRewards = {{}, {}, {}}
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
    if self.suit:Button('Reward '..tostring(i), self.suit.layout:row(246, 54)).hit then
      self:close()
    end
  end

  self.suit:draw()
end

return HeroRewardWindow