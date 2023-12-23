local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'
local Animator = require 'src.components.animator'
local AreaSkill = require 'src.components.skills.areaSkill'

local Entity = require 'src.entities.entity'

local AreaSkillEntity = Class('AreaSkillEntity', Entity)

function AreaSkillEntity:initialize(image, hero, targetInfo, w, h, damageInfo, secondsUntilDetonate, continuousInfo)
  Entity.initialize(self)

  self:addComponent(Transform(targetInfo.x, targetInfo.y, 0, 2, 2))

  self:addComponent(AreaSkill(hero, targetInfo, w, h, damageInfo, secondsUntilDetonate, continuousInfo))


  local effectEntity = Entity()
  effectEntity:addComponent(Transform(targetInfo.x - w/2, targetInfo.y - 96, 0, 2, 2))
  effectEntity:addComponent(Sprite(image, 16))
  local animator = effectEntity:addComponent(Animator())
  animator:setGrid(100, 60, image:getDimensions())
  animator:addAnimation('default', {'1-10', 1}, 0.05, false,
      function() Hump.Gamestate.current():removeEntity(effectEntity) end)
  animator:setCurrentAnimationName('default')
  Hump.Gamestate.current():addEntity(effectEntity)
end

return AreaSkillEntity