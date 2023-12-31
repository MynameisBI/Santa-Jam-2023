local Component = require 'src.components.component'

--[[
This component combines 2 different types of information together
    animations info and states management info
If needed, this component can be splited into 2 components
    a state machine and an animator:
  the state machine holds the states and the transitions
  while the animator draws the animations and switch them up using the
      states in the state machine

PS: nah I splited them for you
]]--
local Animator = Component:subclass('Animator')

function Animator:initialize()
  Component.initialize(self)
  self.grid = nil
  self.animations = {}
  self.currentAnimationName = nil
end

function Animator:setGrid(...)
  -- Anim8.newGrid(frameWidth, frameHeight, imageWidth, imageHeight, left, top, border)
  self.grid = Anim8.newGrid(...)
end

function Animator:addAnimation(name, frames, durations, isLooping, onLoop)
  assert(self.grid ~= nil, 'A grid need to be set before adding new   animations')
  
  local isLooping = isLooping or true
  local onLoop = onLoop or function() end
  local onLoop_
  if isLooping then
    onLoop_ = function(...)
      onLoop(...)
    end
  else
    onLoop_ = function(...)
      onLoop(...)
      return 'pauseAtEnd'
    end
  end

  self.animations[name] = Anim8.newAnimation(self.grid(unpack(frames)), durations, onLoop_)
end

function Animator:setCurrentAnimationName(name)
  self.currentAnimationName = name
  self:getCurrentAnimation():gotoFrame(1)
end

function Animator:getCurrentAnimation()
  return self.animations[self.currentAnimationName]
end

return Animator
