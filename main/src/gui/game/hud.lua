local HUD = Class('HUD')

function HUD:initialize()
  self.suit = Suit.new()
end

function HUD:update(dt)

end

function HUD:draw()
  -- Style
  if self.suit:ImageButton(Images.diamond, {id = 'style', sx = 0.2, sy = 0.2}, 23, 13).hovered then
    print('style')
  end

  
  -- Gold
  if self.suit:ImageButton(Images.diamond, {id = 'gold', sx = 0.2, sy = 0.2}, 23, 39).hovered then
    print('gold')
  end


  -- Health bar
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


  -- Energy bar
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


  -- Synergy
  local synergies = {{}, {}}
  self.suit.layout:reset(23, 113)
  self.suit.layout:padding(11)
  for i = 1, #synergies do
    if self.suit:ImageButton(Images.diamond, {id = ('synergy %d'):format(i), sx = 0.2, sy = 0.2},
        self.suit.layout:row(78, 32)).hovered then
      print('synergy')
    end
  end


  -- Skill buttons
  local skills = {{}, {}, {}, {}}
  local skillW, skillH = 110, 51
  local paddingX = 15
  self.suit.layout:reset(love.graphics.getWidth() / 2 - skillW * #skills / 2 - paddingX * (#skills - 1), 409)
  self.suit.layout:padding(15)
  for i = 1, #skills do
    if self.suit:Button('f'..tostring(i), {id = ('synergy %d'):format(i)},
        self.suit.layout:col(skillW, skillH)).hit then
      print('use skill')
    end
  end


  self.suit:draw()
end

return HUD