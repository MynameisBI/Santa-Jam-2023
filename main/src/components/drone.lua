local Component = require 'src.components.component'
local AllyStats = require 'src.type.allyStats'

local Drone = Class('Drone', Component)

Drone.MIN_X = 380
Drone.MAX_X = 800
Drone.TOP_Y = 160
Drone.BOT_Y = 400

function Drone:initialize(damage)
  Component.initialize(self)
  
  self.stats = AllyStats(
    damage, 0,
    0.5, 300,
    0, 0,
    0, 0
  )

  self.speed = 60
  self.timer = Hump.Timer.new()

  self.secondsUntilAttackReady = 0
end

function Drone:entityadded()
  self.targetX, self.targetY = self:getEntity():getComponent('Transform'):getGlobalPosition()

  self.isLeft = false
  self.pingpongX = function()
    if not self.isLeft then
      self.timer:tween((self.targetX - Drone.MIN_X) / self.speed, self, {targetX = Drone.MIN_X}, 'linear', self.pingpongX)
    else
      self.timer:tween((Drone.MAX_X - self.targetX) / self.speed, self, {targetX = Drone.MAX_X}, 'linear', self.pingpongX)
    end
    self.isLeft = not self.isLeft
  end

  self.baseY = Lume.randomchoice({Drone.TOP_Y, Drone.BOT_Y})
  self.var = 10
  self.speedY = 20
  self.isUpper = (self.baseY ~= Drone.TOP_Y) and true or false
  self.pingpongY = function()
    if not self.isUpper then
      local upperY = self.baseY - self.var
      self.timer:tween((self.targetY - upperY) / self.speedY, self,
          {targetY = upperY}, 'linear', self.pingpongY)
    else
      local lowerY = self.baseY + self.var
      self.timer:tween((lowerY - self.targetY) / self.speedY, self,
          {targetY = lowerY}, 'linear', self.pingpongY)
    end
    self.isUpper = not self.isUpper
  end

  self.timer:tween(1, self, {targetX = math.random(Drone.MIN_X, Drone.MAX_X)}, 'out-quad',
      function() self.timer:after(0.75, self.pingpongX) end)
  self.timer:tween(1, self, {targetY = self.baseY}, 'out-back',
      function() self.timer:after(0.25, self.pingpongY) end)
end

function Drone:getBasicAttackDamage()
  return self.stats.attackDamage
end

return Drone