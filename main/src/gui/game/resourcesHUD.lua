local ResourcesHUD = Class('ResourcesHUD')

function ResourcesHUD:initialize()
  self.suit = Suit.new()
end

function ResourcesHUD:update(dt)
  
end

function ResourcesHUD:draw()
  self.suit:draw()
end

return ResourcesHUD