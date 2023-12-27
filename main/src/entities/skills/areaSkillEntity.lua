local Transform = require 'src.components.transform'
local AreaSkill = require 'src.components.skills.areaSkill'

local Entity = require 'src.entities.entity'

local AreaSkillEntity = Class('AreaSkillEntity', Entity)

function AreaSkillEntity:initialize(hero, targetInfo, ...)
  Entity.initialize(self)

  self:addComponent(Transform(targetInfo.x, targetInfo.y, 0, 2, 2))

  self:addComponent(AreaSkill(hero, targetInfo, ...))
end

return AreaSkillEntity