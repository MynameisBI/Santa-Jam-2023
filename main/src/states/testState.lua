local State = require 'src.states.state'
local Entity = require 'src.entities.entity'
local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'

local TestState = Class('TestState', State)

function TestState:enter(from)
  State.enter(self, from)

  self:addEntity(Entity(
    Transform(400, 300),
    Sprite()
  ))
end

function TestState:update(dt)
  State.update(self, dt)
end

return TestState