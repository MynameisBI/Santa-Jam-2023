-- Enemies
-- mini enemies
local Mino = require 'src.entities.enemies.mino'
local Peach = require 'src.entities.enemies.peach'
local Amber = require 'src.entities.enemies.amber'
-- heavy enemies
local Rini = require 'src.entities.enemies.rini'
local Spinel = require 'src.entities.enemies.spinel'
local Elio =  require 'src.entities.enemies.elio'
-- gigantic enemiesTransform
local Arno = require 'src.entities.enemies.arno'
local Quad = require 'src.entities.enemies.quad'
local Granite = require 'src.entities.enemies.granite'
-- fast enemies
local Pepero = require 'src.entities.enemies.pepero'
local Sev = require 'src.entities.enemies.sev'
local Leo = require 'src.entities.enemies.leo'

local Phase = require 'src.components.phase'

local System = require 'src.systems.system'

local ManageEnemy = System:subclass('ManageEnemy')

local ENEMY_X_VARIANCE = 60

function ManageEnemy:initialize()
    System.initialize(self, 'Transform', 'Enemy')
    self.timer = Hump.Timer()

  self.phase = Phase()
  self.lastFramePhase = self.phase:current()

  self.spawnQueue = {}
  self.isReadyToSpawn = true
  print('enemy spawner initialized')
end

function ManageEnemy:earlysystemupdate(dt)
  if self.lastFramePhase ~= self.phase:current() and self.phase:current() == 'battle' then
    local round = self.phase:getCurrentRound()

    if round.mainType == 'enemy' then
      self.spawnQueue = {
        Mino, 0, Mino, 0,
        Rini, 3, Rini, 3,
        Arno, 6, Arno, 6, Pepero, 6, Pepero, 6, Pepero, 6, Pepero, 6,
      }

    elseif round.mainType == 'elite' then
      

    elseif round.mainType == 'dealer' then
      

    end
  end

  if self.phase:current() == 'battle' then
    for i = #self.spawnQueue, 1, -2 do
      self.spawnQueue[i] = self.spawnQueue[i] - dt
      if self.spawnQueue[i] <= 0 then
        local enemyEntity = self.spawnQueue[i-1]()
        enemyEntity:getComponent('Transform'):setGlobalPosition(
          1000 + math.random(-ENEMY_X_VARIANCE, ENEMY_X_VARIANCE),
          math.random(210, 330)
        )
        Hump.Gamestate.current():addEntity(enemyEntity)
        table.remove(self.spawnQueue, i-1)
        table.remove(self.spawnQueue, i-1)
      end
    end
  end
end

function ManageEnemy:update(transform, enemy, dt)
    transform:setGlobalPosition(transform.x-100*dt, transform.y)

  local x, y = transform:getGlobalPosition()
  if x < -50 then
    Hump.Gamestate.current():removeEntity(transform:getEntity())

    if #self.spawnQueue <= 0 and #Hump.Gamestate.current():getComponents('Enemy') <= 0 then
      self.phase:switchNextRound()
      self.phase:switch('planning')
    end
  end
end

function ManageEnemy:latesystemupdate(dt)
  self.lastFramePhase = self.phase:current()
end

return ManageEnemy