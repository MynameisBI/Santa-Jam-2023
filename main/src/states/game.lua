local State = require 'src.states.state'

local DragAndDrop = require 'src.systems.dragAndDrop'
local ManageTeamSynergy = require 'src.systems.manageTeamSynergy'

local TeamSynergy = require 'src.components.teamSynergy'
local TeamUpdateObserver = require 'src.components.teamUpdateObserver'
local Resources = require 'src.components.resources'

local Entity = require 'src.entities.entity'
local Slot = require 'src.entities.slot'

local HUD = require 'src.gui.game.hud'
local BattleRewardWindow = require 'src.gui.game.battleRewardWindow'
local HeroRewardWindow = require 'src.gui.game.heroRewardWindow'

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

local Game = Class('Game', State)

function Game:enter(from)
  State.enter(self, from)

  self:addSystem(DragAndDrop())
  self:addSystem(ManageTeamSynergy())

  local slots = {}
  table.insert(slots, self:addEntity(Slot('bench', 145, 165)))
  table.insert(slots, self:addEntity(Slot('bench', 185, 165)))
  table.insert(slots, self:addEntity(Slot('bench', 145, 205)))
  table.insert(slots, self:addEntity(Slot('bench', 185, 205)))
  table.insert(slots, self:addEntity(Slot('bench', 145, 245)))
  table.insert(slots, self:addEntity(Slot('bench', 185, 245)))
  table.insert(slots, self:addEntity(Slot('bench', 145, 285)))
  table.insert(slots, self:addEntity(Slot('bench', 185, 285)))
  table.insert(slots, self:addEntity(Slot('bench', 145, 325)))
  table.insert(slots, self:addEntity(Slot('bench', 185, 325)))
  table.insert(slots, self:addEntity(Slot('bench', 100, 165)))
  table.insert(slots, self:addEntity(Slot('bench', 100, 205)))
  table.insert(slots, self:addEntity(Slot('bench', 100, 245)))
  table.insert(slots, self:addEntity(Slot('bench', 100, 285)))
  table.insert(slots, self:addEntity(Slot('bench', 100, 325)))
  table.insert(slots, self:addEntity(Slot('bench', 60, 245)))

  table.insert(slots, self:addEntity(Slot('team', 234, 174)))
  table.insert(slots, self:addEntity(Slot('team', 280, 190)))
  table.insert(slots, self:addEntity(Slot('team', 234, 232)))
  table.insert(slots, self:addEntity(Slot('team', 280, 248)))
  table.insert(slots, self:addEntity(Slot('team', 234, 290)))
  table.insert(slots, self:addEntity(Slot('team', 280, 306)))

  self:addEntity(Soniya(slots[1]))
  self:addEntity(Cole(slots[2]))
  self:addEntity(Tom(slots[3]))
  self:addEntity(Sasami(slots[4]))
  self:addEntity(Skott(slots[5]))
  self:addEntity(Rover(slots[6]))
  self:addEntity(Raylee(slots[7]))
  self:addEntity(Nathanael(slots[8]))
  self:addEntity(Kori(slots[9]))
  self:addEntity(Keon(slots[10]))
  self:addEntity(Hakiko(slots[11]))
  self:addEntity(Cloud(slots[12]))
  self:addEntity(Brunnos(slots[13]))
  self:addEntity(Brae(slots[14]))
  self:addEntity(Aurora(slots[15]))
  self:addEntity(Alestra(slots[16]))

  local teamSynergy = TeamSynergy(Lume.filter(slots, function(slot) return slot:getComponent('DropSlot').slotType == 'team' end))
  self:addEntity(Entity(teamSynergy, TeamUpdateObserver()))

  local resources = Resources()
  self:addEntity(Entity(resources))

  self.guis = {
    HUD(resources, teamSynergy),
    BattleRewardWindow(),
    HeroRewardWindow()
  }
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
    self.guis[1].suit:updateMouse(math.huge, math.huge, false)
    self.guis[1]:draw()

    self.guis[2].suit:updateMouse(math.huge, math.huge, false)
    self.guis[2]:draw()

    self.guis[3]:draw()

  elseif self.guis[2].isOpened then
    self.guis[1].suit:updateMouse(math.huge, math.huge, false)
    self.guis[1]:draw()

    self.guis[2]:draw()

  else
    self.guis[1]:draw()
  end
end

function Game:keypressed(key, scancode, isRepeat)
  State.keypressed(self, key, scancode, isRepeat)

  if love.keyboard.isDown('lctrl') and scancode == 'b' then
    self.guis[2]:open()
  end
end

return Game