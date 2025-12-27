repeat
  task.wait()
until game:IsLoaded()
if getgenv().LunarVape then
  getgenv().LunarVape:Uninject()
end

if identifyexecutor then
  if table.find({ 'Xeno' }, (identifyexecutor())) then
    game:GetService('Players').LocalPlayer:Kick [[don't use xeno, it's skidded 😘]]
    task.wait(0.4)
    while true do
    end
  end
end

local LunarVape


local queue_on_teleport = queue_on_teleport or function() end

-- test fix for hydrogen lol
local loadstring = identifyexecutor() == 'Hyrdrogen' and loadstring or function(script, name)
  print(name)
  local res, err = loadstring(script, name)
  if err then
    error(err)
  end
  return res
end

local isfile = isfile
  or function(file)
    local suc, res = pcall(function()
      return readfile(file)
    end)
    return suc and res ~= nil and res ~= ''
  end

local cloneref = cloneref or function(obj)
  return obj
end

local playersService = cloneref(game:GetService 'Players')

local function downloadFile(path, func)
  if not isfile(path) and not getgenv().LunarVapeDeveloper then
    local suc, res = pcall(function()
      return game:HttpGet(
        ('https://raw.githubusercontent.com/AtTheZenith/LunarVape/'
          .. (isfile 'Lunar Vape/Profiles/commit.txt' and readfile 'Lunar Vape/Profiles/commit.txt' or 'main')
          .. '/'
          .. (string.gsub(path, 'Lunar Vape/', ''))):gsub(' ', '%%20'),
        true
      )
    end)
    if res == '404: Not Found' or not suc then
      error(string.format('Error while downloading file %s: %s', path, res))
      return false
    end
    if path:find '.lua' then
      res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after Lunar Vape updates.\n'
        .. res
    end
    writefile(path, res)
  end
  return (func or readfile)(path)
end

local function finishLoading()
  LunarVape.Init = nil
  LunarVape:Load()
  task.spawn(function()
    task.wait(10)
    while LunarVape and LunarVape.Loaded do
      LunarVape:Save()
      task.wait(10)
    end
  end)

  local teleportedServers
  if getgenv().ReloadOnJoin == true or isfile 'Lunar Vape/LoadOnRejoin' or isfile 'Lunar Vape/LoadOnRejoin.txt' then
    LunarVape:Clean(playersService.LocalPlayer.OnTeleport:Connect(function()
      if (not teleportedServers) and not getgenv().LunarVapeIndependent then
        teleportedServers = true
        local teleportScript = [[
        getgenv().ReloadOnJoin = true
        if getgenv().LunarVapeDeveloper then
          loadstring(readfile('Lunar Vape/Loader.lua'), 'Lunar Vape/Loader.lua')()
        else
          loadstring(game:HttpGet('https://raw.githubusercontent.com/AtTheZenith/LunarVape/main/Loader.lua', true), 'Lunar Vape/Loader.lua')()
        end
        ]]
        if getgenv().LunarVapeDeveloper then
          teleportScript = 'getgenv().LunarVapeDeveloper = true\n' .. teleportScript
        end
        if getgenv().LunarVapeCustomProfile then
          teleportScript = 'getgenv().LunarVapeCustomProfile = "' .. getgenv().LunarVapeCustomProfile .. '"\n' .. teleportScript
        end
        LunarVape:Save()
        queue_on_teleport(teleportScript)
      end
    end))
  end

  if not LunarVape.Categories then
    return
  end
  if LunarVape.Categories.Main.Options['GUI bind indicator'].Enabled then
    LunarVape:CreateNotification('Lunar Vape', 'Lunar Vape has finished loading.', 6)
  end
end

-- if not isfile 'Lunar Vape/Profiles/GUI.txt' then
--   writefile('Lunar Vape/Profiles/GUI.txt', 'Vape V4')
-- end
local gui = 'Vape V4'

if not isfolder('Lunar Vape/Assets/' .. gui) then
  makefolder('Lunar Vape/Assets/' .. gui)
end

-- retarded solution in attempt to fix hydrogen
loadstring(downloadFile('Lunar Vape/GUI/' .. gui .. '.lua'), 'Lunar Vape/GUI/' .. gui .. '.lua')()
LunarVape = getgenv().LunarVape

LunarVape.Place = game.PlaceId
local GAME_REGISTRY =
  loadstring(downloadFile 'Lunar Vape/Game Modules/Registry.lua', 'Lunar Vape/Game Modules/Registry.lua')()
local GAME_NAME = if GAME_REGISTRY[tostring(LunarVape.Place)]
  then ' ' .. GAME_REGISTRY[tostring(LunarVape.Place)]
  else false

if not getgenv().LunarVapeIndependent then
  loadstring(downloadFile 'Lunar Vape/Game Modules/Universal.lua', 'Lunar Vape/Game Modules/Universal.lua')()
  if GAME_NAME and isfile('Lunar Vape/Game Modules/' .. LunarVape.Place .. GAME_NAME .. '.lua') then
    loadstring(
      readfile('Lunar Vape/Game Modules/' .. LunarVape.Place .. GAME_NAME .. '.lua'),
      tostring('Lunar Vape/Game Modules/' .. LunarVape.Place .. GAME_NAME .. '.lua')
    )()
  else
    if not getgenv().LunarVapeDeveloper and GAME_NAME then
      downloadFile('Lunar Vape/Game Modules/' .. LunarVape.Place .. GAME_NAME .. '.lua')
      loadstring(
        readfile('Lunar Vape/Game Modules/' .. LunarVape.Place .. GAME_NAME .. '.lua'),
        tostring('Lunar Vape/Game Modules/' .. LunarVape.Place .. GAME_NAME .. '.lua')
      )()
    end
  end
  loadstring(downloadFile 'Lunar Vape/Extra/Profiles/Installer.lua', 'Lunar Vape/Extra/Profiles/Installer.lua')()
  finishLoading()
else
  LunarVape.Init = finishLoading
  return LunarVape
end