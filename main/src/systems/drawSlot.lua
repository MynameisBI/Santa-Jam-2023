local DragAndDropInfo = require 'src.components.dragAndDropInfo'
local System = require 'src.systems.system'

local DrawSlot = Class('DrawSlot', System)

function DrawSlot:initialize()
  System.initialize(self, 'Transform', 'Area', 'DropSlot')
  self.dragAndDropInfo = DragAndDropInfo()
end

function DrawSlot:update(transform, area, dropSlot, dt)
  if dropSlot.slotType == 'mod' then
    dropSlot.oy = dropSlot.oy + dropSlot.speed * dt

    if math.abs(dropSlot.oy) > dropSlot.limit then
      dropSlot.speed = -dropSlot.speed
    end
  end
end

function DrawSlot:worlddraw(transform, area, dropSlot)
  if dropSlot.draggable then
    local hero = dropSlot.draggable:getEntity():getComponent('Hero')

    if hero then
      local x, y = transform:getGlobalPosition()
      local w, h = area:getSize()

      -- Draw XP bar
      Deep.queue(20, function()
        love.graphics.setColor(0.8, 0.8, 0.8)
        love.graphics.setFont(Fonts.medium)
        love.graphics.print('lv.'..tostring(hero.level), x, y - 25, 0, 0.75, 0.75)

        local threshold = hero.class.EXPERIENCE_THRESHOLD[hero.level]
        for i = 1, threshold do
          local bx, by = x + w / threshold * (i-1), y - 13
          if i <= hero.exp then love.graphics.setColor(0.8, 0.8, 0.8)
          else love.graphics.setColor(0.15, 0.15, 0.15)
          end
          love.graphics.rectangle('fill', bx, by, w / threshold - 1, 5, 2, 2)
        end
      end)

      -- Draw mod
      if hero.modEntity then
        Deep.queue(20, function()
          -- love.graphics.setColor(0.05, 0.05, 0.05, 0.4)
          -- love.graphics.rectangle('fill', x-1, y - 7, 14, 14)
          -- love.graphics.setColor(0.05, 0.05, 0.05)
          -- love.graphics.rectangle('line', x - 1, y - 6, 14, 14)
          love.graphics.setColor(1, 1, 1)
          love.graphics.draw(hero.modEntity:getComponent('Sprite').image, x, y - 8, 0, 1, 1)
        end)
      end
    end
  end

  -- Draw slots when a draggable is picked up
  if self.dragAndDropInfo.draggable then
    if (self.dragAndDropInfo.draggable.draggableType == 'hero' and (dropSlot.slotType == 'team' or dropSlot.slotType == 'bench')) or
        (self.dragAndDropInfo.draggable.draggableType == 'mod' and dropSlot.slotType == 'mod') then
      Deep.queue(6, function()
        for _, dropSlot in ipairs(Hump.Gamestate.current():getEntitiesWithComponent('DropSlot')) do
          local mx, my = love.mouse.getPosition()
          local x, y = transform:getGlobalPosition()
          local w, h = area:getSize()
    
          if area:hasWorldPoint(mx, my) then
            love.graphics.setColor(0.6, 0.75, 0.75, 0.025)
            love.graphics.rectangle('fill', x+2, y+2, w-4, h-4)
    
            love.graphics.setColor(0.6, 0.75, 0.75, 0.5)
            love.graphics.rectangle('line', x+2, y+2, w-4, h-4)
            
          else
            love.graphics.setColor(0.5, 0.65, 0.65, 0.05)
            love.graphics.rectangle('line', x+2, y+2, w-4, h-4)
          end
        end
      end)
    end
  end

  -- Draw mod holders
  if dropSlot.slotType == 'mod' then
    local x, y = transform:getGlobalPosition()
    y = y + dropSlot.oy
    Deep.queue(0, function()
      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(Images.mods.modHolder, x - 4, y + 1, 0, 2, 2)
    end)
  end
end

return DrawSlot