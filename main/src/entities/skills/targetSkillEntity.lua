local Transform = require 'src.components.transform'
local TargetSkill = require 'src.components.skills.targetSkill'

local Entity = require 'src.entities.entity'

local TargetSkillEntity = Class('TargetSkillEntity', Entity)

function TargetSkillEntity:initialize(hero, enemyEntity, damageInfo, secondsUntilDetonate, continuousInfo)
  Entity.initialize(self)

  local transform = self:addComponent(Transform(0, 0, 0, 2, 2))

  self:addComponent(TargetSkill(hero, enemyEntity, damageInfo, secondsUntilDetonate, continuousInfo))
end

function TargetSkillEntity:onAdded()
  self:getComponent('Transform'):setGlobalPosition(
      self:getComponent('TargetSkill').enemyEntity:getComponent('Transform'):getGlobalPosition())
end

return TargetSkillEntity