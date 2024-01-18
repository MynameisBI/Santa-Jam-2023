require 'globals'
require 'assets'

Game = require 'src.states.game'
Menu = require 'src.states.menu'

local AudioManager = require 'src.components.audioManager'

function love.load(args)
  math.randomseed(os.time())

  Hump.Gamestate.registerEvents()
  Hump.Gamestate.switch(Menu)

  AudioManager:initialize()
  AudioManager:loadSound('song1', 'assets/sfx/song1.mp3', 'stream')
  AudioManager:loadSound('song2', 'assets/sfx/song2.mp3', 'stream')

  AudioManager:loadSound('button', 'assets/sfx/button.wav', 'static')
  AudioManager:loadSound('hit-hurt', 'assets/sfx/hit-hurt.wav', 'static')
  AudioManager:loadSound('pickup', 'assets/sfx/pick-up.wav', 'static')
  AudioManager:loadSound('level-up', 'assets/sfx/level-up.wav', 'static')
  AudioManager:loadSound('shoot', 'assets/sfx/shoot.wav', 'static')
  AudioManager:loadSound('fall-down', 'assets/sfx/fall-down.wav', 'static')
  AudioManager:loadSound('transform', 'assets/sfx/transform.wav', 'static')

  AudioManager:playSong('song2', 0.5)
end

function love.update(dt)
  AudioManager:update(dt)
end

function love.draw()
  
end

