local Phase = require 'src.components.phase'
local TeamSynergy = require 'src.components.teamSynergy'

local Entity = require 'src.entities.entity'
local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'
local Candy = require 'src.components.candy'
local AudioManager = require 'src.components.audioManager'

local System = require 'src.systems.system'

local EnemyEffect = require 'src.type.enemyEffect'

local ManageCandy = Class('ManageCandy', System)

ManageCandy.CANDY_SPAWN_INTERVAL = 3
ManageCandy.CANDY_DAMAGE_TYPE = 'reality'
ManageCandy.CANDY_DAMAGE = 25
ManageCandy.CANDY_ARMOR_IGNORE_RATIO = 0
ManageCandy.CANDY_STUN_DURATION = 1

function ManageCandy:initialize()
  System.initialize(self, 'Transform', 'Candy')

  self.phase = Phase()
  self.lastFramePhase = self.phase:current()

  self.teamSynergy = TeamSynergy()

  self.secondsPerCandySpawn = ManageCandy.CANDY_SPAWN_INTERVAL
  self.secondsToSpawnCandy = ManageCandy.CANDY_SPAWN_INTERVAL
  self.spawningCandy = false
end

function ManageCandy:earlysystemupdate(dt)
  if self.lastFramePhase ~= self.phase:current() then
    if self.phase:current() == 'battle' then
      local candyheadSynergy = Lume.match(self.teamSynergy.synergies, function(synergy) return synergy.trait == 'candyhead' end)
      if candyheadSynergy then
        if candyheadSynergy.nextThresholdIndex ~= 1 then
          self.spawningCandy = true
          self.secondsToSpawnCandy = self.secondsPerCandySpawn
        end
      end

    elseif self.phase:current() == 'planning' then
      self.spawningCandy = false

    end
  end
  self.lastFramePhase = self.phase:current()

  if self.spawningCandy then
    self.secondsToSpawnCandy = self.secondsToSpawnCandy - dt
    if self.secondsToSpawnCandy <= 0 then
      self.secondsToSpawnCandy = self.secondsToSpawnCandy + self.secondsPerCandySpawn

      local level3Heroes = Lume.filter(Hump.Gamestate.current():getComponents('Hero'), function(hero)
        return hero.level >= 3
      end)

      for i = 1, 3 + #level3Heroes do
        local targetX, targetY = math.random(400, 780), math.random(210, 330)
        Hump.Gamestate.current():addEntity(Entity(
          Transform(targetX - 150, targetY - 800, 0, 2, 2),
          Sprite(Images.pets.candy, 16),
          Candy(targetX, targetY, 120, 800 + math.random(-200, 200))
        ))
      end
    end
  end
end

function ManageCandy:update(transform, candy, dt)
  local x, y = transform:getGlobalPosition()
  local dirX, dirY = Lume.vector(Lume.angle(x, y, candy.targetX, candy.targetY), 1)
  local distX, distY = dirX * candy.speed * dt, dirY * candy.speed * dt
  transform:setGlobalPosition(x + distX, y + distY)

  x, y = transform:getGlobalPosition()
  if Lume.distance(x, y, candy.targetX, candy.targetY, true) < 100 then
    local enemyEntities = Hump.Gamestate.current():getEntitiesWithComponent('Enemy')
    enemyEntities = Lume.filter(enemyEntities, function(enemy)
      local ex, ey = enemy:getComponent('Transform'):getGlobalPosition()
      return Lume.distance(x, y, ex, ey) < candy.radius
    end)
    for _, enemyEntity in ipairs(enemyEntities) do
      local enemy = enemyEntity:getComponent('Enemy')
      enemy:takeDamage(ManageCandy.CANDY_DAMAGE, ManageCandy.CANDY_DAMAGE_TYPE,
          ManageCandy.CANDY_ARMOR_IGNORE_RATIO, 'candy')
      enemy:applyEffect(EnemyEffect('stun', ManageCandy.CANDY_STUN_DURATION))
    end

    AudioManager:playSound('fall-down', 0.2)
    
    Hump.Gamestate.current():removeEntity(transform:getEntity())
  end
end

return ManageCandy