local Phase = require 'src.components.phase'
local CurrentInspectable = require 'src.components.currentInspectable'

-- This should have been a system but it will mess up the draw order with the modal windows,
-- so it's a seperate class for now
local HUD = Class('HUD')

local TRAIT_DESCRIPTIONS = {
  bigEar = {
    title = 'Big Ear',
    body = 'Increase skill cooldown reduction. Skill have 1 more charge',
    threshold = '(2)\n(4)\n(6)'
  },
  sentient = {
    title = 'Sentient',
    body = 'Increase skill cooldown reduction. Skill have 1 more charge',
    threshold = '(2)\n(4)\n(6)'
  },
  defect = {
    title = 'Defect',
    body = 'Increase skill cooldown reduction. Skill have 1 more charge',
    threshold = '(2)\n(4)\n(6)'
  },
  candyhead = {
    title = 'Candyhead',
    body = 'Increase skill cooldown reduction. Skill have 1 more charge',
    threshold = '(2)\n(4)\n(6)'
  },
  coordinator = {
    title = 'Coordinator',
    body = 'Increase skill cooldown reduction. Skill have 1 more charge',
    threshold = '(2)\n(4)\n(6)'
  },
  artificer = {
    title = 'Artificer',
    body = 'Increase skill cooldown reduction. Skill have 1 more charge',
    threshold = '(2)\n(4)\n(6)'
  },
  trailblazer = {
    title = 'Trailblazer',
    body = 'Increase skill cooldown reduction. Skill have 1 more charge',
    threshold = '(2)\n(4)\n(6)'
  },
  droneMaestro = {
    title = 'Drone Maestro',
    body = 'Increase skill cooldown reduction. Skill have 1 more charge',
    threshold = '(2)\n(4)\n(6)'
  },
  cracker = {
    title = 'Cracker',
    body = 'Increase skill cooldown reduction. Skill have 1 more charge',
    threshold = '(2)\n(4)\n(6)'
  },
}

local STAT_DISPLAY_NAMES = {
  attackDamage = 'ATK',
  realityPower = 'RPW',
  attackSpeed = 'AS',
  range = 'RANGE',
  critChance = 'CCHANCE',
  critDamage = 'CDMG',
}

function HUD:initialize(resources, teamSynergy)
  self.suit = Suit.new()

  self.resources = resources

  self.phase = Phase()

  assert(teamSynergy, 'Where is the TeamSynergy instance?')
  self.teamSynergy = teamSynergy

  self.currentInspectable = CurrentInspectable()
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
  self:drawBar(self.resources:getHealth(), self.resources:getMaxHealth(),
      {205/255, 41/255, 62/255}, Fonts.small,
      275, 12, love.graphics.getWidth() - 275 * 2, 15)


  -- Energy bar
  self:drawBar(self.resources:getEnergy(), self.resources:getMaxEnergy(),
      {61/255, 90/255, 237/255}, Fonts.small,
      275, 30, love.graphics.getWidth() - 275 * 2, 15)


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


  -- Inspector
  local x, y, w, h = 650, 80, 185, 300
  local inspectable = self.currentInspectable.inspectable
  if inspectable then
    love.graphics.setColor(0.2, 0.2, 0.2, 0.6)
    love.graphics.rectangle('fill', x, y, w, h)

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(inspectable.image, inspectable.quad, x + 15, y + 18, 0, 3, 3)

    if inspectable.objectType == 'hero' then
      local hero = inspectable.object

      love.graphics.setColor(0.8, 0.8, 0.8)
      love.graphics.setFont(Fonts.big)
      love.graphics.print(string.upper(hero.name), x + 67, y + 8)
      for i = 1, #hero.traits do
        love.graphics.setFont(Fonts.medium)
        love.graphics.print(TRAIT_DESCRIPTIONS[hero.traits[i]].title, x + 67, y + 35 + (i-1) * 16)
      end

      local statValues = hero:getStats()
      local stats = {'attackDamage', 'realityPower', 'attackSpeed', 'range', 'critChance', 'critDamage'}
      love.graphics.setFont(Fonts.medium)
      local statY = y + 100
      for i = 1, #stats do
        love.graphics.print(STAT_DISPLAY_NAMES[stats[i]], x + 12, statY)
        love.graphics.print(tostring(statValues[stats[i]]),
            x + 174 - Fonts.medium:getWidth(tostring(statValues[stats[i]])), statY)
        statY = statY + 17
      end
    end
  end


  -- Lower buttons
  love.graphics.setFont(Fonts.medium)
  local currentPhase = self.phase:current()
  self.suit.layout:reset(250, 475)
  self.suit.layout:padding(15)
  if currentPhase == 'planning' then
    if self.suit:Button('Perform\nCost: '..tostring(self.resources:getUpgradeMoney()),
        self.suit.layout:col(110, 51)).hit then
      if self.resources:modifyMoney(-self.resources:getUpgradeMoney()) then
        print('add slot')
      end
    end

    if self.suit:Button('Upgrade\nCost: '..tostring(self.resources:getPerformMoney()),
    self.suit.layout:col(110, 51)).hit then
      if self.resources:modifyMoney(-self.resources:getPerformMoney()) then
        local style = 50
        self.resources:modifyStyle(style)
      end
    end

    if self.suit:Button('Let\'s roll!', self.suit.layout:col(110, 51)).hit then
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

function HUD:drawBar(value, maxValue, color, font, x, y, w, h)
  local barWidth = love.graphics.getWidth() - x * 2

  love.graphics.setColor(color[1], color[2], color[3], 0.4)
  love.graphics.rectangle('fill', x, y, w, h)

  local percentage = value / maxValue
  love.graphics.setColor(color[1], color[2], color[3], 1)
  -- love.graphics.rectangle('fill', x + barWidth * (1 - percentage) / 2 + 2, y + 2, w * percentage - 4, h - 4)
  love.graphics.rectangle('fill', x + 2, y + 2, w * percentage - 4, h - 4)

  love.graphics.setColor(0.8, 0.8, 0.8, 1)
  love.graphics.setFont(font)
  local t = ('%d/%d'):format(value, maxValue)
  love.graphics.print(t, x + w / 2 - font:getWidth(t) / 2, y + h / 2 - font:getHeight() / 2)
end

return HUD