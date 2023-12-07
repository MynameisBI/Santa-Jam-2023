local System = Class('System')

local callbackNames = {
  'entityadded', 'entityremoved', 'update', 'worlddraw', 'screendraw',
  'keypressed', 'keyreleased', 'mousepressed', 'mousereleased', 'mousemoved'
}

function System:initialize(...)
  self.enabled = true

  self.aspects = {...} or {}

  self.callbacks = {}
  for _, callbackName in ipairs(callbackNames) do
    local callback = self[callbackName]
    if callback ~= nil then
      self.callbacks[callbackNames] = callback
      self[callbackName] = Knife.System(self.aspects, function(...) callback(self, ...) end)  
    end
  end
end

function System:setEnabled(enabled)
  self.enabled = enabled
end

function System:getEnabled()
  return self.enabled
end

return System






