local Phase = require 'src.components.phase'
local CurrentInspectable = require 'src.components.currentInspectable'
local DragAndDropInfo = require 'src.components.dragAndDropInfo'
local Hero = require 'src.components.hero'

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
  cooldownReduction = 'CDR',
  energy = 'Energy'
}

local PROGRESSION_BAR_MOVE_TIME = 1

function HUD:initialize(resources, teamSynergy)
  self.suit = Suit.new()

  self.resources = resources

  self.phase = Phase()

  assert(teamSynergy, 'Where is the TeamSynergy instance?')
  self.teamSynergy = teamSynergy

  self.currentInspectable = CurrentInspectable()

  self.dragAndDropInfo = DragAndDropInfo()

  self.roundCount = 4
  self.rounds = {}
  for i = 1, self.roundCount do
    table.insert(self.rounds, self.phase.rounds[i])
  end
  self.roundPercentPositions = {0.25, 0.5, 0.75, 1, 1.25}

  self.timer = Hump.Timer()
end

function HUD:update(dt)
  self.timer:update(dt)
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


  -- Progression bar
  love.graphics.setColor(0.4, 0.4, 0.4)
  love.graphics.rectangle('fill', 685, 25, 150, 6)

  love.graphics.setColor(0.8, 0.8, 0.8)
  for i = 1, self.roundCount do
    local round = self.phase.rounds[i]
    if round then
      love.graphics.setFont(Fonts.medium)
      love.graphics.print(round.mainType, 685 + self.roundPercentPositions[i] * 150, 28, math.pi/2)
    end
    -- love.graphics.circle('fill', 685 + self.roundPercentPositions[i] * 150, 28, 8)
  end


  -- Synergy
  local topX, topY = 23, 93
  self.suit.layout:reset(topX, topY)
  self.suit.layout:padding(11)
  for i = 1, #self.teamSynergy.synergies do
    local synergy = self.teamSynergy.synergies[i]
    local id = ('synergy %d'):format(i)
    self.suit:Button(Images.icons[synergy.trait..'Icon'],
      {
        id = id,
        draw = function(image, opt, x, y, w, h)
          local isActive = (synergy.trait ~= 'coordinator' and synergy.nextThresholdIndex ~= 1) or
              (synergy.trait == 'coordinator' and (synergy.count == 1 or synergy.count == 3))
          if isActive then
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

          if not isActive then
            love.graphics.setColor(0.2, 0.2, 0.2, 0.6)
            love.graphics.rectangle('fill', x, y, 78, 32)
          end
        end
      },
      self.suit.layout:row(78, 32)
    )
  end


  -- Inspector
  -- for _, hero in ipairs(Hump.Gamestate)
  -- if (hero.name == 'Cole') then
  --   print(hero.modEntity)
  -- end

  local x, y, w, h = 630, 80, 215, 360
  local inspectable = self.currentInspectable.inspectable
  if inspectable then
    love.graphics.setColor(0.2, 0.2, 0.2, 0.6)
    love.graphics.rectangle('fill', x, y, w, h)

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(inspectable.image, inspectable.quad, x + 15, y + 10, 0, 3, 3)

    if inspectable.objectType == 'hero' then
      local hero = inspectable.object

      -- Name and traits
      love.graphics.setColor(0.8, 0.8, 0.8)
      love.graphics.setFont(Fonts.big)
      love.graphics.print(string.upper(hero.name), x + 67, y + 13)
      for i = 1, #hero.traits do
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(Images.icons[hero.traits[i]..'Icon'], x + 67, y + 41 + (i-1) * 18)

        love.graphics.setColor(0.8, 0.8, 0.8)
        love.graphics.setFont(Fonts.medium)
        love.graphics.print(TRAIT_DESCRIPTIONS[hero.traits[i]].title, x + 85, y + 40 + (i-1) * 18)
      end

      -- Mod
      love.graphics.setColor(0.1, 0.1, 0.1, 0.8)
      love.graphics.setLineWidth(2)
      love.graphics.rectangle('line', x + 12, y + 62, 42, 42)
      love.graphics.setLineWidth(1)
      love.graphics.setColor(0.4, 0.4, 0.4, 0.4)
      love.graphics.rectangle('fill', x + 12, y + 62, 42, 42)
      local modEntity = hero.modEntity
      if modEntity then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(modEntity:getComponent('Sprite').image,
            x + 15, y + 65, 0, 3, 3)

        local mx, my = love.mouse.getPosition()
        if x + 12 < mx and mx < x + 54 and y + 62 < my and my < y + 104 then
          self:drawModTooltip(modEntity:getComponent('Mod'), mx, my, 'right')
        end
      end

      -- Stats
      local statValues = hero:getStats()
      local stats = {'attackDamage', 'realityPower', 'attackSpeed', 'range', 'critChance', 'critDamage',
          'cooldownReduction', 'energy'}
      love.graphics.setColor(0.8, 0.8, 0.8)
      love.graphics.setFont(Fonts.medium)
      local statY = y + 120
      for i = 1, #stats do
        love.graphics.print(STAT_DISPLAY_NAMES[stats[i]], x + 12, statY)
        love.graphics.print(tostring(statValues[stats[i]]),
            x + w - 11 - Fonts.medium:getWidth(tostring(statValues[stats[i]])), statY)
        statY = statY + 17
      end
    end
  end


  -- Lower buttons
  love.graphics.setFont(Fonts.medium)
  local currentPhase = self.phase:current()
  if currentPhase == 'planning' then
    self.suit.layout:reset(250, 475)
    self.suit.layout:padding(15)
    if self.suit:Button('Perform\nCost: '..tostring(self.resources:getUpgradeMoney()),
        self.suit.layout:col(110, 51)).hit then
      if self.resources:modifyMoney(-self.resources:getUpgradeMoney()) then
        self.resources:modifyStyle(self.resources.PERFORM_STYLE_GAIN)
      end
    end

    if self.suit:Button('Upgrade\nCost: '..tostring(self.resources:getPerformMoney()),
    self.suit.layout:col(110, 51)).hit then
      if self.resources:modifyMoney(-self.resources:getPerformMoney()) then
        print('add slot')
        self.resources:modifyBaseMaxEnergy(self.resources.UPGRADE_ENERGY_GAIN)
      end
    end

    if self.suit:Button('Let\'s roll!', self.suit.layout:col(110, 51)).hit then
      if self.phase.rounds[1] then
        if self.phase.rounds[1].mainType == 'dealer' then
          self.phase:switchNextRound()
        end
      end
      self.phase:switch('battle')
      self.phase:startCurrentRound()
    end

  elseif currentPhase == 'battle' then
    local heroComponents = self.teamSynergy:getHeroComponentsInTeam()

    local skillW, skillH = 110, 51
    local paddingX = 15
    self.suit.layout:reset(love.graphics.getWidth() / 2 - skillW * #heroComponents / 2 - paddingX * (#heroComponents - 1) / 2, 475)
    self.suit.layout:padding(paddingX)
    for i = 1, #heroComponents do
      if self.suit:Button('f'..tostring(i), {id = ('skill %d'):format(i)},
          self.suit.layout:col(skillW, skillH)).hit then
        heroComponents[i].skill:cast()
      end
    end
  end

  self.suit:draw()

  -- Mod tooltip
  local mx, my = love.mouse.getPosition()
  local modEntities = Hump.Gamestate.current():getEntitiesWithComponent('Mod')
  for _, modEntity in ipairs(modEntities) do
    if modEntity:getComponent('Area'):hasWorldPoint(mx, my) then
      local mod = modEntity:getComponent('Mod')
      if not self.dragAndDropInfo.draggable then
        self:drawModTooltip(mod, mx, my)
      else
        local hoveredMod = self.dragAndDropInfo.draggable:getEntity():getComponent('Mod')
        if hoveredMod then
          local resultModEntity = Hero.getModEntityFromModCombination(mod, hoveredMod)
          if resultModEntity then
            self:drawModTooltip(resultModEntity:getComponent('Mod'), mx, my)
          end
        end
      end
    end
  end
  local heroes = Hump.Gamestate.current():getEntitiesWithComponent('Hero')
  heroes = Lume.filter(heroes, function(hero) return hero:getComponent('Hero').modEntity ~= nil end)
  for _, hero in ipairs(heroes) do
    local hx, hy = hero:getComponent('Transform'):getGlobalPosition()
    if hx - 3 < mx and mx < hx + 15 and hy - 5 < my and my < hy + 7 then
      self:drawModTooltip(hero:getComponent('Hero').modEntity:getComponent('Mod'), mx, my)
    end
  end
end

function HUD:onRoundStart(phase)
  self.timer:tween(PROGRESSION_BAR_MOVE_TIME,
      self.roundPercentPositions, {0, 0.25, 0.5, 0.75, 1}, 'out-quint',
      function()
        self.roundCount = 5
      end)
end

function HUD:onRoundEnd(phase)
  self.roundPercentPositions = {0.25, 0.5, 0.75, 1, 1.25}
  self.roundCount = 4
end

function HUD:drawBar(value, maxValue, color, font, x, y, w, h)
  local barWidth = love.graphics.getWidth() - x * 2

  love.graphics.setColor(color[1], color[2], color[3], 0.4)
  love.graphics.rectangle('fill', x, y, w, h)

  local percentage = value / maxValue
  love.graphics.setColor(color[1], color[2], color[3], 1)
  love.graphics.rectangle('fill', x + 2, y + 2, w * percentage - 4, h - 4)

  love.graphics.setColor(0.8, 0.8, 0.8, 1)
  love.graphics.setFont(font)
  local t = ('%d/%d'):format(value, maxValue)
  love.graphics.print(t, x + w / 2 - font:getWidth(t) / 2, y + h / 2 - font:getHeight() / 2)
end

function HUD:drawModTooltip(mod, x, y, align)
  local w, h = 300, 104
  
  local x = x
  if align == 'right' then
    x = x - w
  end

  if #mod.id >= 2 then h = h + 40 end

  love.graphics.setColor(0.15, 0.15, 0.15, 0.6)
  love.graphics.rectangle('fill', x, y, w, h)
  
  love.graphics.setColor(0.8, 0.8, 0.8)
  love.graphics.setFont(Fonts.big)
  love.graphics.print(mod.name, x + 12, y + 6)

  if #mod.id >= 2 then
    love.graphics.setColor(1, 1, 1)
    for i = 1, #mod.id do
      local modX, modY = x + 12 + (i-1) * 70, y + 28
      local char = mod.id:sub(i, i)
      if char == 'S' then
        love.graphics.draw(Images.mods.scrapPack, modX, modY, 0, 3, 3)
      elseif char == 'P' then
        love.graphics.draw(Images.mods.psychePack, modX, modY, 0, 3, 3)
      elseif char == 'B' then
        love.graphics.draw(Images.mods.bioPack, modX, modY, 0, 3, 3)
      end
    end
  
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.setFont(Fonts.big)
    for i = 1, #mod.id-1 do
      local plusX, plusY = x + 60 + (i-1) * 70, y + 36
      love.graphics.print('+', plusX, plusY)
    end
  end

  love.graphics.setFont(Fonts.medium)
  love.graphics.print(mod.description, x + 12, #mod.id >= 2 and y + 70 or y + 32)
end

return HUD