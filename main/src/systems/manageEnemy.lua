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
        Mino, 4, Mino, 5, Mino, 6, Mino, 7,
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
        Arno, 25, Arno, 26,
      }
    
    elseif round.subType == 'B1' then
      self.spawnQueue = {
        Peach, 0, Peach, 0, Peach, 1, Peach, 1, Peach, 2, Peach, 2, Peach, 3, Peach, 3,
        Spinel, 5, Spinel, 6,
        Peach, 9, Peach, 9, Peach, 10, Peach, 10, Peach, 11, Peach, 11, Peach, 12, Peach, 12,
        Spinel, 13, Spinel, 14, Spinel, 15,
      }

    elseif round.subType == 'B6' then
      self.spawnQueue = {
        Peach, 0, Peach, 0, Peach, 1, Peach, 1, Peach, 2, Peach, 2, Peach, 3, Peach, 3,
        Spinel, 4, Spinel, 5,
        Sev, 8, Sev, 8.5, Sev, 9, Sev, 9.5,
        Peach, 12, Peach, 12, Peach, 13, Peach, 13, Peach, 14, Peach, 14, Peach, 15, Peach, 15,
        Spinel, 16, Spinel, 17,
        Sev, 20, Sev, 20.5, Sev, 21, Sev, 22.5,
        Spinel, 23, Spinel, 24,
        Sev, 26, Sev, 26.5, Sev, 27, Sev, 27.5, Sev, 28, Sev, 28.5
      }

    elseif round.subType == 'B11' then
      self.spawnQueue = {
        Spinel, 0, Spinel, 0.75, Spinel, 1.5, Spinel, 2.25,
        Sev, 4, Sev, 4.5, Sev, 5, Sev, 5.5,
        Quad, 7, Quad, 8,
        Peach, 12, Peach, 12, Peach, 13, Peach, 13, Peach, 14, Peach, 14, Peach, 15, Peach, 15,
        Spinel, 18, Spinel, 18.75, Spinel, 19.5, Spinel, 20.25,
        Sev, 22, Sev, 22.5, Sev, 23, Sev, 23.5,
        Quad, 25, Quad, 26,
      }

    elseif round.subType == 'C1' then
      self.spawnQueue = {
        Amber, 0, Amber, 0, Amber, 1, Amber, 1, Amber, 2, Amber, 2, Amber, 3, Amber, 3,
        Elio, 5, Elio, 6,
        Amber, 9, Amber, 9, Amber, 10, Amber, 10, Amber, 11, Amber, 11, Amber, 12, Amber, 12,
        Elio, 13, Elio, 14, Elio, 15,
      }

    elseif round.subType == 'C6' then
      self.spawnQueue = {
        Amber, 0, Amber, 0, Amber, 1, Amber, 1, Amber, 2, Amber, 2, Amber, 3, Amber, 3,
        Elio, 4, Elio, 5,
        Leo, 8, Leo, 8.5, Leo, 9, Leo, 9.5,
        Amber, 12, Amber, 12, Amber, 13, Amber, 13, Amber, 14, Amber, 14, Amber, 15, Amber, 15,
        Elio, 16, Elio, 17,
        Leo, 20, Leo, 20.5, Leo, 21, Leo, 22.5,
        Elio, 23, Elio, 24,
        Leo, 26, Leo, 26.5, Leo, 27, Leo, 27.5, Leo, 28, Leo, 28.5
      }

    elseif round.subType == 'C11' then
      self.spawnQueue = {
        Elio, 0, Elio, 0.75, Elio, 1.5, Elio, 2.25,
        Leo, 4, Leo, 4.5, Leo, 5, Leo, 5.5,
        Granite, 7, Granite, 8,
        Amber, 12, Amber, 12, Amber, 13, Amber, 13, Amber, 14, Amber, 14, Amber, 15, Amber, 15,
        Elio, 18, Elio, 18.75, Elio, 19.5, Elio, 20.25,
        Leo, 22, Leo, 22.5, Leo, 23, Leo, 23.5,
        Granite, 25, Granite, 26,
      }
    end

  elseif round.mainType == 'elite' then
    if round.subType == 'A1' then
      self.spawnQueue = {
        Arno, 0, Arno, 0.5, Arno, 1, Arno, 1.5,
        Mino, 5, Mino, 6, Mino, 7, Mino, 8, Mino, 9, Mino, 10,
        Arno, 10, Arno, 10.5, Arno, 11, Arno, 11.5,
        Pepero, 12, Pepero, 14, Pepero, 16, Pepero, 18,
        Arno, 20, Arno, 20.5, Arno, 21, Arno, 21.5
      }
    elseif round.subType == 'B1' then
      self.spawnQueue = {
        Quad, 0, Quad, 0.5, Quad, 1, Quad, 1.5,
        Peach, 5, Peach, 6, Peach, 7, Peach, 8, Peach, 9, Peach, 10,
        Quad, 10, Quad, 10.5, Quad, 11, Quad, 11.5,
        Sev, 12, Sev, 14, Sev, 16, Sev, 18,
        Quad, 20, Quad, 20.5, Quad, 21, Quad, 21.5
      }
    elseif round.subType == 'C1' then
      self.spawnQueue = {
        Granite, 0, Granite, 0.5, Granite, 1, Granite, 1.5,
        Amber, 5, Amber, 6, Amber, 7, Amber, 8, Amber, 9, Amber, 10,
        Granite, 10, Granite, 10.5, Granite, 11, Granite, 11.5,
        Leo, 12, Leo, 14, Leo, 16, Leo, 18,
        Granite, 20, Granite, 20.5, Granite, 21, Granite, 21.5
      }
    end
    
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
  local hasReachedPlatform = x < 310
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
      if enemy:getAppliedEffect('skottMark') then
        love.graphics.setColor(1, 1, 1, 0.75)
        love.graphics.draw(Images.icons.skottMarkIcon, x + w/2 - 5, y, 0, 2, 2)
      end
      if enemy:getAppliedEffect('reducePhysicalArmor') then
        love.graphics.setColor(1, 1, 1, 0.75)
        love.graphics.draw(Images.icons.reducePhysicalArmorIcon, x + w, y - 2, 0, 2, 2)
      end
      if enemy:getAppliedEffect('reduceRealityArmor') then
        love.graphics.setColor(1, 1, 1)
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