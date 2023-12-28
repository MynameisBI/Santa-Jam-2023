local Phase = require 'src.components.phase'
local AudioManager = require 'src.components.audioManager'
local Setting = require 'src.gui.setting.setting'

local Menu = Class('Menu')

function Menu:enter()
    self.suit = Suit.new()
end

function Menu:draw()
    -- Background
    love.graphics.setColor(1, 1, 1)
    love.graphics.setBackgroundColor(Hex2Color('#324376'))
    -- love.graphics.setBackgroundColor(Hex2Color('#2B2D42'))
    love.graphics.draw(Images.environment.background, 0, 0, 0, 1, 1)
    local buildingsImage = Images.environment.buildings
    DEBUG.buildingsX = DEBUG.buildingsX - DEBUG.buildingsSpeed * love.timer.getDelta()
    if DEBUG.buildingsX + buildingsImage:getWidth() * 2 < 0 then
        DEBUG.buildingsX = DEBUG.buildingsX + buildingsImage:getWidth() * 2
    end
    for i = 0, 1 do
        love.graphics.draw(buildingsImage, DEBUG.buildingsX + buildingsImage:getWidth() * 2 * i, 0, 0, 2, 2)
    end

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
        AudioManager:playSound('button', 0.4)
    end

    self.settingButton = self.suit:Button('Setting', self.buttonX, self.buttonY + 50, 180, 40)
    if self.settingButton.hit then
        -- switch to setting
        Hump.Gamestate.push(Setting)
        AudioManager:playSound('button', 0.4)
    end

    self.suit:draw()
end

return Menu
