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
  if button ~= 1 or Phase():current() ~= 'planning' then return end
  
  if area:hasWorldPoint(x, y) then
    self.dragAndDropInfo.draggable = draggable

    self.dragAndDropInfo.oldSlot = draggable.slot
    draggable:unsetSlot()
  end
end

function DragAndDrop:mousereleased(draggable, transform, area, hero, mod, x, y, button)
  if button ~= 1 or Phase():current() ~= 'planning' then return end

  if self.dragAndDropInfo.draggable then
    local slots = Hump.Gamestate.current():getEntitiesWithComponent('DropSlot')

    local droppedSlot = nil
    for _, slot in ipairs(slots) do
      if slot:getComponent('Area'):hasWorldPoint(x, y) then
        droppedSlot = slot
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
  end

  self.dragAndDropInfo.oldSlot = nil
  self.dragAndDropInfo.draggable = nil
end

return DragAndDrop