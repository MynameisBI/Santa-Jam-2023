local State = require 'src.states.state'

-- Systems
local DragAndDrop = require 'src.systems.dragAndDrop'
local DrawSlot = require 'src.systems.drawSlot'
local ManageTeamSynergy = require 'src.systems.manageTeamSynergy'
local Inspect = require 'src.systems.inspect'
local ManageHero = require 'src.systems.manageHero'
local ManageEnemy = require 'src.systems.manageEnemy'
local ManageResources = require 'src.systems.manageResources'
local ManageBullet = require 'src.systems.manageBullet'
local UpdateTargetSkill = require 'src.systems.updateTargetSkill'
local UpdateAreaSkill = require 'src.systems.updateAreaSkill'
local ManageCandy = require 'src.systems.manageCandy'
local ManageDrone = require 'src.systems.manageDrone'
local UpdateTimer = require 'src.systems.updateTimer'
local DrawRectangle = require 'src.systems.drawRectangle'
local UpdateTrap = require 'src.systems.updateTrap'
local ManageProjectile = require 'src.systems.manageProjectile'
local Crack = require 'src.systems.crack'
-- Components
local TeamSynergy = require 'src.components.teamSynergy'
local TeamUpdateObserver = require 'src.components.teamUpdateObserver'
local Resources = require 'src.components.resources'
local Phase = require 'src.components.phase'
local Enemy = require 'src.components.enemy'
local AudioManager = require 'src.components.audioManager'
-- Entities
local Entity = require 'src.entities.entity'
local Slot = require 'src.entities.slot'
local Cole = require 'src.entities.heroes.cole'
local Tom = require 'src.entities.heroes.tom'
local Soniya = require 'src.entities.heroes.soniya'
local Sasami = require 'src.entities.heroes.sasami'
local Skott = require 'src.entities.heroes.skott'
local Rover = require 'src.entities.heroes.rover'
local Raylee = require 'src.entities.heroes.raylee'
local Nathanael = require 'src.entities.heroes.nathanael'
local Kori = require 'src.entities.heroes.kori'
local Keon = require 'src.entities.heroes.keon'
local Hakiko = require 'src.entities.heroes.hakiko'
local Cloud = require 'src.entities.heroes.cloud'
local Brunnos = require 'src.entities.heroes.brunnos'
local Brae = require 'src.entities.heroes.brae'
local Aurora = require 'src.entities.heroes.aurora'
local Alestra = require 'src.entities.heroes.alestra'
local ModSlot = require 'src.entities.modSlot'
-- UI
local Menu = require 'src.gui.menu.menu'
local HUD = require 'src.gui.game.hud'
local BattleRewardWindow = require 'src.gui.game.battleRewardWindow'
local HeroRewardWindow = require 'src.gui.game.heroRewardWindow'
local DealerWindow = require 'src.gui.game.dealerWindow'
local Setting = require 'src.gui.setting.setting'
-- Enemies
-- mini enemies
local Mino = require 'src.entities.enemies.mino'
local Peach = require 'src.entities.enemies.peach'
local Amber = require 'src.entities.enemies.amber'
-- heavy enemies
local Rini = require 'src.entities.enemies.rini'
local Spinel = require 'src.entities.enemies.spinel'
local Elio =  require 'src.entities.enemies.elio'
-- gigantic enemies
local Arno = require 'src.entities.enemies.arno'
local Quad = require 'src.entities.enemies.quad'
local Granite = require 'src.entities.enemies.granite'
-- fast enemies
local Pepero = require 'src.entities.enemies.pepero'
local Sev = require 'src.entities.enemies.sev'
local Leo = require 'src.entities.enemies.leo'

local Game = Class('Game', State)

function Game:enter(from)
  State.enter(self, from)

  self:addSystems()
  self:initializeModSlots()

  local benchSlots = {}
  for x = 145, 190, 45 do
    for y = 200, 360, 40 do
      table.insert(benchSlots, self:addEntity(Slot('bench', x, y)))
    end
  end

  self:addEntity(Soniya(benchSlots[1]))
  self:addEntity(Cole(benchSlots[2]))
  self:addEntity(Tom(benchSlots[3]))
  -- self:addEntity(Sasami(slots[4]))
  -- self:addEntity(Skott(slots[5]))
  self:addEntity(Rover(benchSlots[6]))
  self:addEntity(Raylee(benchSlots[8]))
  -- self:addEntity(Nathanael(slots[8]))
  -- self:addEntity(Kori(slots[9]))
  self:addEntity(Keon(benchSlots[4]))
  -- self:addEntity(Hakiko(slots[11]))
  -- self:addEntity(Cloud(slots[12]))
  -- self:addEntity(Brunnos(slots[13]))
  -- self:addEntity(Brae(slots[14]))
  -- self:addEntity(Aurora(slots[15]))
  -- self:addEntity(Alestra(slots[16]))

  local teamSlots = {}
  table.insert(teamSlots, Slot('team', 234, 262))
  table.insert(teamSlots, Slot('team', 280, 284))
  table.insert(teamSlots, Slot('team', 280, 226))
  table.insert(teamSlots, Slot('team', 234, 320))
  table.insert(teamSlots, Slot('team', 234, 204))
  table.insert(teamSlots, Slot('team', 280, 342))
  
  local teamSynergy = TeamSynergy()
  teamSynergy:setTeamSlots(teamSlots)
  self:addEntity(Entity(teamSynergy, TeamUpdateObserver()))

  local resources = Resources()
  local phase = Phase()
  self:addEntity(Entity(resources), Phase())

  self.guis = {
    HUD(teamSlots, teamSynergy),
    BattleRewardWindow(),
    HeroRewardWindow(),
    DealerWindow(),
  }
end

function Game:addSystems()
  self:addSystem(DragAndDrop())
  self:addSystem(DrawSlot())
  self:addSystem(ManageTeamSynergy())
  self:addSystem(ManageHero())
  self:addSystem(Inspect())
  local manageEnemy = self:addSystem(ManageEnemy())
  self:addSystem(ManageResources())
  self:addSystem(ManageBullet())
  self:addSystem(UpdateTargetSkill())
  self:addSystem(UpdateAreaSkill())
  self:addSystem(ManageCandy())
  self:addSystem(ManageDrone())
  self:addSystem(UpdateTimer())
  self:addSystem(DrawRectangle())
  self:addSystem(UpdateTrap())
  self:addSystem(ManageProjectile())
  self:addSystem(Crack(manageEnemy))
end

function Game:initializeModSlots()
  local modSlots = {}
  for x = 1, 10 do
    for y = 1, 2 do
      table.insert(modSlots, self:addEntity(ModSlot(160 + 40 * (x-1), 80 + 35 * (y-1))))
    end
  end
end


function Game:update(dt)
  State.update(self, dt)

  Lume.each(self.guis, 'update', dt)
end

function Game:draw()
  -- Background
  love.graphics.setColor(1, 1, 1)

  love.graphics.draw(Images.environment.sky, 0, 0, 0, 2, 2)

  local buildingsImage = Images.environment.buildings
  DEBUG.buildingsX = DEBUG.buildingsX - DEBUG.buildingsSpeed * love.timer.getDelta()
  if DEBUG.buildingsX + buildingsImage:getWidth() * 2 < 0 then
    DEBUG.buildingsX = DEBUG.buildingsX + buildingsImage:getWidth() * 2
  end
  for i = 0, 1 do
    love.graphics.draw(buildingsImage, DEBUG.buildingsX + buildingsImage:getWidth() * 2 * i, 0, 0, 2, 2)
  end

  love.graphics.draw(Images.environment.platform, 0, 0, 0, 2, 2)

  State.draw(self)

  if self.guis[3].isOpened then
    if self.guis[3].isOn then
      self.guis[1].suit:updateMouse(math.huge, math.huge, false)
      self.guis[1]:draw()

      self.guis[2].suit:updateMouse(math.huge, math.huge, false)
      self.guis[2]:draw()

      self.guis[3]:draw()
    else
      self.guis[1].suit:updateMouse(math.huge, math.huge, false)
      self.guis[1]:draw()

      self.guis[3]:draw()
    end

  elseif self.guis[2].isOpened then
    self.guis[1].suit:updateMouse(math.huge, math.huge, false)
    self.guis[1]:draw()

    self.guis[2]:draw()

  elseif self.guis[4].isOpened then
    if self.guis[4].isOn then
      self.guis[1].suit:updateMouse(math.huge, math.huge, false)
      self.guis[1]:draw()
      
      self.guis[4]:draw()
    else
      self.guis[1]:draw()
    end

  else
    self.guis[1]:draw()
  end

  -- love.graphics.print(love.timer.getFPS())
end

function Game:keypressed(key, scancode, isRepeat)
  if love.keyboard.isDown('lctrl') then
    if scancode == 'd' then
      self.guis[2]:open({mainType = 'enemy', subType = '~1'})
    elseif scancode == 'f' then
      self.guis[4]:open(1)
    end
  end

  if not self.guis[2].isOpened and not self.guis[3].isOpened then
    State.keypressed(self, key, scancode, isRepeat)
  end
end

function Game:keyreleased(key, scancode, isRepeat)
  if not self.guis[2].isOpened and not self.guis[3].isOpened then
    State.keyreleased(self, key, scancode, isRepeat)
  end
end

function Game:mousepressed(...)
  if not self.guis[2].isOpened and not self.guis[3].isOpened then
    State.mousepressed(self, ...)
  end
end

function Game:mousereleased(...)
  if not self.guis[2].isOpened and not self.guis[3].isOpened then
    State.mousereleased(self, ...)
  end
end

return Game