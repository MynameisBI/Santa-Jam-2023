local Transform = require 'src.components.transform'
local Sprite = require 'src.components.sprite'
local AreaSkill = require 'src.components.skills.areaSkill'

local Entity = require 'src.entities.entity'

local AreaSkillEntity = Class('AreaSkillEntity', Entity)

function AreaSkillEntity:initialize(image, hero, x, y, range, damageInfo, secondsUntilDetonate)
  Entity.initialize(self)

  self:addComponent(Transform(x, y, 0, 2, 2))

  self:addComponent(Sprite(image, 16))

  self:addComponent(AreaSkill(hero, x, y, range, damageInfo, secondsUntilDetonate))
end

return AreaSkillEntity