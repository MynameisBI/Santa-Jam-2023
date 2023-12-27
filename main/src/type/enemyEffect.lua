local EnemyEffect = Class('EnemyEffect')

function EnemyEffect:initialize(effectType, duration, ...)
  if effectType == 'slow' then
    self.effectType, self.duration, self.strength = effectType, duration or 1, ...
    self.strength = Lume.clamp(self.strength, 0, 1)

  elseif effectType == 'stun' then
    self.effectType, self.duration = effectType, duration or 1

  elseif effectType == 'reducePhysicalArmor' then
    self.effectType, self.duration = effectType, duration or 1

  elseif effectType == 'reduceRealityArmor' then
    self.effectType, self.duration = effectType, duration or 1

  elseif effectType == 'skottMark' then
    self.effectType, self.duration = effectType, duration or 1
    self.damage, self.damageType, self.armorIgnoreRatio, self.stunDuration, self.energy = ...

  else
    assert(false, 'Invalid enemy effect')
  end
end

return EnemyEffect