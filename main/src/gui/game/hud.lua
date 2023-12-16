local Phase = require 'src.components.phase'

-- This should have been a system but it will mess up the draw order with the modal windows,
-- so it's a seperate class for now
local HUD = Class('HUD')

local TRAIT_DESCRIPTIONS = {
  bigEar = {
    title = 'Big Ear',
    body = 'Increase skill cooldown reduction. Skill have 1 more charge',
    threshold = '(2)\n(4)\n(6)'
  },
}

function HUD:initialize(resources, teamSynergy)
  self.suit = Suit.new()

  self.resources = resources

  self.phase = Phase()

  assert(teamSynergy, 'Where is the TeamSynergy instance?')
  self.teamSynergy = teamSynergy
end

function HUD:update(dt)

end

function HUD:draw()
  love.graphics.setColor(1, 1, 1)
  if self.suit:ImageButton(Images.icons.moneyIcon, {id = 'money', sx = 2, sy = 2}, 23, 13).hovered then
    
  end
  love.graphics.setColor(0.85, 0.85, 0.85)
  love.graphics.setFont(Fonts.medium)
  love.graphics.print(tostring(self.resources:getMoney()), 53, 17)


  love.graphics.setColor(1, 1, 1)
  if self.suit:ImageButton(Images.icons.styleIcon, {id = 'gold', sx = 2, sy = 2}, 103, 13).hovered then
    
  end
  love.graphics.setColor(0.85, 0.85, 0.85)
  love.graphics.setFont(Fonts.medium)
  love.graphics.print(tostring(self.resources:getStyle()), 133, 17)


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
          if synergy.nextThresholdIndex ~= 1 then
            -- love.graphics.setColor(83/255, 92/255, 99/255, 0.66)
            love.graphics.setColor(113/255, 122/255, 129/255, 0.75)
            love.graphics.rectangle('fill', x, y, 78, 32)
          end

          if self.suit:isHovered(id) then
            love.graphics.rectangle('fill', x + 78, y, 10, 32)
            love.graphics.rectangle('fill', x + 88, topY, 110, 160)

            local description = TRAIT_DESCRIPTIONS[synergy.trait]
            if description then
              love.graphics.setColor(0.7, 0.7, 0.7)
              love.graphics.setFont(Fonts.big)
              love.graphics.print(description.title, x + 94, topY + 6)

              love.graphics.setColor(0.7, 0.7, 0.7)
              love.graphics.setFont(Fonts.medium)
              love.graphics.print(description.body, x + 94, topY + 30)

              love.graphics.setColor(0.7, 0.7, 0.7)
              love.graphics.setFont(Fonts.medium)
              love.graphics.print(description.threshold, x + 94, topY + 46)
            end
          end

          love.graphics.setColor(1, 1, 1)
          love.graphics.draw(image, x + 5, y + 4, 0, 2, 2)

          love.graphics.setColor(0.7, 0.7, 0.7)
          love.graphics.setFont(Fonts.medium)
          local nextThreshold = self.teamSynergy.TRAIT_THRESHOLD[synergy.trait][synergy.nextThresholdIndex]
          if nextThreshold ~= nil then nextThreshold = '/'..tostring(nextThreshold)
          else nextThreshold = ''
          end
          love.graphics.setColor(0.7, 0.7, 0.7)
          love.graphics.print(tostring(synergy.count)..nextThreshold, x + 40, y + 9)

          if synergy.nextThresholdIndex == 1 then
            love.graphics.setColor(0.2, 0.2, 0.2, 0.6)
            love.graphics.rectangle('fill', x, y, 78, 32)
          end
        end
      },
      self.suit.layout:row(78, 32)
    )

  end


  -- Lower buttons
  local currentPhase = self.phase:current()
  if currentPhase == 'planning' then
    if self.suit:Button('Perform\nCost: '..tostring(self.resources:getUpgradeMoney()), 250, 409, 110, 51).hit then
      if self.resources:modifyMoney(-self.resources:getUpgradeMoney()) then
        print('add slot')
      end
    end

    if self.suit:Button('Upgrade\nCost: '..tostring(self.resources:getPerformMoney()), 375, 409, 110, 51).hit then
      if self.resources:modifyMoney(-self.resources:getPerformMoney()) then
        local style = 50
        self.resources:modifyStyle(style)
      end
    end

    if self.suit:Button('Let\'s roll!', 500, 409, 110, 51).hit then
      self.phase:switch('battle')
    end

  elseif currentPhase == 'battle' then
    local heroComponents = self.teamSynergy:getHeroComponentsInTeam()

    local skillW, skillH = 110, 51
    local paddingX = 15
    self.suit.layout:reset(love.graphics.getWidth() / 2 - skillW * #heroComponents / 2 - paddingX * (#heroComponents - 1) / 2, 409)
    self.suit.layout:padding(15)
    for i = 1, #heroComponents do
      if self.suit:Button('f'..tostring(i), {id = ('skill %d'):format(i)},
          self.suit.layout:col(skillW, skillH)).hit then
        print('use skill')
      end
    end
  end


  self.suit:draw()
end

return HUD