local Resources = require 'src.components.resources'

local BattleRewardWindow = Class('BattleRewardWindow')

function BattleRewardWindow:initialize()
  self.isOpened = false

  self.suit = Suit.new()

  self.battleRewards = {}
end

function BattleRewardWindow:open(round)
  self.battleRewards = {}

  if round.mainType == 'enemy' then
    if round.subType == '~1' then
      local reward1 = {rewardType = 'money', amount = math.random(6, 10)}
      reward1.text = tostring(reward1.amount)..' money'

      local reward2 = {rewardType = 'hero', value = 1}
      reward2.text = 'Choose a hero reward'
      
      local reward3 = {rewardType = 'hero', value = 1}
      reward3.text = 'Choose a hero reward'

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

  love.graphics.setColor(0, 0, 0, 0.4)
  love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

  love.graphics.setColor(78/255, 84/255, 88/255)
  love.graphics.rectangle('fill', 327, 120, 206, 264)

  love.graphics.setColor(106/255, 112/255, 117/255)
  love.graphics.rectangle('fill', 294, 91, 273, 44)

  local padding, buttonH = 9, 36
  self.suit.layout:reset(341, 154 + (#self.battleRewards-1) * (padding + buttonH))
  self.suit.layout:padding(padding)
  for i = #self.battleRewards, 1, -1 do
    if self.suit:Button(self.battleRewards[i].text, {id = 'Reward '..tostring(i)},
        self.suit.layout:up(178, buttonH)).hit then

      if self.battleRewards[i].rewardType == 'money' then
        Resources():modifyMoney(self.battleRewards[i].amount)
      elseif self.battleRewards[i].rewardType == 'mod' then
        
      elseif self.battleRewards[i].rewardType == 'hero' then
        Hump.Gamestate.current().guis[3]:open(self.battleRewards[i].value)
      end
      
      table.remove(self.battleRewards, i)
      if #self.battleRewards == 0 then
        self:close()
      end
    end
  end

  self.suit:draw()
end

return BattleRewardWindow