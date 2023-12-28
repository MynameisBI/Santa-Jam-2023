
local AudioManager = require 'src.components.audioManager'

local Setting = Class('Setting')

local chk1 = {text = "Muted Music"}
local chk2 = {text = "Muted Sound"}

function Setting:enter()
    self.suit = Suit.new()
    self.songVolume = AudioManager.currentSong:getVolume() or 0.5
end


function Setting:draw()
    -- Background
    love.graphics.draw(Images.environment.background, 0, 0, 0, 1, 1)
    love.graphics.setBackgroundColor(Hex2Color('#324376'))
    local buildingsImage = Images.environment.buildings
    DEBUG.buildingsX = DEBUG.buildingsX - DEBUG.buildingsSpeed * love.timer.getDelta()
    if DEBUG.buildingsX + buildingsImage:getWidth() * 2 < 0 then
        DEBUG.buildingsX = DEBUG.buildingsX + buildingsImage:getWidth() * 2
    end
    for i = 0, 1 do
        love.graphics.draw(buildingsImage, DEBUG.buildingsX + buildingsImage:getWidth() * 2 * i, 0, 0, 2, 2)
    end
    -- Back button
    self.buttonX = 10
    self.buttonY = 15

    love.graphics.setColor(1, 1, 1, 0.9)
    love.graphics.setFont(Fonts.big)
    self.backButton = self.suit:Button('Back', self.buttonX, self.buttonY, 180, 40)
    if self.backButton.hit then
        Hump.Gamestate.pop()
        AudioManager:playSound('button', 0.4)
    end

    print(self.songVolume)

    self.suit:draw()
end

function Setting:update(dt)
    self.suit:updateMouse(love.mouse.getX(), love.mouse.getY())
end


return Setting