local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'
local Animator = require 'src.components.animator'
local Hero = require 'src.components.hero'
local Draggable = require 'src.components.draggable'
local Area = require 'src.components.area'

local Entity = require 'src.entities.entity'

local Soniya = Class('Soniya', Entity)

function Soniya:initialize(slot)
    Entity.initialize(self)

    self:addComponent(Transform(0, 0, 0, 2, 2))

    self:addComponent(Sprite(Images.heroes.soniya, 10))

    local animator = Animator()
    animator:setGrid(18, 18, Images.heroes.soniya:getWidth(), Images.heroes.soniya:getHeight())
    animator:addAnimation('idle', {'1-2', 1}, 0.5, true)
    animator:addAnimation('attack', {'3-5', 1}, {0.075, 0.075, 0.075}, true)
    animator:setCurrentAnimationName('idle')
    self:addComponent(animator)

    local hero = Hero('Soniya', {'sentient', 'droneMaestro'},
        {
            [1] = Hero.Stats(40, 30, 1.0, 300, 0, 0),
            [2] = Hero.Stats(60, 45, 1.0, 300, 0, 0),
            [3] = Hero.Stats(90, 68, 1.0, 300, 0, 0),
            [4] = Hero.Stats(135, 101, 1.0, 300, 0, 0)
        },
        Hero.Skill('Soniya MP regenator',
        40, 8,
        function()
            print('MP regen')
        end
        )
    )
    self:addComponent(hero)

    self:addComponent(Area(36, 36))

    self:addComponent(Draggable(slot))
end

return Soniya