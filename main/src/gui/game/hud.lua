local Phase = require 'src.components.phase'
local Resources = require 'src.components.resources'
local CurrentInspectable = require 'src.components.currentInspectable'
local DragAndDropInfo = require 'src.components.dragAndDropInfo'
local Hero = require 'src.components.hero'
local CurrentSkill = require 'src.components.skills.currentSkill'
local AudioManager = require 'src.components.audioManager'

-- This should have been a system but it will mess up the draw order with the modal windows,
-- so it's a seperate class for now
local HUD = Class('HUD')

HUD.TRAIT_DESCRIPTIONS = {
  bigEar = {
    title = 'Big Ear',
    body = 'Increase skill cooldown reduction. Skill have 1 more charge.',
    threshold = '(2) +5 cooldown reduction\n(4) +20 cooldown reduction\n(6) +45 cooldown reduction'
  },
  sentient = {
    title = 'Sentient',
    body = 'Increase attack speed. Doubled for 2 seconds after skill cast.',
    threshold = '(2) +0.5 attack speed\n(3) +0.8 attack speed \n(4) +1.25 attack speed'
  },
  defect = {
    title = 'Defect',
    body = 'Convert all bonus AD into RP. Receive additional RP.',
    threshold = '(2) +20 RP\n(3) +35 RP\n(4) +50 RP\n(5) +65 RP'
  },
  candyhead = {
    title = 'Candyhead',
    body = 'Periodically summon 3 candies on the battlefield dealing\n 20 reality damage and stun enemies for 0.5s.',
    threshold = '\n(2) For each level 3 hero in your team, summon 1 more candy.'
  },
  coordinator = {
    title = 'Coordinator',
    body = 'Only active when you have exactly 1 or 3 Coordinators.',
    threshold = '(1) +30% crit chance \n(3) +60% crit chance'
  },
  artificer = {
    title = 'Artificer',
    body = 'Every 4 seconds regenerate energy.',
    threshold = '(2) +50 energy'
  },
  trailblazer = {
    title = 'Trailblazer',
    body = 'Attacks deal more damage the nearer the enemies.',
    threshold = '(2) +0-60% more damage\n(3) +0-90% more damage\n(4) +0-120% more damage'
  },
  droneMaestro = {
    title = 'Drone Maestro',
    body = 'Drone Maestro spawns a drone every 6 seconds.\nDrones attack enemies and exist until the end of battle.',
    threshold = '\n(2) Drones deal 24 damage\n(4) Drones deal 40 damage\n(6) Drones deal 60 damage'
  },
  cracker = {
    title = 'Cracker',
    body = 'Periodically remove the highest health enemy out of the field.\nHave a 33% chance to drop 1 gold.',
    threshold = '\n(2) Every 8 seconds\n(3) Every 5 seconds'
  },
}

local ALLY_STAT_DISPLAY_NAMES = {
  attackDamage = 'ATK',
  realityPower = 'RPW',
  attackSpeed = 'AS',
  range = 'RANGE',
  critChance = 'C.CHANCE',
  critDamage = 'C.DAMAGE',
  cooldownReduction = 'CDR',
  energy = 'Energy'
}

local ENEMY_STAT_DISPLAY_NAMES = {
  health = 'HEALTH',
  physicalArmor = 'P.ARMOR',
  realityArmor = 'R.ARMOR',
  speed = 'SPEED',
  damage = 'DAMAGE',
}

local PROGRESSION_BAR_MOVE_TIME = 1

function HUD:initialize(teamSlots, teamSynergy)
  self.suit = Suit.new()

  self.resources = Resources()
  self.teamSlots = teamSlots
  Hump.Gamestate.current():addEntity(teamSlots[1])
  self.teamSlotCount = 2

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
  -- Health bar
  self:drawBar(self.resources:getHealth(), self.resources:getMaxHealth(),
      {205/255, 41/255, 62/255}, Fonts.small,
      275, 12, love.graphics.getWidth() - 275 * 2, 15)


  -- Energy bar
  self:drawBar(self.resources:getEnergy(), self.resources:getMaxEnergy(),
      {61/255, 90/255, 237/255}, Fonts.small,
      275, 30, love.graphics.getWidth() - 275 * 2, 15)


  -- Progression bar
  love.graphics.setColor(0.4, 0.42, 0.44, 0.7)
  love.graphics.rectangle('fill', 673, 25, 174, 2, 2)

  love.graphics.setColor(1, 1, 1)
  for i = 1, self.roundCount do
    local round = self.phase.rounds[i]
    if round then
      love.graphics.draw(Images.icons[round.mainType..'Icon'],
          Lume.round(685 + self.roundPercentPositions[i] * 150) - 6, 18, 0, 2, 2)
    end
    -- love.graphics.circle('fill', 685 + self.roundPercentPositions[i] * 150, 28, 8)
  end

  love.graphics.setColor(0.4, 0.42, 0.44)
  love.graphics.rectangle('fill', 685, 12, 2, 2)
  love.graphics.rectangle('fill', 683, 10, 2, 2)
  love.graphics.rectangle('fill', 687, 10, 2, 2)
  love.graphics.rectangle('fill', 685, 38, 2, 2)
  love.graphics.rectangle('fill', 683, 40, 2, 2)
  love.graphics.rectangle('fill', 687, 40, 2, 2)

  for i = 1, self.roundCount do
    local round = self.phase.rounds[i]
    if round then
      local x, y, w, h = Lume.round(685 + self.roundPercentPositions[i] * 150 - 6) - 2, 16, 18, 22
      local mx, my = love.mouse.getPosition()
      if x < mx and mx < x + w and y < my and my < y + h then
        love.graphics.setColor(0.8, 0.8, 0.8)
        love.graphics.setFont(Fonts.medium)

        love.graphics.printf(round.mainType:gsub("^%l", string.upper), 712, y + 35, 100, 'center')
      end
    end
  end


  -- Lower buttons
  if self.dragAndDropInfo.draggable == nil then
    if CurrentSkill().currentSkill == nil then
      love.graphics.setFont(Fonts.medium)
      local currentPhase = self.phase:current()
      local bw, bh = 140, 65
      
      if currentPhase == 'planning' then
        self.suit.layout:reset(love.graphics.getWidth()/2 - bw * 1.5 - 15, 460)
        self.suit.layout:padding(15)

        local performMoney = self.resources:getPerformMoney()
        if performMoney then
          if self.suit:Button('Perform\n+100 Style\nCost: '..performMoney, {draw = HUD.drawActionButton},
              self.suit.layout:col(bw, bh)).hit then
            AudioManager:playSound('button')
            if self.resources:modifyMoney(-performMoney) then
              self.resources.performMoneyThresholdIndex = self.resources.performMoneyThresholdIndex + 1
              self.resources:modifyStyle(self.resources.PERFORM_STYLE_GAIN)
            end
          end
        else
          self.suit:Button('Maximum\nperformances\nreached', {draw = HUD.drawActionButton}, self.suit.layout:col(bw, bh))
        end
        
        local upgradeMoney = self.resources:getUpgradeMoney()
        if upgradeMoney then
          if self.suit:Button('Upgrade\n+1 Hero Slot\nCost: '..upgradeMoney, {draw = HUD.drawActionButton},
              self.suit.layout:col(bw, bh)).hit then
            AudioManager:playSound('button')
            if self.resources:modifyMoney(-upgradeMoney) then
              self.resources.upgradeMoneyThresholdIndex = self.resources.upgradeMoneyThresholdIndex + 1

              Hump.Gamestate.current():addEntity(self.teamSlots[self.teamSlotCount])
              self.teamSlotCount = self.teamSlotCount + 1

              self.resources:modifyBaseMaxEnergy(self.resources.UPGRADE_ENERGY_GAIN)
            end
          end
        else
          self.suit:Button('Maximum\nhero slot\nreached', {draw = HUD.drawActionButton}, self.suit.layout:col(bw, bh))
        end
  
        if self.suit:Button('Let\'s roll!\nBegin\nnext wave', {draw = HUD.drawActionButton}, self.suit.layout:col(bw, bh)).hit then
          AudioManager:playSound('button')
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
  
        local skillW, skillH = 68, 68
        local paddingX = 12
        self.suit.layout:reset(love.graphics.getWidth() / 2 - skillW * #heroComponents / 2 - paddingX * (#heroComponents - 1) / 2, 458)
        self.suit.layout:padding(paddingX)
        for i = 1, #heroComponents do
          if self.suit:Button(heroComponents[i], {draw = self.drawSkillIcon},
              self.suit.layout:col(skillW, skillH)).hit then
            heroComponents[i].skill:cast()
          end
        end
      end
    end
    
  else
    local draggable = self.dragAndDropInfo.draggable

    Deep.queue(8, function()
      local x, y, w, h = 50, 465, 760, 65
      local mx, my = love.mouse.getPosition()

      if x < mx and mx < x + w and y < my then
        love.graphics.setColor(0.2, 0.2, 0.2, 0.6)
        love.graphics.rectangle('fill', x, y, w, h)

        love.graphics.setColor(0.8, 0.8, 0.8, 1)
        love.graphics.setFont(Fonts.big)
        if draggable.draggableType == 'hero' then
          local hero = draggable:getEntity():getComponent('Hero')
          love.graphics.printf('Sell for '..tostring(hero:getSellPrice()), 130, 490, 600, 'center')

          love.graphics.setColor(0.9, 0.9, 0.9)
          love.graphics.draw(Images.icons.moneyIcon, 500, 485, 0, 3, 3)

        elseif draggable.draggableType == 'mod' then
          love.graphics.printf('Sell for ', 150, 490, 600, 'center')
        end

      else
        love.graphics.setColor(0.2, 0.2, 0.2, 0.6)
        love.graphics.rectangle('fill', x, y, w, h)

        love.graphics.setColor(0.8, 0.8, 0.8, 1)
        love.graphics.setFont(Fonts.big)
        love.graphics.printf('Drag here to sell', 150, 490, 600, 'center')
      end
    end)

  end


  -- Synergy
  local topX, topY = 23, 93
  self.suit.layout:reset(topX, topY)
  self.suit.layout:padding(11)
  for i = 1, #self.teamSynergy.synergies do
    local id = ('synergy %d'):format(i)
    self.suit:Button(Images.icons[self.teamSynergy.synergies[i].trait..'Icon'],
      {id = id, hud = self, synergy = self.teamSynergy.synergies[i], synergyIndex = i,
          draw = self.drawSynergy, topX = topX, topY = topY},
      self.suit.layout:row(78, 32)
    )
  end


  -- Inspector
  local x, y, w, h = 630, 125, 215, 275
  local inspectable = self.currentInspectable.inspectable
  if inspectable then
    if inspectable.objectType == 'hero' then
      love.graphics.setColor(0.2, 0.2, 0.2, 0.6)
      love.graphics.rectangle('fill', x, y, w, h)

      local hero = inspectable.object

      -- Icon
      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(inspectable.image, inspectable.quad, x + 15, y + 16, 0, 3, 3)

      -- Skill
      local mx, my = love.mouse.getPosition()
      if x + 15 < mx and mx < x + 51 and y + 16 < my and my < y + 55 then
        local skillW, skillH = 360, 44
        local skillX, skillY =  x - skillW - 10, y + 16
        local paddingX, paddingY = 12, 12

        local _, wrappedtext = Fonts.medium:getWrap(hero:getEntity().SKILL_DESCRIPTION, skillW - paddingX * 2)
        skillH = skillH + Fonts.medium:getHeight() * #wrappedtext

        love.graphics.setColor(0.2, 0.2, 0.2, 0.6)
        love.graphics.rectangle('fill', skillX, skillY, skillW, skillH)

        love.graphics.setColor(0.8, 0.8, 0.8)
        love.graphics.setFont(Fonts.medium)
        love.graphics.printf('Cost: '..hero.skill.energy, skillX + paddingX, skillY + paddingY, skillW - paddingX * 2, 'left')
        love.graphics.printf('Cooldown: '..hero.skill:getCooldown(), skillX + paddingX, skillY + paddingY, skillW - paddingX * 2, 'right')
        love.graphics.printf(hero:getEntity().SKILL_DESCRIPTION, skillX + paddingX, skillY + paddingY + 20, skillW - paddingX * 2, 'left')
      end

      -- Name, level, cost and traits
      love.graphics.setColor(hero.class.TIER_COLORS[hero.tier])
      love.graphics.setFont(Fonts.big)
      love.graphics.print(string.upper(hero.name), x + 67, y + 13)

      love.graphics.setColor(0.8, 0.8, 0.8)
      love.graphics.setFont(Fonts.medium)
      love.graphics.print('Lv. '..tostring(hero.level), x + 67, y + 37)
      
      love.graphics.setColor(0.8, 0.8, 0.8)
      love.graphics.print('Cost: '..tostring(hero:getSellPrice()), x + 143, y + 37)

      for i = 1, #hero.traits do
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(Images.icons[hero.traits[i]..'Icon'], x + 67, y + 61 + (i-1) * 18)

        love.graphics.setColor(0.8, 0.8, 0.8)
        love.graphics.setFont(Fonts.medium)
        love.graphics.print(HUD.TRAIT_DESCRIPTIONS[hero.traits[i]].title, x + 85, y + 60 + (i-1) * 18)
      end

      -- Mod
      love.graphics.setColor(0.1, 0.1, 0.1, 0.8)
      love.graphics.setLineWidth(2)
      love.graphics.rectangle('line', x + 12, y + 68, 42, 42)
      love.graphics.setLineWidth(1)
      love.graphics.setColor(0.4, 0.4, 0.4, 0.4)
      love.graphics.rectangle('fill', x + 12, y + 68, 42, 42)
      local modEntity = hero.modEntity
      if modEntity then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(modEntity:getComponent('Sprite').image,
            x + 15, y + 71, 0, 3, 3)

        local mx, my = love.mouse.getPosition()
        if x + 12 < mx and mx < x + 54 and y + 68 < my and my < y + 104 then
          self:drawModTooltip(modEntity:getComponent('Mod'), mx, my, 'right')
        end
      end

      -- Stats
      local statValues = hero:getStats()
      local stats = {'attackDamage', 'realityPower', 'attackSpeed', 'range', 'critChance', 'critDamage',
          'cooldownReduction', 'energy'}
      love.graphics.setColor(0.8, 0.8, 0.8)
      love.graphics.setFont(Fonts.medium)
      local statY = y + 126
      for i = 1, #stats do
        love.graphics.print(ALLY_STAT_DISPLAY_NAMES[stats[i]], x + 12, statY)
        love.graphics.print(tostring(statValues[stats[i]]),
            x + w - 11 - Fonts.medium:getWidth(tostring(statValues[stats[i]])), statY)
        statY = statY + 17
      end

    elseif inspectable.objectType == 'enemy' then
      local y, h = y + 50, h - 110

      love.graphics.setColor(0.2, 0.2, 0.2, 0.6)
      love.graphics.rectangle('fill', x, y, w, h)

      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(inspectable.image, inspectable.quad, x + 15, y + 10, 0, 3, 3)

      local enemy = inspectable.object
      
      -- Name
      love.graphics.setColor(0.8, 0.8, 0.8)
      love.graphics.setFont(Fonts.big)
      love.graphics.print(string.upper(enemy.name), x + 67, y + 13)

      -- Stats
      local statValues = enemy.stats:getValues()
      local stats = {'physicalArmor', 'realityArmor', 'speed', 'damage'}
      love.graphics.setColor(0.8, 0.8, 0.8)
      love.graphics.setFont(Fonts.medium)

      local _t = ('%d/%d'):format(statValues.HP, statValues.maxHP)
      love.graphics.print('HEALTH', x + 12, y + 68)
      love.graphics.print(_t, x + w - 11 - Fonts.medium:getWidth(_t), y + 68)

      local statY = y + 85
      for i = 1, #stats do
        love.graphics.print(ENEMY_STAT_DISPLAY_NAMES[stats[i]], x + 12, statY)
        love.graphics.print(tostring(statValues[stats[i]]),
            x + w - 11 - Fonts.medium:getWidth(tostring(statValues[stats[i]])), statY)
        statY = statY + 17
      end

    end
  end

  self.suit:draw()


  -- Money and style
  love.graphics.setColor(1, 1, 1)
  if self.suit:ImageButton(Images.icons.moneyIcon, {id = 'money', sx = 2, sy = 2}, 23, 13).hovered then
    love.graphics.setColor(0.2, 0.2, 0.2, 0.6)
    love.graphics.rectangle('fill', 15, 37, 230, 58)

    love.graphics.setColor(0.85, 0.85, 0.85)
    love.graphics.printf('Used to buy hero slots, perform or buy stuff in the dealer phase', Fonts.medium,
        23, 42, 214, 'left')
  end
  love.graphics.setColor(0.85, 0.85, 0.85)
  love.graphics.print(tostring(self.resources:getMoney()), Fonts.medium, 53, 17)


  love.graphics.setColor(1, 1, 1)
  if self.suit:ImageButton(Images.icons.styleIcon, {id = 'style', sx = 2, sy = 2}, 103, 13).hovered then
    love.graphics.setColor(0.2, 0.2, 0.2, 0.6)
    love.graphics.rectangle('fill', 15, 37, 230, 74)

    love.graphics.setColor(0.85, 0.85, 0.85)
    love.graphics.printf('The more style your team has, the more likely you attract higher tier heroes', Fonts.medium,
        23, 42, 214, 'left')
  end
  love.graphics.setColor(0.85, 0.85, 0.85)
  love.graphics.setFont(Fonts.medium)
  love.graphics.print(tostring(self.resources:getStyle()), 133, 17)


  -- Mod tooltip
  local mx, my = love.mouse.getPosition()
  local modEntities = Hump.Gamestate.current():getEntitiesWithComponent('Mod')
  for _, modEntity in ipairs(modEntities) do
    if modEntity:getComponent('Area'):hasWorldPoint(mx, my) then
      local mod = modEntity:getComponent('Mod')
      self:drawModTooltip(mod, mx, my)
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

function HUD.drawSynergy(image, opt, x, y, w, h)
  local hud = opt.hud
  local synergy = opt.synergy

  local isActive = (synergy.trait ~= 'coordinator' and synergy.nextThresholdIndex ~= 1) or
      (synergy.trait == 'coordinator' and (synergy.count == 1 or synergy.count == 3))
  
  if isActive then
    love.graphics.setColor(103/255, 112/255, 119/255, 0.75)
    love.graphics.rectangle('fill', x, y, 78, 32)
  end

  if hud.suit:isHovered(opt.id) then
    if isActive then love.graphics.setColor(103/255, 112/255, 119/255, 0.75)
    else love.graphics.setColor(0.2, 0.2, 0.2, 0.7)
    end
    love.graphics.rectangle('fill', x + 78, y, 10, 32)

    local y = y
    if opt.synergyIndex >= 6 then y = y - 128 end
    love.graphics.rectangle('fill', x + 88, y, 550, 160)

    local description = HUD.TRAIT_DESCRIPTIONS[synergy.trait]
    if description then
      if isActive then love.graphics.setColor(0.84, 0.84, 0.84)
      else love.graphics.setColor(0.6, 0.6, 0.6)
      end
      
      love.graphics.setFont(Fonts.big)
      love.graphics.print(description.title, x + 94, y + 6)

      love.graphics.setFont(Fonts.medium)
      love.graphics.print(description.body, x + 94, y + 30)
      
      love.graphics.setFont(Fonts.medium)
      love.graphics.print(description.threshold, x + 94, y + 46)
    end
  end

  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(image, x + 5, y + 4, 0, 2, 2)

  love.graphics.setColor(0.7, 0.7, 0.7)
  love.graphics.setFont(Fonts.medium)
  local nextThreshold = hud.teamSynergy.TRAIT_THRESHOLD[synergy.trait][synergy.nextThresholdIndex]
  if nextThreshold ~= nil then nextThreshold = '/'..tostring(nextThreshold)
  else nextThreshold = ''
  end
  love.graphics.setColor(0.7, 0.7, 0.7)
  love.graphics.print(tostring(synergy.count)..nextThreshold, x + 40, y + 9)

  if not isActive then
    love.graphics.setColor(0.2, 0.2, 0.2, 0.7)
    love.graphics.rectangle('fill', x, y, 78, 32)
  end
end

function HUD.drawActionButton(text, opt, x, y, w, h)
  if opt.state == 'normal' then love.graphics.setColor(0.2, 0.2, 0.2)
  elseif opt.state == 'hovered' then love.graphics.setColor(0.19, 0.6, 0.73)
  elseif opt.state == 'active' then love.graphics.setColor(1, 0.6, 0)
  end
	love.graphics.rectangle('fill', x, y, w, h, 2)

  local wrappedtextWidth, wrappedtext = Fonts.medium:getWrap(text, w - 6)
  love.graphics.setColor(0.85, 0.85, 0.85)
  love.graphics.printf(text, Fonts.medium, x + w/2, y + h/2, w, 'center', 0, 1, 1,
      w/2, Fonts.medium:getHeight() * #wrappedtext / 2)
end

function HUD.drawSkillIcon(hero, opt, x, y, w, h)
  love.graphics.setColor(0.1, 0.15, 0.22, 0.2)
  love.graphics.rectangle('fill', x, y, w, h)
  
  local inspectable = hero:getEntity():getComponent('Inspectable')
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(inspectable.image, inspectable.quad, x + 8, y + 8, 0, 4, 4)

  local skill = hero.skill
  love.graphics.stencil(function() 
    love.graphics.rectangle('fill', x, y, w, h)
  end, 'replace', 1)
  love.graphics.setStencilTest('greater', 0)
    love.graphics.setColor(0.85, 0.85, 0.85)
    love.graphics.setFont(Fonts.medium)
    love.graphics.printf(skill.energy, x, y + 3, w - 3, 'right')

    if skill:getMaxChargeCount() > 0 then
      if skill.chargeCount > 0 then
        if skill.secondsUntilSkillReady <= 0 then
          love.graphics.setColor(0.85, 0.85, 0.85)
          love.graphics.setFont(Fonts.medium)
          love.graphics.printf(skill.chargeCount+1, x, y + 51, w - 3, 'right')
        else
          love.graphics.setColor(0.85, 0.85, 0.85)
          love.graphics.setFont(Fonts.medium)
          love.graphics.printf(1, x, y + 51, w - 3, 'right')
        end

        if opt.state == 'hovered' then
          love.graphics.setColor(1, 1, 1, 0.1)
          love.graphics.rectangle('fill', x, y, w, h)
        end

      else
        love.graphics.setColor(0.25, 0.25, 0.25, 0.6)
        love.graphics.rectangle('fill', x, y, w, h)

        love.graphics.setColor(0.22, 0.28, 0.35, 0.8)
        love.graphics.arc('fill', x + w/2, y + h/2, Lume.distance(x, y, x + w/2 + 4, y + h/2 + 4),
            -math.pi/2 - math.pi * 2 * skill.secondsUntilSkillReady / skill:getCooldown(), -math.pi/2)

        love.graphics.setColor(0.85, 0.85, 0.85)
        love.graphics.setFont(Fonts.big)
        love.graphics.printf(math.floor(skill.secondsUntilSkillReady),
            x, y + h/2 - Fonts.big:getHeight()/2, w, 'center')
      end

      
    else
      if skill.secondsUntilSkillReady > 0 then
        love.graphics.setColor(0.25, 0.25, 0.25, 0.6)
        love.graphics.rectangle('fill', x, y, w, h)

        love.graphics.setColor(0.22, 0.28, 0.35, 0.8)
        love.graphics.arc('fill', x + w/2, y + h/2, Lume.distance(x, y, x + w/2 + 4, y + h/2 + 4),
            -math.pi/2 - math.pi * 2 * skill.secondsUntilSkillReady / skill:getCooldown(), -math.pi/2)

        love.graphics.setColor(0.85, 0.85, 0.85)
        love.graphics.setFont(Fonts.big)
        love.graphics.printf(math.floor(skill.secondsUntilSkillReady),
            x, y + h/2 - Fonts.big:getHeight()/2, w, 'center')

      else
        if opt.state == 'hovered' then
          love.graphics.setColor(1, 1, 1, 0.1)
          love.graphics.rectangle('fill', x, y, w, h)
        end
      end
    end
  love.graphics.setStencilTest()

  love.graphics.setColor(0.1, 0.15, 0.22)
  love.graphics.setLineWidth(4)
  love.graphics.rectangle('line', x, y, w, h)
  love.graphics.setLineWidth(1)
end

function HUD:drawModTooltip(mod, x, y, align)
  local w, h = 300, 104
  
  local x = x
  if align == 'right' then
    x = x - w
  end

  local currentDraggable = DragAndDropInfo().draggable
  if currentDraggable and currentDraggable.draggableType == 'mod' then
    local draggableMod = currentDraggable:getEntity():getComponent('Mod')
    if #draggableMod.id + #mod.id <= 3 then
      mod = Hero.getModEntityFromModCombination(draggableMod, mod):getComponent('Mod')
    else
      return
    end
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