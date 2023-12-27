local Phase = require 'src.components.phase'
local AudioManager = require 'src.components.audioManager'

local Menu = Class('Menu')

function Menu:enter()
    self.suit = Suit.new()
end

function Menu:initialize()
    self.stars = {}
    for i = 1, 100 do
        table.insert(self.stars, Star())
    end
end

function Menu:draw()
    -- Background
    love.graphics.setColor(1, 1, 1)
    love.graphics.setBackgroundColor(Hex2Color('#324376'))
    -- love.graphics.setBackgroundColor(Hex2Color('#2B2D42'))
    love.graphics.draw(Images.environment.background, 0, 0, 0, 1, 1)

    -- Title
    love.graphics.setColor(1, 1, 1, 0.9)
    local text = 'Let\'s Roll!'
    love.graphics.printf(text, Fonts.huge, 0, 100, love.graphics.getWidth(), 'center')

    -- Buttons
    self.buttonX = love.graphics.getWidth() / 2 - 90
    self.buttonY = love.graphics.getHeight() / 2 - 20

    love.graphics.setColor(1, 1, 1, 0.9)
    love.graphics.setFont(Fonts.big)
    self.startButton = self.suit:Button('Start', self.buttonX, self.buttonY, 180, 40)
    if self.startButton.hit then
        Hump.Gamestate.switch(Game)
        AudioManager:playSound('button', 0.2)
    end

    self.settingButton = self.suit:Button('Settings', self.buttonX, self.buttonY + 50, 180, 40)
    if self.settingButton.hit then
        Gamestate.push(Setting)
        AudioManager:playSound('button', 0.2)
    end

    self.suit:draw()
end

return Menu
