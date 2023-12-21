local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'
local TargetSkill = require 'src.components.skills.targetSkill'

local Entity = require 'src.entities.entity'

local TargetSkillEntity = Class('TargetSkillEntity', Entity)

function TargetSkillEntity:initialize(image, hero, enemyEntity, damageInfo, secondsUntilDetonate, continuousInfo)
  Entity.initialize(self)

  self:addComponent(Transform(0, 0, 0, 2, 2))

  self:addComponent(Sprite(image, 16))

  self:addComponent(TargetSkill(hero, enemyEntity, damageInfo, secondsUntilDetonate, continuousInfo))
end

return TargetSkillEntity