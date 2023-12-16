local DragAndDropInfo = require 'src.components.dragAndDropInfo'
local System = require 'src.systems.system'

local DrawSlot = Class('DrawSlot', System)

function DrawSlot:initialize()
  System.initialize(self, 'Transform', 'Area', 'DropSlot')
  self.dragAndDropInfo = DragAndDropInfo()
end

function DrawSlot:worlddraw(transform, area, dropSlot)
  if dropSlot.draggable then
    Deep.queue(20, function()
      local x, y = transform:getGlobalPosition()
      local w, h = area:getSize()

      love.graphics.setColor(0.8, 0.8, 0.8)
      love.graphics.setFont(Fonts.medium)
      love.graphics.print('lv.1', x, y - 17, 0, 0.75, 0.75)

      local hero = dropSlot.draggable:getEntity():getComponent('Hero')
      local threshold = hero.class.EXPERIENCE_THRESHOLD[hero.level]
      for i = 1, threshold do
        local bx, by = x + w / threshold * (i-1), y - 5
        if i <= hero.exp then love.graphics.setColor(0.8, 0.8, 0.8)
        else love.graphics.setColor(0.15, 0.15, 0.15)
        end
        love.graphics.rectangle('fill', bx, by, w / threshold - 1, 5, 2, 2)
      end
    end)
  end
  

  if self.dragAndDropInfo.draggable then
    Deep.queue(2, function()
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

return DrawSlot