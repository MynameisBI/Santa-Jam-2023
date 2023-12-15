DEBUG = {
  status = true,
  buildingsX = 0,
  buildingsSpeed = 25
}

Hump = {
  Gamestate = require 'libs.hump.gamestate',
  Timer = require 'libs.hump.timer'
}
Knife = {
  System = require 'libs.knife.system'
}
Anim8 = require 'libs.anim8'
Class = require 'libs.middleclass'
Lume = require 'libs.lume'
Gamera = require 'libs.gamera'
Bump = require 'libs.bump'
Suit = require 'libs.suit'
Clove = require 'libs.clove'

love.graphics.setDefaultFilter('nearest', 'nearest')
Images = {
  diamond = love.graphics.newImage('assets/diamond.png'),

  environment = Clove.importAll('assets/environment', true),

  heroes = Clove.importAll('assets/heroes', true),

  icons = Clove.importAll('assets/icons', true)
}

Fonts = {
  small = love.graphics.newFont('assets/04B_03__.TTF', 8),
  medium = love.graphics.newFont('assets/04B_03__.TTF', 16),
  big = love.graphics.newFont('assets/04B_03__.TTF', 24),
  large = love.graphics.newFont('assets/04B_03__.TTF', 32),
  huge = love.graphics.newFont('assets/04B_03__.TTF', 40),
}

function Lume.nearest(ox, oy, points, getPointPosFn)
  local minDist = math.huge
  local nearestPoint = nil
  for _, point in ipairs(points) do
    local px, py = getPointPosFn(point)
    local dist = Lume.distance(ox, oy, px, py)
    if dist < minDist then
      minDist = dist
      nearestPoint = point
    end
  end
  return nearestPoint
end