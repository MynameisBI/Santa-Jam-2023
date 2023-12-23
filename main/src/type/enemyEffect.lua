local EnemyEffect = Class('EnemyEffect')

function EnemyEffect:initialize(effectType, duration, ...)
  if effectType == 'slow' then
    self.effectType, self.duration, self.strength = effectType, duration or 1, ...
    self.strength = Lume.clamp(strength, 0, 1)

  elseif effectType == 'stun' then
    self.effectType, self.duration = effectType, duration or 1

  elseif effectType == 'reducePhysicalArmor' then
    self.effectType, self.duration = effectType, duration or 1

  elseif effectType == 'reduceRealityArmor' then
    self.effectType, self.duration = effectType, duration or 1

  else
    assert(false, 'Invalid enemy effect')
  end
end

return EnemyEffect