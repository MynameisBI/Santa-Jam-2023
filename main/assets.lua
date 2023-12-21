-- Doesn't work with web build
Images = {
  diamond = love.graphics.newImage('assets/diamond.png'),
  environment = Clove.importAll('assets/environment', true),
  heroes = Clove.importAll('assets/heroes', true),
  pets = Clove.importAll('assets/pets', true),
  mods = Clove.importAll('assets/mods', true),
  icons = Clove.importAll('assets/icons', true),
  enemies = Clove.importAll('assets/enemies', true),
}

-- local lg = love.graphics
-- Images = {
--   diamond = lg.newImage('assets/diamond.png'),
--   environment = {
--     buildings = lg.newImage('assets/environment/buildings.png'),
--     platform = lg.newImage('assets/environment/platform.png'),
--     sky = lg.newImage('assets/environment/sky.png'),
--   },
--   heroes = {
--     alestra = lg.newImage('assets/heroes/alestra.png'),
--     aurora = lg.newImage('assets/heroes/aurora.png'),
--     brae = lg.newImage('assets/heroes/brae.png'),
--     brunnos = lg.newImage('assets/heroes/brunnos.png'),
--     cloud = lg.newImage('assets/heroes/cloud.png'),
--     cole = lg.newImage('assets/heroes/cole.png'),
--     hakiko = lg.newImage('assets/heroes/hakiko.png'),
--     ['k\'eon'] = lg.newImage('assets/heroes/k\'eon.png'),
--     kori = lg.newImage('assets/heroes/kori.png'),
--     nathanael = lg.newImage('assets/heroes/nathanael.png'),
--     raylee = lg.newImage('assets/heroes/raylee.png'),
--     rover = lg.newImage('assets/heroes/rover.png'),
--     sasami = lg.newImage('assets/heroes/sasami.png'),
--     ['s\'kott'] = lg.newImage('assets/heroes/s\'kott.png'),
--     soniya = lg.newImage('assets/heroes/soniya.png'),
--     tom = lg.newImage('assets/heroes/tom.png'),
--   },
--   mods = {
--     modHolder = lg.newImage('assets/mods/modHolder.png'),
--     scrapPack = lg.newImage('assets/mods/scrapPack.png'),
--     psychePack = lg.newImage('assets/mods/psychePack.png'),
--     bioPack = lg.newImage('assets/mods/bioPack.png'),
--     placeholder = lg.newImage('assets/mods/placeholder.png'),
--   },
--   icons = {
--     bigEarIcon = lg.newImage('assets/icons/bigEarIcon.png'),
--     sentientIcon = lg.newImage('assets/icons/sentientIcon.png'),
--     defectIcon = lg.newImage('assets/icons/defectIcon.png'),
--     candyheadIcon = lg.newImage('assets/icons/candyheadIcon.png'),
--     coordinatorIcon = lg.newImage('assets/icons/coordinatorIcon.png'),
--     artificerIcon = lg.newImage('assets/icons/artificerIcon.png'),
--     trailblazerIcon = lg.newImage('assets/icons/trailblazerIcon.png'),
--     droneMaestroIcon = lg.newImage('assets/icons/droneMaestroIcon.png'),
--     crackerIcon = lg.newImage('assets/icons/crackerIcon.png'),
--     moneyIcon = lg.newImage('assets/icons/moneyIcon.png'),
--     styleIcon = lg.newImage('assets/icons/styleIcon.png'),
--   }
-- }

Fonts = {
  small = love.graphics.newFont('assets/04B_03__.TTF', 8),
  medium = love.graphics.newFont('assets/04B_03__.TTF', 16),
  big = love.graphics.newFont('assets/04B_03__.TTF', 24),
  large = love.graphics.newFont('assets/04B_03__.TTF', 32),
  huge = love.graphics.newFont('assets/04B_03__.TTF', 40),
}
