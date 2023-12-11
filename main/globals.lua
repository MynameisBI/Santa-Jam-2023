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

  environment = Clove.importAll('assets/environment', true)
} 

