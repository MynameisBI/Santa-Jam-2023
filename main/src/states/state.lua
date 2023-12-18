local Entity = require 'src.entities.entity'

local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'
local Animator = require 'src.components.animator'
local CameraManager = require 'src.components.cameraManager'
local Input = require 'src.components.input'
local BumpWorld = require 'src.components.bumpWorld'
local Area = require 'src.components.area'

local DrawWorld = require 'src.systems.drawWorld'
local DrawScreen = require 'src.systems.drawScreen'
local ManageInput = require 'src.systems.manageInput'
local ManageBumpWorld = require 'src.systems.manageBumpWorld'
local ManageHero = require 'src.systems.manageHero'

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
  self:addSystem(ManageHero())

  -- local animator = Animator()
  -- animator:setGrid(48, 48, 192, 192)
  -- animator:addAnimation('idle down', {'1-2', 1}, 0.2, true)
  -- animator:addAnimation('walk down', {'3-4', 1}, 0.2, true)
  -- animator:addAnimation('idle up', {'1-2', 2}, 0.2, true)
  -- animator:addAnimation('walk up', {'3-4', 2}, 0.2, true)
  -- animator:addAnimation('idle right', {'1-2', 3}, 0.2, true)
  -- animator:addAnimation('walk right', {'3-4', 3}, 0.2, true)
  -- animator:addAnimation('idle left', {'1-2', 4}, 0.2, true)
  -- animator:addAnimation('walk left', {'3-4', 4}, 0.2, true)
  -- animator:setCurrentAnimationName('idle down')

  -- Add the hero
  -- self:addEntity(Entity(
  --   Transform(200, 300, 0, 2, 2),
  --   Sprite(Images.diamond, 10),
  --   -- animator,
  --   Area(96, 96)
  -- ))
end

function State:addEntity(entity)
  self.entities[#self.entities+1] = entity
  entity:onAdded()
  Lume.each(self.systems, 'earlysystementityadded', entity)
  Lume.each(self.systems, self.systemManagers.entityadded, entity)
  Lume.each(self.systems, 'latesystementityadded', entity)
  return entity
end

function State:removeEntity(entity)
  for i, e in ipairs(self.entities) do
    if e == entity then
      table.remove(self.entities, i)
      Lume.each(self.systems, 'earlysystementityremoved', entity)
      Lume.each(self.systems, self.systemManagers.entityremoved, entity)
      Lume.each(self.systems, 'latesystementityremoved', entity)
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

function State:getEntitiesWithComponent(className)
  local entities = {}
  for _, entity in ipairs(self.entities) do
    if entity[className] then
      entities[#entities+1] = entity
    end
  end
  return entities
end

function State:getComponents(className)
  local components = {}
  for _, entity in ipairs(self.entities) do
    if entity[className] then
      components[#components+1] = entity[className]
    end
  end
  return components
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
  Lume.each(self.systems, 'earlysystemupdate', dt)
  Lume.each(self.systems, self.systemManagers.update, dt)
  Lume.each(self.systems, 'latesystemupdate', dt)
  self.input:clear()
end

function State:draw()
  local worlddrawFunc = function(camX, camY, camW, camH)
    Lume.each(self.systems, 'earlysystemworlddraw')
    Lume.each(self.systems, self.systemManagers.worlddraw, camX, camY, camW, camH)
    Lume.each(self.systems, 'latesystemworlddraw')
    Deep.execute()
  end

  Lume.each(self.systems, 'earlysystemscreendraw', worlddrawFunc)
  Lume.each(self.systems, self.systemManagers.screendraw, worlddrawFunc)
  Lume.each(self.systems, 'latesystemscreendraw', worlddrawFunc)
end

function State:keypressed(key, scancode, isrepeat)
  Lume.each(self.systems, 'earlysystemkeypressed', key, scancode, isrepeat)
  Lume.each(self.systems, self.systemManagers.keypressed, key, scancode, isrepeat)
  Lume.each(self.systems, 'latesystemkeypressed', key, scancode, isrepeat)
end

function State:keyreleased(key, scancode)
  Lume.each(self.systems, 'earlysystemkeyreleased', key, scancode, isrepeat)
  Lume.each(self.systems, self.systemManagers.keyreleased, key, scancode, isrepeat)
  Lume.each(self.systems, 'latesystemkeyreleased', key, scancode, isrepeat)
end

function State:mousepressed(x, y, button, istouch, presses)
  Lume.each(self.systems, 'earlysystemmousepressed', x, y, button, istouch, presses)
  Lume.each(self.systems, self.systemManagers.mousepressed, x, y, button, istouch, presses)
  Lume.each(self.systems, 'latesystemmousepressed', x, y, button, istouch, presses)
end

function State:mousereleased(x, y, button, istouch, presses)
  Lume.each(self.systems, 'earlysystemmousereleased', x, y, button, istouch, presses)
  Lume.each(self.systems, self.systemManagers.mousereleased, x, y, button, istouch, presses)
  Lume.each(self.systems, 'latesystemmousereleased', x, y, button, istouch, presses)
end

function State:mousemoved(x, y, dx, dy, istouch)
  Lume.each(self.systems, 'earlysystemmousemoved', x, y, button, istouch, presses)
  Lume.each(self.systems, self.systemManagers.mousemoved, x, y, dx, dy, istouch)
  Lume.each(self.systems, 'latesystemmousemoved', x, y, button, istouch, presses)
end

return State