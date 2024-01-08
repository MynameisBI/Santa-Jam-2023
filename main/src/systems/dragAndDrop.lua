local DragAndDropInfo = require 'src.components.dragAndDropInfo'
local Phase = require 'src.components.phase'
local System = require 'src.systems.system'
local AudioManager = require 'src.components.audioManager'
local Resources = require 'src.components.resources'

local DragAndDrop = Class('DragAndDrop', System)

function DragAndDrop:initialize()
  System.initialize(self, 'Draggable', 'Transform', 'Area', '?Hero', '?Mod')
  self.dragAndDropInfo = DragAndDropInfo()
end

function DragAndDrop:update(draggable, transform, area, hero, mod, dt)
  if self.dragAndDropInfo.draggable == nil then return end

  if self.dragAndDropInfo.draggable ~= draggable then return end
  
  local x, y = love.mouse.getPosition()
  local w, h = area:getSize()
  x = x - w / 2
  if hero then y = y - 46
  elseif mod then y = y - 26
  end
  transform:setGlobalPosition(x, y)
end

function DragAndDrop:mousepressed(draggable, transform, area, hero, mod, x, y, button)
  if button ~= 1 or (Phase():current() == 'battle' and draggable.draggableType ~= 'mod') then return end
  
  if area:hasWorldPoint(x, y) then
    
    self.dragAndDropInfo.draggable = draggable

    self.dragAndDropInfo.oldSlot = draggable.slot
    draggable:unsetSlot()
  end
end

function DragAndDrop:earlysystemmousereleased(x, y, button)
  local currentDraggable = self.dragAndDropInfo.draggable

  if currentDraggable == nil then return end

  if button ~= 1 or (Phase():current() ~= 'planning' and currentDraggable.draggableType ~= 'mod') then return end

  if currentDraggable.draggableType == 'hero' then
    local slots = Hump.Gamestate.current():getEntitiesWithComponent('DropSlot')
    local droppedSlot = nil
    for _, slot in ipairs(slots) do
      if (slot:getComponent('DropSlot').slotType == 'team' or slot:getComponent('DropSlot').slotType == 'bench') and
          slot:getComponent('Area'):hasWorldPoint(x, y) then
        droppedSlot = slot
        AudioManager:playSound('pickup', 0.2)
        break
      end
    end
    if droppedSlot then
      if droppedSlot:getComponent('DropSlot').draggable == nil then
        self.dragAndDropInfo.draggable:setSlot(droppedSlot)
      else
        local droppedSlotDraggable = droppedSlot:getComponent('DropSlot').draggable
        self.dragAndDropInfo.draggable:setSlot(droppedSlot)
        droppedSlotDraggable:setSlot(self.dragAndDropInfo.oldSlot)
      end

      if self.dragAndDropInfo.oldSlot:getComponent('DropSlot').slotType ~= droppedSlot:getComponent('DropSlot').slotType then
        local teamUpdateObservers = Hump.Gamestate.current():getComponents('TeamUpdateObserver')
        Lume.each(teamUpdateObservers, 'notify')
      end

    -- Selling hero code
    elseif 50 < x and x < 810 and 465 < y then
      local hero = currentDraggable:getEntity():getComponent('Hero')
      if hero.modEntity then
        local emptyModSlots = Lume.filter(Hump.Gamestate.current():getComponents('DropSlot'),
            function(dropSlot) return dropSlot.slotType == 'mod' and dropSlot.draggable == nil end)

        if #emptyModSlots == 0 then
          print('Uh oh no we\'re out of mod slots (It\'s definitely a planned feature and not a bug)')
        else
          hero.modEntity:getComponent('Draggable'):setSlot(emptyModSlots[1]:getEntity())
          Hump.Gamestate.current():addEntity(hero.modEntity)
        end
      end
      Resources():modifyMoney(hero:getSellPrice())
      Hump.Gamestate.current():removeEntity(currentDraggable:getEntity())

    else
      self.dragAndDropInfo.draggable:setSlot(self.dragAndDropInfo.oldSlot)
    end

  elseif currentDraggable.draggableType == 'mod' then
    local slots = Hump.Gamestate.current():getEntitiesWithComponent('DropSlot')
    local modSlots = Lume.filter(slots, function(slot) return slot:getComponent('DropSlot').slotType == 'mod' end)
    local heroes = Hump.Gamestate.current():getEntitiesWithComponent('Hero')
    local droppableEntities = Lume.concat(modSlots, heroes)
    local droppedEntity = nil
    for _, entity in ipairs(droppableEntities) do
      if entity:getComponent('Area'):hasWorldPoint(x, y) then
        droppedEntity = entity
        AudioManager:playSound('pickup', 0.2)
      end
    end
    if droppedEntity then
      local dropSlot = droppedEntity:getComponent('DropSlot')
      local hero = droppedEntity:getComponent('Hero')
      if dropSlot then
        if dropSlot.draggable == nil then
          self.dragAndDropInfo.draggable:setSlot(droppedEntity)
        else
          local droppedSlotDraggable = dropSlot.draggable
          self.dragAndDropInfo.draggable:setSlot(dropSlot:getEntity())
          droppedSlotDraggable:setSlot(self.dragAndDropInfo.oldSlot)
        end

      elseif hero then
        local modEntity = currentDraggable:getEntity()
        if hero:addMod(modEntity) then
          Hump.Gamestate.current():removeEntity(modEntity)
        else
          self.dragAndDropInfo.draggable:setSlot(self.dragAndDropInfo.oldSlot)
        end
      end

    else
      self.dragAndDropInfo.draggable:setSlot(self.dragAndDropInfo.oldSlot)
    end
  end

  self.dragAndDropInfo.oldSlot = nil
  self.dragAndDropInfo.draggable = nil
end

function DragAndDrop:earlysystemworlddraw()
  local currentDraggable = self.dragAndDropInfo.draggable

  if currentDraggable == nil then return end
  if currentDraggable.draggableType ~= 'hero' then return end

  local heroEntity = currentDraggable:getEntity()
  local x, y = heroEntity:getComponent('Transform'):getGlobalPosition()
  local hero = heroEntity:getComponent('Hero')
  local stats = hero:getStats()

  Deep.queue(8, function()
    local sw, sh = love.graphics.getDimensions()

    love.graphics.stencil(self.getCombatAreaStencil, 'replace', 1)
    love.graphics.setStencilTest('greater', 0)
      love.graphics.setColor(0.32, 0.75, 0.79, 0.1)
      love.graphics.rectangle('fill', x, y - sh, stats.range + 2, sh * 2)

      love.graphics.setColor(0.32, 0.75, 0.79, 0.075)
      love.graphics.setLineWidth(4)
      love.graphics.line(x + stats.range, y - sh, x + stats.range, y + sh * 2)
      love.graphics.setLineWidth(1)
    love.graphics.setStencilTest()
  end)
end

function DragAndDrop.getCombatAreaStencil()
  love.graphics.rectangle('fill', 320, 200, 540 ,180)
end

return DragAndDrop