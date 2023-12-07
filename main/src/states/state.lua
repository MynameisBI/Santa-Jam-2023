local Entity = require 'src.entities.entity'

local CameraManager = require 'src.components.cameraManager'
local Input = require 'src.components.input'
local BumpWorld = require 'src.components.bumpWorld'

local DrawWorld = require 'src.systems.drawWorld'
local DrawScreen = require 'src.systems.drawScreen'
local ManageInput = require 'src.systems.manageInput'
local ManageBumpWorld = require 'src.systems.manageBumpWorld'

local State = Class('State')

function State:enter(from)
  self.entities = {}

  self.systems = {}
  
  self.systemManagers = {
    entityadded = self:_getSystemManager('entityadded'),
    entityremoved = self:_getSystemManager('entityremoved'),
    update = self:_getSystemManager('update'),
    worlddraw = self:_getSystemManager('worlddraw'),
    screendraw = self:_getSystemManager('screendraw'),
    keypressed = self:_getSystemManager('keypressed'),
    keyreleased = self:_getSystemManager('keyreleased'),
    mousepressed = self:_getSystemManager('mousepressed'),
    mousereleased = self:_getSystemManager('mousereleased'),
    mousemoved = self:_getSystemManager('mousemoved'),
  }

  -- Add all the singletons into one entity
  local cameraManager = CameraManager()
  cameraManager:addCamera('main', CameraManager.Camera())
  self.input = Input()
  self:addEntity(Entity(
    cameraManager, self.input, BumpWorld()
  ))

  self:addSystem(DrawWorld())
  self:addSystem(DrawScreen())
  self:addSystem(ManageInput())
  self:addSystem(ManageBumpWorld())
end

function State:addEntity(entity)
  self.entities[#self.entities+1] = entity
  Lume.each(self.systems, self.systemManagers.entityadded, entity)
  return entity
end

function State:removeEntity(entity)
  for i, e in ipairs(self.entities) do
    if e == entity then
      table.remove(self.entities, i)
      Lume.each(self.systems, self.systemManagers.entityremoved, entity)
      break
    end
  end
end

function State:addSystem(system)
  self.systems[#self.systems+1] = system
  return system
end

function State:removeSystem(system)
  for i, s in ipairs(self.systems) do
    if s == system then
      table.remove(self.systems, i)
      break
    end
  end
end

function State:_getSystemManager(callback)
  return Knife.System(
    {'_entity', callback},
    function(system, func, ...)
      Lume.each(self.entities, func, ...)
    end
  )
end

function State:update(dt)
  Lume.each(self.systems, self.systemManagers.update, dt)
  self.input:clear()
end

function State:draw()
  Lume.each(
    self.systems, self.systemManagers.screendraw,
    function(camX, camY, camW, camH)
      Lume.each(self.systems, self.systemManagers.worlddraw, camX, camY, camW, camH)
    end
  )
end

function State:keypressed(key, scancode, isrepeat)
  Lume.each(self.systems, self.systemManagers.keypressed, key, scancode, isrepeat)
end

function State:keyreleased(key, scancode)
  Lume.each(self.systems, self.systemManagers.keyreleased, key, scancode, isrepeat)
end

function State:mousepressed(x, y, button, istouch, presses)
  Lume.each(self.systems, self.systemManagers.mousepressed, x, y, button, istouch, presses)
end

function State:mousereleased(x, y, button, istouch, presses)
  Lume.each(self.systems, self.systemManagers.mousereleased, x, y, button, istouch, presses)
end

function State:mousemoved(x, y, dx, dy, istouch)
  Lume.each(self.systems, self.systemManagers.mousemoved, x, y, dx, dy, istouch)
end

return State