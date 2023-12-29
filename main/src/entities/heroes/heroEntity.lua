local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'
local Animator = require 'src.components.animator'
local Hero = require 'src.components.hero'
local Draggable = require 'src.components.draggable'
local Area = require 'src.components.area'
local Inspectable = require 'src.components.inspectable'
local TeamUpdateObserver = require 'src.components.teamUpdateObserver'
local Entity = require 'src.entities.entity'

local HeroEntity = Class('HeroEntity', Entity)

function HeroEntity:initialize(slot, image, name, tier, traits, baseStats, bulletClass, skill, inspectableX, inspectableY)
    Entity.initialize(self)

    self:addComponent(Transform(0, 0, 0, 2, 2))

    self:addComponent(Sprite(image, 10))

    self:addComponent(Animator())

    self:addComponent(Area(36, 36))

    local hero = self:addComponent(Hero(name, tier, traits, baseStats, bulletClass, skill))

    self:addComponent(Inspectable(nil, inspectableX or 3, inspectableY or 1, 'hero', hero))

    self:addComponent(Draggable(slot, 'hero'))

    self:addComponent(TeamUpdateObserver())
end

return HeroEntity