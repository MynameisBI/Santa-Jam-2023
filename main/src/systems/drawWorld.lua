local System = require 'src.systems.system'

local DrawWorld = System:subclass('DrawWorld')

function DrawWorld:initialize()
  System.initialize(self, 'Transform', 'Sprite', '?Animator', '?Enemy', '?Hero')
end

function DrawWorld:update(transform, sprite, animator, enemy, hero, dt)
  if sprite.effectType ~= nil then
    if sprite.effectType == 'fade' then
      if sprite._alpha <= 0 then
        sprite.afterEffectFn(sprite)
      end
      sprite._alpha = sprite._alpha - dt * sprite.effectStrength
    end
  end

  if animator ~= nil then
    local animation = animator:getCurrentAnimation()
    if animation ~= nil then
      if enemy ~= nil then
        if not enemy:getAppliedEffect('stun') then
          animation:update(dt)
        end
      elseif hero ~= nil then
        -- if animator.currentAnimationName == 'attack' then
        --   animation:update(dt * hero:getStats().attackSpeed)
        -- end
        animation:update(dt)
      else
        animation:update(dt)

      end
    end
  end
end

function DrawWorld:worlddraw(transform, sprite, animator, enemy, hero)
  local x, y = transform:getGlobalPosition()

  Deep.queue(sprite.layer, function()
    love.graphics.setColor(sprite._red, sprite._green, sprite._blue, sprite._alpha)

    if sprite.image == nil then
      love.graphics.circle('fill', x, y, 30 * transform.sx)

    elseif animator == nil then
      love.graphics.draw(sprite.image, x, y, transform.r, transform.sx, transform.sy,
          transform.ox, transform.oy)

    else
      local animation = animator:getCurrentAnimation()
      if animation == nil then
        love.graphics.circle('fill', x, y, 30 * transform.sx)
      else
        animation:draw(sprite.image, x, y, transform.r, transform.sx, transform.sy,
            transform.ox, transform.oy)
      end

    end
  end)
end

return DrawWorld