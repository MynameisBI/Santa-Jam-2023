local HeroRewardWindow = Class('HeroRewardWindow')

function HeroRewardWindow:initialize()
  self.isOpened = false

  self.suit = Suit.new()

  self.heroRewards = {}
end

function HeroRewardWindow:open()
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