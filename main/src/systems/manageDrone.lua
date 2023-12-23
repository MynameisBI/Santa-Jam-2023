local Phase = require 'src.components.phase'
local TeamSynergy = require 'src.components.teamSynergy'

local Entity = require 'src.entities.entity'
local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'
local Drone = require 'src.components.drone'

local BulletEntity = require 'src.entities.bullets.bulletEntity'

local System = require 'src.systems.system'

local ManageDrone = Class('ManageDrone', System)

function ManageDrone:initialize()
  System.initialize(self, 'Transform', 'Drone')

  self.phase = Phase()
  self.lastFramePhase = self.phase:current()

  self.teamSynergy = TeamSynergy()

  self.secondsPerDroneSpawn = 5
  self.secondsToSpawnDrone = 0
  self.droneDamage = 5
  self.spawningDrone = false
end

function ManageDrone:earlysystemupdate(dt)
  if self.lastFramePhase ~= self.phase:current() then
    if self.phase:current() == 'battle' then
      local droneMaestroSynergy = Lume.match(self.teamSynergy.synergies, function(synergy) return synergy.trait == 'droneMaestro' end)
      if droneMaestroSynergy then
        if droneMaestroSynergy.nextThresholdIndex ~= 1 then
          self.spawningDrone = true
          self.secondsToSpawnDrone = 0
          self.droneDamage =
              self.teamSynergy.DRONE_MAESTRO_DRONE_DAMAGE_THRESHOLD[droneMaestroSynergy.nextThresholdIndex-1]
        end
      end

    elseif self.phase:current() == 'planning' then
      self.spawningDrone = false

    end
  end
  self.lastFramePhase = self.phase:current()

  if self.spawningDrone then
    self.secondsToSpawnDrone = self.secondsToSpawnDrone - dt
    if self.secondsToSpawnDrone <= 0 then
      self.secondsToSpawnDrone = self.secondsToSpawnDrone + self.secondsPerDroneSpawn

      local droneMaestroHeroes = Lume.filter(self.teamSynergy:getHeroComponentsInTeam(),
          function(hero) return hero:hasTrait('droneMaestro') end) 
      for _, droneMaestroHero in ipairs(droneMaestroHeroes) do
        local x, y = droneMaestroHero:getEntity():getComponent('Transform'):getGlobalPosition()
        Hump.Gamestate.current():addEntity(Entity(
          Transform(x, y, 0, 2, 2),
          Sprite(Images.pets.drone, 14),
          Drone(self.droneDamage)
        ))
      end
    end
  end
end

function ManageDrone:update(transform, drone, dt)
  drone.timer:update(dt)

  transform:setGlobalPosition(drone.targetX, drone.targetY)

  drone.secondsUntilAttackReady = drone.secondsUntilAttackReady - dt
  if drone.secondsUntilAttackReady <= 0 then
    local stats = drone.stats
    drone.secondsUntilAttackReady = 1 / stats.attackSpeed 
    
    local x, y = transform:getGlobalPosition()
    local enemyEntities = Hump.Gamestate.current():getEntitiesWithComponent('Enemy')
    local nearestEnemyEntity = Lume.nearest(x, y, enemyEntities,
        function(enemyEntity) return enemyEntity:getComponent('Transform'):getGlobalPosition() end)
    
    if nearestEnemyEntity then
      local ex, ey = nearestEnemyEntity:getComponent('Transform'):getGlobalPosition()

      if Lume.distance(x, y, ex, ey) <= stats.range then
        Hump.Gamestate.current():addEntity(
          BulletEntity(x, y, Images.pets.drone, drone, nearestEnemyEntity)
        )
      end
    end
  end
end

return ManageDrone