local Entity = require 'src.entities.entity'
local Input = require 'src.components.input'
local System = require 'src.systems.system'

local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'
local BulletInfo = require 'src.components.bulletInfo'

local Hero = System:subclass('Hero')

function Hero:initialize()
    System.initialize(self, 'Transform', 'Sprite', 'Area')
    self.input = Input()
    self.timer = Hump.Timer()
end

function Hero:update(transform, sprite, area, dt)
    self.cost = cost
    -- Hero's attributes
    self.tier = {1, 2, 3, 4}
    self.level = level

    self.atkbyLevel = {10, 15, 30}
    self.atkSpeedbyLevel = {0.5, 0.6, 0.9}
    self.maxHPbyLevel = {100, 150, 250}
    self.maxMPbyLevel = {100, 150, 250}

    self.atk = self.atkbyLevel[self.level]
        
    self.HP = self.maxHP or 100
    self.range = range
    self.dmgReduced = 0.5

    self.bullets = {}
    self.target = 0

    self.timer:update(dt)
    -- self:setTarget()

    -- normal attack
    if self.input:isScancodePressed('space') and not self.atkCD then
        self:atk()
        print('shoot')

        self.atkCD = true
        self.timer:after(2, function()
            self.atkCD = false
        end)
    end
end

function Hero:setup()
    self.atkCD = false
    self.skillCD = false
    self.isDead = false
    self.timer = Timer()
end

function Hero:atk()
    -- add 
    local bullet = Entity(
        Transform(self.x, self.y, 0, 2, 2),
        Sprite(Images.diamond, 2),
        BulletInfo(10, self.target)
    )

    Hump.Gamestate.current():addEntity(bullet)
end

-- function Hero:setTarget()
--     local temp = math.sqrt(self.x - enemies[1].x)^2 + (self.y - enemies[1].y)^2
--     self.target = enemies[1]

--     for i = 1, #enemies do
--         local distance = math.sqrt(self.x - enemies[i].x)^2 + (self.y - enemies[i].y)^2
--         if distance < temp then
--             temp = distance
--             self.target = enemies[i]
--         end
--     end
-- end

function Hero:worlddraw(transform, sprite, animator)
    local wx, wy = transform:getGlobalPosition()
    local w, h = transform:getEntity():getComponent('Area'):getSize()
end

return Hero


