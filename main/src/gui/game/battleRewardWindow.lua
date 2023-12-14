local BattleRewardWindow = Class('BattleRewardWindow')

function BattleRewardWindow:initialize()
  self.isOpened = false

  self.suit = Suit.new()

  self.battleRewards = {}
end

function BattleRewardWindow:open()
  self.battleRewards = {{}, {}, {}, {}, {}}
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
    if self.suit:Button(self.battleRewards.text or '', {id = 'Reward '..tostring(i)},
        self.suit.layout:up(178, buttonH)).hit then
      Hump.Gamestate.current().guis[3]:open()
      table.remove(self.battleRewards, i)
      if #self.battleRewards == 0 then
        self:close()
      end
    end
  end

  self.suit:draw()
end

return BattleRewardWindow