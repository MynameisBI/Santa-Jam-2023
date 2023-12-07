require 'globals'

TestState = require 'src.states.testState'

function love.load()
  Hump.Gamestate.registerEvents()
  Hump.Gamestate.switch(TestState)
end

function love.update(dt)

end

function love.draw()

end

