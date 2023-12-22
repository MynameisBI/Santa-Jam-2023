local Phase = require 'src.components.phase'
local TeamSynergy = require 'src.components.teamSynergy'

local System = require 'src.systems.system'

local ManageCrack = Class('ManageCrack', System)

function ManageCrack:initialize()
  System.initialize(self)
end

function ManageCrack:earlysystemupdate(dt)
  
end

return ManageCrack