local Entity = require 'src.entities.entity'
local Input = require 'src.components.input'
local System = require 'src.systems.system'

local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'
local Bullet = require 'src.components.bullet'

local ManageHero = System:subclass('ManageHero')

function ManageHero:initialize()
    self.heroes = {}
    System.initialize(self, 'Transform', 'Sprite', 'Area')
    self.input = Input()
    self.timer = Hump.Timer()
    self.bullets = {}
end

function ManageHero:update(transform, sprite, area, dt)
    
    self.target = {x = 800, y = 800}

    self.timer:update(dt)
    -- self:setTarget()

    -- normal attack
    if self.input:isScancodePressed('space') and not self.atkCD then
        self:attack()
        print('shoot')

        self.atkCD = true
        self.timer:after(2, function()
            self.atkCD = false
        end)
    end

    for i = #self.bullets, 1, -1 do
        local bullet = self.bullets[i]
        local transform = bullet:getComponent('Transform')
        transform:setGlobalPosition(transform.x + 1, transform.y + 1)
    end
end

function ManageHero:setup()
    self.atkCD = false
    self.skillCD = false
    self.isDead = false
end

function ManageHero:attack()
    -- add bullet
    local bullet = Entity(
        Transform(self.x, self.y, 0, 0.5, 0.5),
        Sprite(Images.diamond, 2),
        Bullet(self, self.target, 200)
    )
    self.bullets[#self.bullets + 1] = bullet
    

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


return ManageHero


