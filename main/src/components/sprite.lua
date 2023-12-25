local Component = require 'src.components.component'

local Sprite = Component:subclass('Sprite')

function Sprite:initialize(image, layer, effectType, effectStrength, after)
  Component.initialize(self)
  self.image = image
  
  self.layer = layer or 0
  
  self._red = 1
  self._green = 1
  self._blue = 1
  self._alpha = 1

  self.ox = 0
  self.oy = 0

  self.effectType = effectType
  self.effectStrength = effectStrength or 10
  self.afterEffectFn = afterEffectFn or function(self) end
end

function Sprite:setColor(mode, r, g, b, a)
  if mode == 'default' or mode == nil then
    self._red = r or 1
    self._green = g or 1
    self._blue = b or 1
    self._alpha = a or 1

  elseif mode == '255' then
    self._red = r/255 or 1
    self._green = g/255 or 1
    self._blue = b/255 or 1
    self._alpha = a/255 or 1

  elseif mode == 'hex' then
    local hex = r:gsub("#","")
    self:setColor('255', tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)),
        tonumber("0x"..hex:sub(5,6)), tonumber("0x"..hex:sub(7,8)))
  end
end

return Sprite
