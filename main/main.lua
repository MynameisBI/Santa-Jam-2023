require 'globals'
require 'assets'

Game = require 'src.states.game'

function love.load(args)
  math.randomseed(os.time())

  Hump.Gamestate.registerEvents()
  Hump.Gamestate.switch(Game)
end

function love.update(dt)
  
end

function love.draw()
  
end

