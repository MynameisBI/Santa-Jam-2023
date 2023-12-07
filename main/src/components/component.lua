local Component = Class('Component')

function Component:initialize()
  self.enabled = true
  self._entity = nil

  -- Other components within the same entity can't be accessed here
end

function Component:entityadded()
  -- If you want to access other components in the entity
  -- Access it here
end

function Component:setEnabled(isEnabled)
  self.enabled = isEnabled
end

function Component:getEnabled()
  return self.enabled
end

function Component:getEntity()
  return self._entity
end

return Component

