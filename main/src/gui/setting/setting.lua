
local AudioManager = require 'src.components.audioManager'

local Setting = Class('Setting')

local chk1 = {text = "Muted Music"}
local chk2 = {text = "Muted Sound"}

function Setting:enter()
    self.suit = Suit.new()
    self.songVolume = AudioManager.currentSong:getVolume() or 0.5
    self.soundVolume = 0.5
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
        AudioManager:playSound('button', 0.5)
    end


    -- Volume
    -- Music button
    self.buttonX = 280
    self.buttonY = 170

    love.graphics.setColor(1, 1, 1, 0.9)

    self.minusButton = self.suit:Button('-', self.buttonX + 110, self.buttonY, 40, 40)
    if self.minusButton.hit then
        AudioManager:playSound('button', 0.5)
        self.songVolume = math.max(self.songVolume - 0.1, 0.1)
        AudioManager.currentSong:setVolume(self.songVolume)
    end

    self.plusButton = self.suit:Button('+', self.buttonX + 310, self.buttonY, 40, 40)
    if self.plusButton.hit then
        AudioManager:playSound('button', 0.5)
        self.songVolume = math.min(self.songVolume + 0.1, 0.9)
        AudioManager.currentSong:setVolume(self.songVolume)
    end



    love.graphics.printf("Music Vol.", Fonts.big, 200, 180, love.graphics.getWidth() - 200, 'left')
    love.graphics.print('     '..string.format('%.1f',self.songVolume), Fonts.big, 430, 180)
    

    self.muteButton = self.suit:Button('Mute', self.buttonX, self.buttonY + 50, 150, 40)
    if self.muteButton.hit then
        AudioManager:playSound('button', 0.5)
        self.songVolume = 0
        AudioManager.currentSong:setVolume(self.songVolume)
    end

    love.graphics.printf("Music", Fonts.big, 200, 230, love.graphics.getWidth() - 200, 'left')

    self.unmuteButton = self.suit:Button('Unmute', self.buttonX + 200, self.buttonY + 50, 150, 40)
    if self.unmuteButton.hit then
        AudioManager:playSound('button', 0.5)
        self.songVolume = 0.5
        AudioManager.currentSong:setVolume(self.songVolume)
    end
            
    self.suit:draw()
end

function Setting:update(dt)
    self.suit:updateMouse(love.mouse.getX(), love.mouse.getY())
end


return Setting