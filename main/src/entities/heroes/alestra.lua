local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'
local Animator = require 'src.components.animator'
local Hero = require 'src.components.hero'
local Draggable = require 'src.components.draggable'
local Area = require 'src.components.area'
local Inspectable = require 'src.components.inspectable'

local Entity = require 'src.entities.entity'

local Alestra = Class('Alestra', Entity)

function Alestra:initialize(slot)
    Entity.initialize(self)

    self:addComponent(Transform(0, 0, 0, 2, 2))

    self:addComponent(Sprite(Images.heroes.alestra, 10))

    local animator = Animator()
    animator:setGrid(18, 18, Images.heroes.alestra:getWidth(), Images.heroes.alestra:getHeight())
    animator:addAnimation('idle', {'1-2', 1}, 0.5, true)
    animator:addAnimation('attack', {'3-6', 1}, {0.5, 0.5, 0.5, 0.5}, true)
    animator:setCurrentAnimationName('idle')
    self:addComponent(animator)

    local hero = Hero('Alestra', {'sentient', 'coordinator'},
        {
            [1] = Hero.Stats(40, 30, 1.0, 300, 0, 0),
            [2] = Hero.Stats(60, 45, 1.0, 300, 0, 0),
            [3] = Hero.Stats(90, 68, 1.0, 300, 0, 0),
            [4] = Hero.Stats(135, 101, 1.0, 300, 0, 0)
        },
        Hero.Skill('Alestra',
        40, 8,
        function()
            print('machine guns!!!')
        end
        )
    )
    self:addComponent(hero)

    self:addComponent(Area(36, 36))

    self:addComponent(Draggable(slot))

    self:addComponent(Inspectable(nil, 2, 0, 'hero', hero))
end

return Alestra