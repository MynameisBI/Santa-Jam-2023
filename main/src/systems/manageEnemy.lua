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
    print(self.phase:current())

    if round.mainType == 'enemy' then
        self.spawnQueue = {
        Mino, 0, Mino, 0,
        Rini, 3, Rini, 3,
        Arno, 6, Arno, 6, Pepero, 6, Pepero, 6, Pepero, 6, Pepero, 6
        }
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
  dt = dt * 0.5
    transform:setGlobalPosition(transform.x - enemy:getSpeed() * dt, transform.y)

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
        if #self.spawnQueue <= 0 and #Hump.Gamestate.current():getComponents('Enemy') <= 0 then
            self.phase:switchNextRound()
            self.phase:switch('planning')
        end
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
          love.graphics.setColor(0.8, 0.8, 0.8, 0.4)
          love.graphics.rectangle('fill', x + 4, y - 4, w - 8, h/10)
          love.graphics.setColor(0.8, 0.15, 0.2)
          love.graphics.rectangle('fill', x + 4, y - 4, ratio*(w - 8), h/10)
        end)
    end
end

function ManageEnemy:removeEnemies(enemy)
    if enemy.stats.HP <= 0 then
        Hump.Gamestate.current():removeEntity(transform:getEntity())
    end
    print('enemy removed')
end

return ManageEnemy