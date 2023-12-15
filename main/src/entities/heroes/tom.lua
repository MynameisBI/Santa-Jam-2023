local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'
local Animator = require 'src.components.animator'
local Hero = require 'src.components.hero'
local Draggable = require 'src.components.draggable'
local Area = require 'src.components.area'

local Entity = require 'src.entities.entity'

local Tom = Class('Tom', Entity)

function Tom:initialize(slot)
    Entity.initialize(self)

    self:addComponent(Transform(0, 0, 0, 2, 2))

    self:addComponent(Sprite(Images.heroes.tom, 10))

    local animator = Animator()
    animator:setGrid(18, 18, Images.heroes.tom:getWidth(), Images.heroes.tom:getHeight())
    animator:addAnimation('idle', {'1-2', 1}, 0.8, true)
    animator:addAnimation('attack', {'3-7', 1}, {1.4, 0.075, 0.075, 0.075, 1}, true)
    animator:setCurrentAnimationName('idle')
    self:addComponent(animator)

    local hero = Hero('Tom', {'bigEar', 'droneMaestro'},
        {
            [1] = Hero.Stats(40, 30, 1.0, 300, 0, 0),
            [2] = Hero.Stats(60, 45, 1.0, 300, 0, 0),
            [3] = Hero.Stats(90, 68, 1.0, 300, 0, 0),
            [4] = Hero.Stats(135, 101, 1.0, 300, 0, 0)
        },
        Hero.Skill('Tom the DJ',
        40, 8,
        function()
            print('change phase !?')
        end
        )
    )
    self:addComponent(hero)

    self:addComponent(Area(36, 36))

    self:addComponent(Draggable(slot))
end

return Tom