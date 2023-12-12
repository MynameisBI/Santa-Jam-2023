local HUD = Class('HUD')

function HUD:initialize()
  self.suit = Suit.new()
end

function HUD:update(dt)
  if self.suit:ImageButton(Images.diamond, {id = 'style', sx = 0.2, sy = 0.2}, 23, 13).hovered then
    print('style')
  end

  if self.suit:ImageButton(Images.diamond, {id = 'gold', sx = 0.2, sy = 0.2}, 23, 39).hovered then
    print('gold')
  end

  if self.suit:ImageButton(Images.diamond, {
    id = 'health', sx = 0.2, sy = 0.2,
    draw = function(image, x, y)
      local barWidth = love.graphics.getWidth() - x * 2

      love.graphics.setColor(1, 0.2, 0.2, 0.4)
      love.graphics.rectangle('fill', x , y, barWidth, 20)

      local health, maxHealth = 75, 100
      local percentLeft = health / maxHealth
      love.graphics.setColor(1, 0.2, 0.2, 0.4)
      love.graphics.rectangle('fill', x , y, barWidth, 20)
      love.graphics.setColor(1, 0.2, 0.2, 1)
      love.graphics.rectangle('fill', x + barWidth * (1 - percentLeft) / 2, y, barWidth * percentLeft, 20)
	  end
  }, 275, 13).hovered then
    print('health')
  end  

  if self.suit:ImageButton(Images.diamond, {
    id = 'energy', sx = 0.2, sy = 0.2,
    draw = function(image, x, y)
      local barWidth = love.graphics.getWidth() - x * 2

      love.graphics.setColor(0.2, 0.35, 1, 0.4)
      love.graphics.rectangle('fill', x , y, barWidth, 20)

      local energy, maxEnergy = 75, 100
      local percentLeft = energy / maxEnergy
      love.graphics.setColor(0.2, 0.35, 1, 1)
      love.graphics.rectangle('fill', x + barWidth * (1 - percentLeft) / 2, y, barWidth * percentLeft, 20)
	  end
  }, 275, 39).hovered then
    print('energy')
  end
end

function HUD:draw()
  self.suit:draw()
end

return HUD