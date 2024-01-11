local Entity = require 'src.entities.entity'
local System = require 'src.systems.system'
local Phase = require 'src.components.phase'
local Resources = require 'src.components.resources'
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

local ManageEnemy = System:subclass('ManageEnemy')
local ENEMY_X_VARIANCE = 60

function ManageEnemy:initialize()
  System.initialize(self, 'Transform', 'Area', 'Enemy')
  self.timer = Hump.Timer()

  self.phase = Phase()
  self.lastFramePhase = self.phase:current()
  self.resources = Resources()

  self.spawnQueue = {}
  self.isReadyToSpawn = true
  self.spawnCD = false
end

function ManageEnemy:earlysystemupdate(dt)
  if self.lastFramePhase ~= self.phase:current() and self.phase:current() == 'battle' then
  local round = self.phase:getCurrentRound()

  if round.mainType == 'enemy' then
    if round.subType == '~1' then
      self.spawnQueue = {
        Mino, 0, Mino, 1.75, Mino, 3.5, Mino, 5.25,
      }

    elseif round.subType == '~2' then
      self.spawnQueue = {
        Mino, 0, Mino, 1, Mino, 2, Mino, 3,
        Mino, 6, Mino, 7, Mino, 8, Mino, 9,
      }

    elseif round.subType == 'A1' then
      self.spawnQueue = {
        Mino, 0, Mino, 0, Mino, 1, Mino, 1, Mino, 2, Mino, 2, Mino, 3, Mino, 3,
        Rini, 5, Rini, 6,
        Mino, 9, Mino, 9, Mino, 10, Mino, 10, Mino, 11, Mino, 11, Mino, 12, Mino, 12,
        Rini, 13, Rini, 14, Rini, 15,
      }
      
    elseif round.subType == 'A6' then
      self.spawnQueue = {
        Mino, 0, Mino, 0, Mino, 1, Mino, 1, Mino, 2, Mino, 2, Mino, 3, Mino, 3,
        Rini, 4, Rini, 5,
        Pepero, 8, Pepero, 8.5, Pepero, 9, Pepero, 9.5,
        Mino, 12, Mino, 12, Mino, 13, Mino, 13, Mino, 14, Mino, 14, Mino, 15, Mino, 15,
        Rini, 16, Rini, 17,
        Pepero, 20, Pepero, 20.5, Pepero, 21, Pepero, 22.5,
        Rini, 23, Rini, 24,
        Pepero, 26, Pepero, 26.5, Pepero, 27, Pepero, 27.5, Pepero, 28, Pepero, 28.5
      }
    
    elseif round.subType == 'A11' then
      self.spawnQueue = {
        Rini, 0, Rini, 0.75, Rini, 1.5, Rini, 2.25,
        Pepero, 4, Pepero, 4.5, Pepero, 5, Pepero, 5.5,
        Arno, 7, Arno, 8,
        Mino, 12, Mino, 12, Mino, 13, Mino, 13, Mino, 14, Mino, 14, Mino, 15, Mino, 15,

        Rini, 18, Rini, 18.75, Rini, 19.5, Rini, 20.25,
        Pepero, 22, Pepero, 22.5, Pepero, 23, Pepero, 23.5,
        Arno, 25, Arno, 26, Arno, 27, Arno, 28
      }
    
    elseif round.subType == 'B1' then

    elseif round.subType == 'B6' then

    elseif round.subType == 'B11' then

    elseif round.subType == 'C0' then

    elseif round.subType == 'C5' then

    elseif round.subType == 'C10' then

    end

  elseif round.mainType == 'elite' then
      -- Code for handling elite round
  elseif round.mainType == 'dealer' then
      -- Code for handling dealer round
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

function ManageEnemy:update(transform, area, enemy, dt)
  enemy.timer:update(dt)
  if not enemy.isBeingKnocked then
    transform:setGlobalPosition(transform.x - enemy:getSpeed() * dt, transform.y)
  end

  for i = #enemy.effects, 1, -1 do
    enemy.effects[i].duration = enemy.effects[i].duration - dt
    if enemy.effects[i].duration <= 0 then
      table.remove(enemy.effects, i)
    end
  end

  local x, y = transform:getGlobalPosition()
  local isDead = enemy.stats.HP <= 0
  local hasReachedPlatform = x < 330
  if hasReachedPlatform then
    self.resources:modifyHealth(-enemy.stats.damage)
  end
  if isDead or hasReachedPlatform then
    Hump.Gamestate.current():removeEntity(transform:getEntity())
    enemy.isDestroyed = true
    self:onEnemyDie()
  end
end

function ManageEnemy:latesystemupdate(dt)
    self.lastFramePhase = self.phase:current()
end

function ManageEnemy:worlddraw(transform, area, enemy)
  if enemy then
    local x, y = transform:getGlobalPosition()
    local w, h = area:getSize()
    local ratio = math.max(0, enemy.stats.HP / enemy.stats.maxHP)
    
    Deep.queue(18, function()
      love.graphics.setColor(1, 1, 1, 0.75)
      if enemy:getAppliedEffect('skottMark') then
        love.graphics.draw(Images.icons.skottMarkIcon, x + w/2 - 5, y, 0, 2, 2)
      end
      if enemy:getAppliedEffect('reducePhysicalArmor') then
        love.graphics.draw(Images.icons.reducePhysicalArmorIcon, x + w, y - 2, 0, 2, 2)
      end
      if enemy:getAppliedEffect('reduceRealityArmor') then
        love.graphics.draw(Images.icons.reduceRealityArmorIcon, x + w, y - 12, 0, 2, 2)
      end

      love.graphics.setColor(0.8, 0.8, 0.8, 0.4)
      love.graphics.rectangle('fill', x + 4, y - 4, w - 8, h/10)
      love.graphics.setColor(0.8, 0.15, 0.2)
      love.graphics.rectangle('fill', x + 4, y - 4, ratio * (w - 8), h/10)
    end)
  end
end

function ManageEnemy:removeEnemies(enemy)
  if enemy.stats.HP <= 0 then
    Hump.Gamestate.current():removeEntity(transform:getEntity())
  end
end

function ManageEnemy:onEnemyDie()
  if #self.spawnQueue <= 0 and #Hump.Gamestate.current():getComponents('Enemy') <= 0 then
    Hump.Gamestate.current().guis[2]:open(self.phase:getCurrentRound())

    self.phase:switchNextRound()
    self.phase:switch('planning')
  end
end

return ManageEnemy