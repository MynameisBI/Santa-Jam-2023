local Entity = require 'src.entities.entity'
local Input = require 'src.components.input'
local System = require 'src.systems.system'
local Enemy = require 'src.components.enemy'
local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'

local ManageEnemy = System:subclass('ManageEnemy')

function ManageEnemy:initialize()
    System.initialize(self, 'Transform', 'Sprite')
    self.input = Input()
    self.timer = Hump.Timer()
    self.enemies = {}

    self.spawnCD = false
    print('enemy spawner initialized')
end

function ManageEnemy:update(transform, sprite, dt)
    self.timer:update(dt)

    if self.input:isScancodePressed('q') and not self.spawnCD then
        self:spawn()
        print('spawn')

        self.spawnCD = true
        self.timer:after(2, function()
            self.spawnCD = false
        end)
        
    end

    self:moveEnemy(dt)
end

function ManageEnemy:moveEnemy(dt)
    for i = #self.enemies, 1, -1 do
        local enemy = self.enemies[i]
        local transform = enemy:getComponent('Transform')
        local sprite = enemy:getComponent('Sprite')
        local enemyinfo = enemy:getComponent('Enemy')


        transform:setGlobalPosition(transform.x - enemyinfo.speed*dt, transform.y)
    end

end

function ManageEnemy:spawn()
    local enemyStats = {
        physicalArmor = 30,
        psychicArmor = 40,
        HP = 100,
        maxHP = 100
    }

    local enemy = Entity(
        Transform(430, 230, 0, 0.5, 0.5),
        Sprite(Images.environment.sky, 10),
        Enemy('a', 10, enemyStats)
    )
    self.enemies[#self.enemies + 1] = enemy

    Hump.Gamestate.current():addEntity(enemy)
end

return ManageEnemy