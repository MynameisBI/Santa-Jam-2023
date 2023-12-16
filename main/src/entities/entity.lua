local Entity = Class('Entity')

function Entity:initialize(...)
  self.enabled = true

  local components = {...}
  for _, component in ipairs(components) do
    self[component.class.name] = component
    component._entity = self
  end
end

function Entity:setEnabled(enabled)
  self.enabled = enabled
end

function Entity:getEnabled()
  local transform = self['Transform']
  if transform == nil then
    return self.enabled
  end

  if transform.parent == nil then
    return self.enabled
  end

  local parentEntity = transform.parent:getEntity()
  if parentEntity == nil then
    return self.enabled
  end

  return parentEntity:getEnabled() and self.enabled
end

function Entity:addComponent(component)
  self[component.class.name] = component
  component._entity = self
end

function Entity:getComponent(className)
  if self[className] == nil then print('Entity '..self.class.name..' have no '..className..' component') end
  return self[className]
end

function Entity:onAdded()
  for _, component in pairs(self) do
    if type(component) == 'table' then
      if component.class then
        component:entityadded()
      end
    end
  end
end

return Entity