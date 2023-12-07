local System = require 'src.systems.system'

local DrawWorld = System:subclass('DrawWorld')

function DrawWorld:initialize()
  System.initialize(self, 'Transform', 'Sprite', '?Animator')
end

function DrawWorld:update(transform, sprite, animator, dt)
  if animator == nil then return end

  local animation = animator:getCurrentAnimation()

  if animation == nil then return end

  animation:update(dt)
end

function DrawWorld:worlddraw(transform, sprite, animator)
  local x, y = transform:getGlobalPosition()

  love.graphics.setColor(sprite._red, sprite._green, sprite._blue, sprite._alpha)

  if sprite.image == nil then
    love.graphics.circle('fill', x, y, 30 * transform.sx)

  elseif animator == nil then
    love.graphics.draw(sprite.image, x, y, transform.r, transform.sx, transform.sy)

  else
    local animation = animator:getCurrentAnimation()
    if animation == nil then
      love.graphics.circle('fill', x, y, 30 * transform.sx)
    else
      animation:draw(sprite.image, x, y, transform.r, transform.sx, transform.sy)
    end

  end
end

return DrawWorld