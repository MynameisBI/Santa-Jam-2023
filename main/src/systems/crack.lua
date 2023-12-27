local Phase = require 'src.components.phase'
local TeamSynergy = require 'src.components.teamSynergy'
local Resources = require 'src.components.resources'
local Entity = require 'src.entities.entity'
local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'
local Timer = require 'src.components.timer'

local System = require 'src.systems.system'

local Crack = Class('Crack', System)

function Crack:initialize(manageEnemy) -- war crime
  System.initialize(self)

  self.phase = Phase()
  self.lastFramePhase = self.phase:current()

  self.teamSynergy = TeamSynergy()

  self.secondsPerCrack = 4
  self.secondsToCrack = 4
  self.craking = false

  self.manageEnemy = manageEnemy
end

function Crack:earlysystemupdate(dt)
  if self.lastFramePhase ~= self.phase:current() then
    if self.phase:current() == 'battle' then
      local crackerSynergy = Lume.match(self.teamSynergy.synergies, function(synergy) return synergy.trait == 'cracker' end)
      if crackerSynergy then
        if crackerSynergy.nextThresholdIndex ~= 1 then
          self.cracking = true
          self.secondsPerCrack = self.teamSynergy.CRACKER_CRACK_INTERVAL_THRESHOLD[crackerSynergy.nextThresholdIndex-1]
          self.secondsToCrack = self.teamSynergy.CRACKER_CRACK_INTERVAL_THRESHOLD[crackerSynergy.nextThresholdIndex-1]
        end
      end

    elseif self.phase:current() == 'planning' then
      self.cracking = false

    end
  end
  self.lastFramePhase = self.phase:current()

  if self.cracking then
    self.secondsToCrack = self.secondsToCrack - dt
    if self.secondsToCrack <= 0 then
      local enemies = Hump.Gamestate.current():getComponents('Enemy')
      if #enemies == 0 then return end

      self.secondsToCrack = self.secondsToCrack + self.secondsPerCrack

      local highestHealthEnemy
      local highestHealth = -math.huge
      for _, enemy in ipairs(enemies) do
        local ex, ey = enemy:getEntity():getComponent('Transform'):getGlobalPosition()
        if enemy.stats.HP > highestHealth and ex < love.graphics.getWidth() - 24 then
          highestHealthEnemy = enemy
          highestHealth = enemy.stats.HP
        end
      end
      self:removeEnemyEntity(highestHealthEnemy)
    end
  end
end

function Crack:removeEnemyEntity(enemy)
  local enemyEntity = enemy:getEntity()

  Hump.Gamestate.current():removeEntity(enemyEntity)
  enemy.isDestroyed = true

  self.manageEnemy:onEnemyDie()

  local remain = Entity()
  local transform = remain:addComponent(enemyEntity:getComponent('Transform'))
  local sprite = remain:addComponent(enemyEntity:getComponent('Sprite'))
  remain:addComponent(enemyEntity:getComponent('Animator'))
  local timer = remain:addComponent(Timer())
  
  sprite:setColor('default', 0.7, 0.7, 0.7)
  sprite.layer = 14
  local x, y = transform:getGlobalPosition()
  timer.timer:tween(1, transform, {y = y - 60}, 'out-cubic')
  timer.timer:tween(1, sprite, {_alpha = 0}, 'linear', function()
    Hump.Gamestate.current():removeEntity(remain)
  end)
  Hump.Gamestate.current():addEntity(remain)

end

return Crack