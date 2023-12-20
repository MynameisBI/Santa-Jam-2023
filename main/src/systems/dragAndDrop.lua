local DragAndDropInfo = require 'src.components.dragAndDropInfo'
local Phase = require 'src.components.phase'
local System = require 'src.systems.system'

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
  if button ~= 1 or (Phase():current() ~= 'planning' and draggable.draggableType ~= 'mod') then return end
  
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

return DragAndDrop