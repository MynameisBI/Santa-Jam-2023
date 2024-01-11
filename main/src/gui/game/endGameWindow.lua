local EndGameWindow = Class('EndGameWindow')

function EndGameWindow:initialize()
  self.result = nil
  self.timer = Hump.Timer()

  self.backgroundOpacity = 0
end

function EndGameWindow:open(result)
  self.result = result

  self.timer:tween(1, self, {backgroundOpacity = 0.75}, 'linear')

  -- if result == 'won' then

  -- elseif result == 'lost' then

  -- end
end

function EndGameWindow:update(dt)
  if self.result == nil then return end

  self.timer:update(dt)
end

function EndGameWindow:draw()
  if self.result == nil then return end

  love.graphics.setColor(0.1, 0.1, 0.1, self.backgroundOpacity)
  love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

  if self.result == 'won' then
    love.graphics.setColor(1, 1, 1, self.backgroundOpacity)
    love.graphics.print('YOU WIN', Fonts.large, love.graphics.getWidth()/2, love.graphics.getHeight()/2, 0, 1, 1,
        Fonts.large:getWidth('YOU WIN')/2, Fonts.large:getHeight()/2)

  elseif self.result == 'lost' then
    love.graphics.setColor(1, 1, 1, self.backgroundOpacity)
    love.graphics.print('YOU LOST', Fonts.large, love.graphics.getWidth()/2, love.graphics.getHeight()/2, 0, 1, 1,
        Fonts.large:getWidth('YOU LOST')/2, Fonts.large:getHeight()/2)
  end
end

return EndGameWindow