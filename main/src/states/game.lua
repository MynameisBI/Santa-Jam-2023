local State = require 'src.states.state'

-- Systems
local DragAndDrop = require 'src.systems.dragAndDrop'
local DrawSlot = require 'src.systems.drawSlot'
local ManageTeamSynergy = require 'src.systems.manageTeamSynergy'
local Inspect = require 'src.systems.inspect'
local ManageHero = require 'src.systems.manageHero'
local ManageEnemy = require 'src.systems.manageEnemy'
-- Components
local TeamSynergy = require 'src.components.teamSynergy'
local TeamUpdateObserver = require 'src.components.teamUpdateObserver'
local Resources = require 'src.components.resources'
local Phase = require 'src.components.phase'
local Bullet = require 'src.components.bullet'
local Enemy = require 'src.components.enemy'
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
local ScrapPack = require 'src.entities.mods.scrapPack'
local PsychePack = require 'src.entities.mods.psychePack'
local BioPack = require 'src.entities.mods.bioPack'
local HarmonizerUnit = require 'src.entities.mods.harmonizerUnit'
local QuantumToken = require 'src.entities.mods.quantumToken'
local HullTransformer = require 'src.entities.mods.hullTransformer'
local BrainImplant = require 'src.entities.mods.brainImplant'
local SyntheticCore = require 'src.entities.mods.syntheticCore'
local NoradInhaler = require 'src.entities.mods.noradInhaler'
local TheConductor = require 'src.entities.mods.theConductor'
local SkaterayEqualizer = require 'src.entities.mods.skaterayEqualizer'
local RadioPopper = require 'src.entities.mods.radioPopper'
local AsymframeVisionary = require 'src.entities.mods.asymframeVisionary'
local AbovesSliver = require 'src.entities.mods.abovesSliver'
local SubcellularSupervisor = require 'src.entities.mods.subcellularSupervisor'
local NeuralProcessor = require 'src.entities.mods.neuralProcessor'
local BionicColumn = require 'src.entities.mods.bionicColumn'
local EnhancerFumes = require 'src.entities.mods.enhancerFumes'
local DeathsPromise = require 'src.entities.mods.deathsPromise'
-- UI
local HUD = require 'src.gui.game.hud'
local BattleRewardWindow = require 'src.gui.game.battleRewardWindow'
local HeroRewardWindow = require 'src.gui.game.heroRewardWindow'
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
  self:initializeEnemies()
  self:initializeModSlots()

  local slots = {}
  table.insert(slots, self:addEntity(Slot('bench', 145, 185)))
  table.insert(slots, self:addEntity(Slot('bench', 185, 185)))
  table.insert(slots, self:addEntity(Slot('bench', 145, 225)))
  table.insert(slots, self:addEntity(Slot('bench', 185, 225)))
  table.insert(slots, self:addEntity(Slot('bench', 145, 265)))
  table.insert(slots, self:addEntity(Slot('bench', 185, 265)))
  table.insert(slots, self:addEntity(Slot('bench', 145, 305)))
  table.insert(slots, self:addEntity(Slot('bench', 185, 305)))
  table.insert(slots, self:addEntity(Slot('bench', 145, 345)))
  table.insert(slots, self:addEntity(Slot('bench', 185, 345)))
  table.insert(slots, self:addEntity(Slot('bench', 100, 185)))
  table.insert(slots, self:addEntity(Slot('bench', 100, 225)))
  table.insert(slots, self:addEntity(Slot('bench', 100, 265)))
  table.insert(slots, self:addEntity(Slot('bench', 100, 305)))
  table.insert(slots, self:addEntity(Slot('bench', 100, 345)))
  table.insert(slots, self:addEntity(Slot('bench', 60, 265)))

  table.insert(slots, self:addEntity(Slot('team', 234, 194)))
  table.insert(slots, self:addEntity(Slot('team', 280, 210)))
  table.insert(slots, self:addEntity(Slot('team', 234, 252)))
  table.insert(slots, self:addEntity(Slot('team', 280, 268)))
  table.insert(slots, self:addEntity(Slot('team', 234, 310)))
  table.insert(slots, self:addEntity(Slot('team', 280, 326)))

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
  local phase = Phase(); phase:switch('planning')
  self:addEntity(Entity(resources), Phase())

  self.guis = {
    HUD(resources, teamSynergy),
    BattleRewardWindow(),
    HeroRewardWindow()
  }
end

function Game:addSystems()
  self:addSystem(DragAndDrop())
  self:addSystem(DrawSlot())
  self:addSystem(ManageTeamSynergy())
  self:addSystem(ManageHero())
  self:addSystem(Inspect())
  self:addSystem(ManageEnemy())
end

function Game:initializeEnemies()
  self:addEntity(Mino())
  -- self:addEntity(Peach())
  -- self:addEntity(Amber())
  -- self:addEntity(Rini())
  -- self:addEntity(Spinel())
  -- self:addEntity(Elio())
  -- self:addEntity(Arno())
  -- self:addEntity(Quad())
  -- self:addEntity(Granite())
  -- self:addEntity(Pepero())
  -- self:addEntity(Sev())
  -- self:addEntity(Leo())
end

function Game:initializeModSlots()
  local modSlots = {}
  for x = 1, 10 do
    for y = 1, 2 do
      table.insert(modSlots, self:addEntity(ModSlot(160 + 40 * (x-1), 80 + 35 * (y-1))))
    end
  end
  self:addEntity(ScrapPack(modSlots[1]))
  self:addEntity(PsychePack(modSlots[2]))
  self:addEntity(BioPack(modSlots[3]))
  self:addEntity(HarmonizerUnit(modSlots[4]))
  self:addEntity(QuantumToken(modSlots[5]))
  self:addEntity(HullTransformer(modSlots[6]))
  self:addEntity(BrainImplant(modSlots[7]))
  self:addEntity(SyntheticCore(modSlots[8]))
  self:addEntity(NoradInhaler(modSlots[9]))
  self:addEntity(TheConductor(modSlots[11]))
  self:addEntity(SkaterayEqualizer(modSlots[12]))
  self:addEntity(RadioPopper(modSlots[13]))
  self:addEntity(AsymframeVisionary(modSlots[14]))
  self:addEntity(AbovesSliver(modSlots[15]))
  self:addEntity(SubcellularSupervisor(modSlots[16]))
  self:addEntity(NeuralProcessor(modSlots[17]))
  self:addEntity(BionicColumn(modSlots[18]))
  self:addEntity(EnhancerFumes(modSlots[19]))
  self:addEntity(DeathsPromise(modSlots[20]))
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