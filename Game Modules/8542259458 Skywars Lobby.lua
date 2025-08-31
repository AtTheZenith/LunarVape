local run = function(blacklist, func)
  if type(blacklist) == 'function' then
    blacklist()
    return
  end
  if table.find(blacklist, (identifyexecutor())) then
    return
  end
  func()
end
local cloneref = cloneref or function(obj)
  return obj
end
local playersService = cloneref(game:GetService 'Players')
local inputService = cloneref(game:GetService 'UserInputService')
local replicatedStorage = cloneref(game:GetService 'ReplicatedStorage')
local collectionService = cloneref(game:GetService 'CollectionService')
local httpService = cloneref(game:GetService 'HttpService')
local coreGui = cloneref(game:GetService 'CoreGui')
local gameCamera = workspace.CurrentCamera
local lplr = playersService.LocalPlayer

local LunarVape = _G.LunarVape
local sessioninfo = LunarVape.Libraries.sessioninfo

run(function()
  local kills = sessioninfo:AddItem 'Kills'
  local eggs = sessioninfo:AddItem 'Eggs'
  local wins = sessioninfo:AddItem 'Wins'
  local games = sessioninfo:AddItem 'Games'
end)
