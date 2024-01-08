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
    
  elseif value == 2 then

  elseif value == 3 then

  end
end

function DealerWindow:getItem(itemType, value)
  if itemType == 'hero' then
    if value == 2 then

    elseif value == 3 then

    elseif value == 4 then

    elseif value == 5 then

    elseif value == 6 then

    end


  elseif itemType == 'mod' then

  end
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

  love.graphics.setColor(0.2, 0.2, 0.2, 0.5)
  love.graphics.rectangle('fill', 75, 75, love.graphics.getWidth() - 150, love.graphics.getHeight() - 150)
  
  
end

function DealerWindow.drawItem()

end

return DealerWindow