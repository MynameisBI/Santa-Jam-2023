local SingletonComponent = require 'src.components.singletonComponent'

local BumpWorld = SingletonComponent:subclass('BumpWorld')

function BumpWorld:initialize(cellsize)
  SingletonComponent.initialize(self)

  self:clear(cellsize)
end

function BumpWorld:clear(cellsize)
  self.world = Bump.newWorld(cellsize)
end

return BumpWorld