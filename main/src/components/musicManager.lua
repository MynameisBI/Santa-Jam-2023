local SingletonComponent = require 'src.components.singletonComponent'

local MusicManager = SingletonComponent:subclass('MusicManager')

function MusicManager:initialize(songs)
  self.songs = songs -- <string, Source>
end

function MusicManager:switch(key)

end

return MusicManager