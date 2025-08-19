local LunarVape = shared.LunarVape or getgenv().LunarVape or _G.LunarVape

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

local playersService = cloneref(game:GetService 'Players')
local replicatedStorage = cloneref(game:GetService 'ReplicatedStorage')
local runService = cloneref(game:GetService 'RunService')
local inputService = cloneref(game:GetService 'UserInputService')

local gameCamera = workspace.CurrentCamera or workspace:FindFirstChildWhichIsA 'Camera'
local lplr = playersService.LocalPlayer
