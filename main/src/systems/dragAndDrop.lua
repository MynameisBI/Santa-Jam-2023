local System = require 'src.systems.system'

local DragAndDrop = Class('DragAndDrop', System)

function DragAndDrop:initialize()
  System.initialize(self, 'Draggable', 'Transform', 'Area', '-Hero')
  self.draggable = nil
  self.oldSlot = nil
end

function DragAndDrop:entityadded(draggable, transform, area, entity)
  draggable:setEntityPosToSlot(draggable.slot)
end

function DragAndDrop:update(draggable, transform, area, dt)
  if self.draggable == nil then return end

  if self.draggable ~= draggable then return end
  
  local x, y = love.mouse.getPosition()
  transform:setGlobalPosition(x - 18, y - 36)
end

function DragAndDrop:mousepressed(draggable, transform, area, x, y, button)
  if area:hasWorldPoint(x, y) then
    self.draggable = draggable

    self.oldSlot = draggable.slot
    draggable:unsetSlot()
  end
end

function DragAndDrop:mousereleased(draggable, transform, area, x, y, button)
  if self.draggable then
    -- Find all empty slot
    local slots = Hump.Gamestate.current():getEntitiesWithComponent('DropSlot')
    for i = #slots, 1, -1 do
      if slots[i].draggable ~= nil then 
        table.remove(slots, i)
      end
    end

    -- Find nearest slot and snap to it
    local nearestSlot = Lume.nearest(x, y, slots,
        function(slot)
          local x, y = slot:getComponent('Transform'):getGlobalPosition()
          local w, h = slot:getComponent('Area'):getSize()
          return x + w/2, y + h/2
        end)
    self.draggable:setSlot(nearestSlot)

    if self.oldSlot:getComponent('DropSlot').slotType ~= nearestSlot:getComponent('DropSlot').slotType then
      local teamUpdateObservers = Hump.Gamestate.current():getComponents('TeamUpdateObserver')
      Lume.each(teamUpdateObservers, 'notify')
    end
  end

  self.oldSlot = nil
  self.draggable = nil
end

-- debugging
function DragAndDrop:worlddraw(draggable, transform, area)
  -- if self.draggable == nil then return end
  for _, dropSlot in ipairs(Hump.Gamestate.current():getEntitiesWithComponent('DropSlot')) do
    love.graphics.setColor(0.8, 0.8, 0.8, 0.5)
    local x, y = dropSlot:getComponent('Transform'):getGlobalPosition()
    local w, h = dropSlot:getComponent('Area'):getSize()
    love.graphics.rectangle('line', x, y, w, h)
  end
end

return DragAndDrop