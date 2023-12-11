local State = require 'src.states.state'
local Entity = require 'src.entities.entity'
local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'

local ResourcesHUD = require 'src.gui.game.resourcesHUD'

local Game = Class('Game', State)

function Game:enter(from)
  State.enter(self, from)

  self.guis = {
    ResourcesHUD()
  }
end

function Game:update(dt)
  State.update(self, dt)

  Lume.each(self.guis, 'update', dt)
end

function Game:draw()
  -- Background
  love.graphics.setColor(1, 1, 1)

  love.graphics.draw(Images.environment.sky, 0, 0, 0, 2, 2)

  local buildingsImage = Images.environment.buildings
  DEBUG.buildingsX = DEBUG.buildingsX - DEBUG.buildingsSpeed * love.timer.getDelta()
  if DEBUG.buildingsX + buildingsImage:getWidth() * 2 < 0 then
    DEBUG.buildingsX = DEBUG.buildingsX + buildingsImage:getWidth() * 2
  end
  for i = 0, 1 do
    love.graphics.draw(buildingsImage, DEBUG.buildingsX + buildingsImage:getWidth() * 2 * i, 0, 0, 2, 2)
  end

  love.graphics.draw(Images.environment.platform, 0, 0, 0, 2, 2)


  State.draw(self)

  Lume.each(self.guis, 'draw')
end

return Game