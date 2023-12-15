local HUD = Class('HUD')

function HUD:initialize(teamSynergy)
  self.suit = Suit.new()

  assert(teamSynergy, 'Where is the TeamSynergy instance?')
  self.teamSynergy = teamSynergy
end

function HUD:update(dt)

end

function HUD:draw()
  love.graphics.setColor(1, 1, 1)

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
  local topX, topY = 23, 93
  self.suit.layout:reset(topX, topY)
  self.suit.layout:padding(11)
  for i = 1, #self.teamSynergy.synergies do
    local synergy = self.teamSynergy.synergies[i]
    local id = ('synergy %d'):format(i)
    self.suit:Button(Images.icons[synergy.trait..tostring('Icon')],
      {
        id = id,
        draw = function(image, opt, x, y, w, h)
          love.graphics.setColor(83/255, 92/255, 99/255, 0.66)
          love.graphics.rectangle('fill', x, y, 78, 32)
          if self.suit:isHovered(id) then
            love.graphics.rectangle('fill', x + 78, y, 10, 32)
            love.graphics.rectangle('fill', x + 88, topY, 110, 160)
          end

          love.graphics.setColor(1, 1, 1)
          love.graphics.draw(image, x + 5, y + 4, 0, 2, 2)

          love.graphics.setColor(0.7, 0.7, 0.7)
          love.graphics.setFont(Fonts.medium)
          love.graphics.print(('%d/%d'):format(synergy.count, synergy.count), x + 40, y + 9)
        end
      },
      self.suit.layout:row(78, 32)
    )

  end

  -- Skill buttons
  local skills = {{}, {}, {}, {}}
  local skillW, skillH = 110, 51
  local paddingX = 15
  self.suit.layout:reset(love.graphics.getWidth() / 2 - skillW * #skills / 2 - paddingX * (#skills - 1), 409)
  self.suit.layout:padding(15)
  for i = 1, #skills do
    if self.suit:Button('f'..tostring(i), {id = ('skill %d'):format(i)},
        self.suit.layout:col(skillW, skillH)).hit then
      print('use skill')
    end
  end


  self.suit:draw()
end

return HUD