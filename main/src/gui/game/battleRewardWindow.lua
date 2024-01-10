local Resources = require 'src.components.resources'
local DrawSlot = require 'src.systems.drawSlot'
-- mods
local ModSlot = require 'src.entities.modSlot'
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

local BattleRewardWindow = Class('BattleRewardWindow')

function BattleRewardWindow:initialize()
  self.isOpened = false

  self.suit = Suit.new()

  self.battleRewards = {}
end

function BattleRewardWindow:open(round)
  if round.mainType == 'enemy' then
    if round.subType == '~1' then
      local reward1 = {rewardType = 'money', amount = math.random(6, 10)}
      local reward2 = {rewardType = 'mod', modEntity = Lume.randomchoice(TieredMods[3])()}
      local reward3 = {rewardType = 'hero', value = 1}
      self.battleRewards = {reward1, reward2, reward3}

    elseif round.subType == '~2' then

    elseif round.subType == 'A1' then
      
    elseif round.subType == 'A6' then
      
    elseif round.subType == 'A11' then

    elseif round.subType == 'B1' then

    elseif round.subType == 'B6' then

    elseif round.subType == 'B11' then

    elseif round.subType == 'C0' then

    elseif round.subType == 'C5' then

    elseif round.subType == 'C10' then

    end

  elseif round.mainType == 'elite' then
    if round.subType == 'a' then
      
    elseif round.subType == 'b' then

    elseif round.subType == 'A' then

    elseif round.subType == 'B' then

    elseif round.subType == 'C' then

    elseif round.subType == 'D' then

    elseif round.subType == 'E' then      

    elseif round.subType == 'F' then

    end

  end
  self.isOpened = true
end

function BattleRewardWindow:close()
  self.isOpened = false
end


function BattleRewardWindow:update(dt)
  
end

function BattleRewardWindow:draw()
  if not self.isOpened then return end

  love.graphics.setColor(0, 0, 0, 0.5)
  love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

  love.graphics.setColor(78/255, 84/255, 88/255)
  love.graphics.rectangle('fill', 307, 120, 246, 314)

  love.graphics.setColor(96/255, 102/255, 107/255)
  love.graphics.rectangle('fill', 274, 85, 313, 50)

  love.graphics.setColor(0.9, 0.915, 0.93)
  love.graphics.setFont(Fonts.big)
  love.graphics.printf('Battle rewards', 274, 112 - Fonts.big:getHeight() / 2, 313, 'center', 0)

  local padding, buttonH = 14, 41
  self.suit.layout:reset(326, 154 + (#self.battleRewards-1) * (padding + buttonH))
  self.suit.layout:padding(padding)
  for i = #self.battleRewards, 1, -1 do
    local reward = self.battleRewards[i]
    if self.suit:Button(reward.rewardType,
        {id = 'Reward '..tostring(i), draw = self.drawBattleReward, amount = reward.amount, modEntity = reward.modEntity},
        self.suit.layout:up(208, buttonH)).hit then

      if reward.rewardType == 'money' then
        Resources():modifyMoney(reward.amount)

      elseif reward.rewardType == 'mod' then
        local emptyModSlotEntity = DrawSlot.getEmptyModSlotEntity()
        reward.modEntity:getComponent('Draggable'):setSlot(emptyModSlotEntity)
        Hump.Gamestate.current():addEntity(reward.modEntity)

      elseif reward.rewardType == 'hero' then
        Hump.Gamestate.current().guis[3]:open(reward.value)
      end
      
      table.remove(self.battleRewards, i)
      if #self.battleRewards == 0 then
        self:close()
      end
    end
  end

  self.suit:draw()
end

function BattleRewardWindow.drawBattleReward(rewardType, opt, x, y, w, h)
  -- self.suit:Button(Images.icons[self.teamSynergy.synergies[i].trait..'Icon'],
  -- {id = id, hud = self, synergy = self.teamSynergy.synergies[i], synergyIndex = i,
  --     draw = self.drawSynergy, topX = topX, topY = topY},

  if opt.state == 'normal' then
    love.graphics.setColor(0.25, 0.25, 0.25)
  elseif opt.state == 'hovered' then
    love.graphics.setColor(0.19, 0.6, 0.73)
  elseif opt.state == 'active' then
    love.graphics.setColor(1, 0.6, 0)
  end
  love.graphics.rectangle('fill', x, y, w, h, 6, 6)

  if rewardType == 'money' then
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(Images.icons.moneyIcon, x + 26, y + math.floor(h/2), 0, 2, 2, 5, 5)

    love.graphics.setColor(opt.state == 'normal' and {0.85, 0.85, 0.85} or {1, 1, 1})
    love.graphics.setFont(Fonts.medium)
    love.graphics.print(tostring(opt.amount)..' Money', x + 48, y + math.floor(h/2) + 1, 0, 1, 1,
        0, Fonts.medium:getHeight() / 2)

  elseif rewardType == 'mod' then
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(opt.modEntity:getComponent('Sprite').image, x + 24, y + math.floor(h/2), 0, 2, 2, 6, 6)
    love.graphics.setColor(opt.state == 'normal' and {0.85, 0.85, 0.85} or {1, 1, 1})

    love.graphics.setFont(Fonts.medium)
    local name = opt.modEntity:getComponent('Mod').name
    name = Fonts.medium:getWidth(name) < w - 50 and name or (function()
      return name:sub(1, 16)..'.'
    end)()
    love.graphics.print(name, x + 48, y + math.floor(h/2) + 1, 0, 1, 1,
        0, Fonts.medium:getHeight() / 2)

  elseif rewardType == 'hero' then
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(Images.icons.heroIcon, x + 26, y + math.floor(h/2), 0, 2, 2, 5, 5)

    love.graphics.setColor(opt.state == 'normal' and {0.85, 0.85, 0.85} or {1, 1, 1})
    love.graphics.setFont(Fonts.medium)
    love.graphics.print('Choose a Hero', x + 48, y + math.floor(h/2) + 1, 0, 1, 1,
        0, Fonts.medium:getHeight() / 2)
  end
end

return BattleRewardWindow