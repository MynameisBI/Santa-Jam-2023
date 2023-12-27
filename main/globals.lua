DEBUG = {
  status = true,
  buildingsX = 0,
  buildingsSpeed = 25,
  audioEnabled = false,
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
Deep = require 'libs.deep'

function Lume.nearest(ox, oy, points, getPointPosFn)
  local minDist = math.huge
  local nearestPoint = nil
  for _, point in ipairs(points) do
    local px, py
    if getPointPosFn then px, py = getPointPosFn(point)
    else px, py = point.x, point.y
    end
    local dist = Lume.distance(ox, oy, px, py, true)
    if dist < minDist then
      minDist = dist
      nearestPoint = point
    end
  end
  return nearestPoint
end