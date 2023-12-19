local Entity = require 'src.entities.entity'
local System = require 'src.systems.system'
local Enemy = require 'src.components.enemy'
local Transform = require 'src.components.transform'

-- Enemies
-- mini enemies
local Mino = require 'src.entities.enemies.mino'
local Peach = require 'src.entities.enemies.peach'
local Amber = require 'src.entities.enemies.amber'
-- heavy enemies
local Rini = require 'src.entities.enemies.rini'
local Spinel = require 'src.entities.enemies.spinel'
local Elio =  require 'src.entities.enemies.elio'
-- gigantic enemies
local Arno = require 'src.entities.enemies.arno'
local Quad = require 'src.entities.enemies.quad'
local Granite = require 'src.entities.enemies.granite'
-- fast enemies
local Pepero = require 'src.entities.enemies.pepero'
local Sev = require 'src.entities.enemies.sev'
local Leo = require 'src.entities.enemies.leo'

local ManageEnemy = System:subclass('ManageEnemy')

function ManageEnemy:initialize()
    System.initialize(self, 'Transform', 'Enemy')
    self.timer = Hump.Timer()
    self.enemies = {}

    self.spawnCD = false
    print('enemy spawner initialized')
end

function ManageEnemy:update(transform, enemy, dt)
    self.timer:update(dt)

    if self.spawnCD then
        self:spawn()
        print('spawn')

        self.spawnCD = true
        self.timer:after(2, function()
            self.spawnCD = false
        end)
    end

    transform:setGlobalPosition(transform.x-100*dt, transform.y)
end


return ManageEnemy