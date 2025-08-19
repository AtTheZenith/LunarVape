repeat
  task.wait()
until game:IsLoaded()
if _G.LunarVape then
  _G.LunarVape:Uninject()
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
local loadstring = function(script, name)
  print(name)
  local res, err = loadstring(script, name)
  if err and LunarVape then
    warn(err)
    LunarVape:CreateNotification('Lunar Vape', 'Failed to load: ' .. err, 30, 'alert')
  end
  return res
end
local queue_on_teleport = queue_on_teleport or function() end
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
  if not isfile(path) and not _G.LunarVapeDeveloper then
    local suc, res = pcall(function()
      return game:HttpGet(
        'https://raw.githubusercontent.com/AtTheZenith/LunarVape/'
          .. readfile 'Lunar Vape/Profiles/Commit.txt'
          .. '/'
          .. select(1, path:gsub('Lunar Vape/', '')),
        true
      )
    end)
    if res == '404: Not Found' then
      warn(string.format('Error while downloading file %s: %s', path, res))
      return false
    elseif not suc then
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
    repeat
      LunarVape:Save()
      task.wait(10)
    until not LunarVape or not LunarVape.Loaded
  end)

  local teleportedServers
  if _G.ReloadOnJoin == true or isfile 'Lunar Vape/LoadOnRejoin' or isfile 'Lunar Vape/LoadOnRejoin.txt' then
    LunarVape:Clean(playersService.LocalPlayer.OnTeleport:Connect(function()
      if (not teleportedServers) and not _G.LunarVapeIndependent then
        teleportedServers = true
        local teleportScript = [[
        _G.ReloadOnJoin = true
        if _G.LunarVapeDeveloper then
          loadstring(readfile('Lunar Vape/Loader.lua'), 'Lunar Vape/Loader.lua')()
        else
          loadstring(game:HttpGet('https://raw.githubusercontent.com/AtTheZenith/LunarVape/main/Loader.lua', true), 'Lunar Vape/Loader.lua')()
        end
        ]]
        if _G.LunarVapeDeveloper then
          teleportScript = '_G.LunarVapeDeveloper = true\n' .. teleportScript
        end
        if _G.LunarVapeCustomProfile then
          teleportScript = '_G.LunarVapeCustomProfile = "' .. _G.LunarVapeCustomProfile .. '"\n' .. teleportScript
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

if not isfile 'Lunar Vape/Profiles/GUI.txt' then
  writefile('Lunar Vape/Profiles/GUI.txt', 'Vape V4')
end
local gui = readfile 'Lunar Vape/Profiles/GUI.txt' or 'Vape V4'

if not isfolder('Lunar Vape/Assets/' .. gui) then
  makefolder('Lunar Vape/Assets/' .. gui)
end

LunarVape = loadstring(downloadFile('Lunar Vape/GUI/' .. gui .. '.lua'), 'Lunar Vape/GUI/' .. gui .. '.lua')()
_G.LunarVape = LunarVape

LunarVape.Place = game.PlaceId
local GAME_REGISTRY =
  loadstring(downloadFile 'Lunar Vape/Game Modules/Registry.lua', 'Lunar Vape/Game Modules/Registry.lua')()
local GAME_NAME = if GAME_REGISTRY[tostring(LunarVape.Place)]
  then ' ' .. GAME_REGISTRY[tostring(LunarVape.Place)]
  else false

if not _G.LunarVapeIndependent then
  loadstring(downloadFile 'Lunar Vape/Game Modules/Universal.lua', 'Lunar Vape/Game Modules/Universal.lua')()
  if GAME_NAME and isfile('Lunar Vape/Game Modules/' .. LunarVape.Place .. GAME_NAME .. '.lua') then
    loadstring(
      readfile('Lunar Vape/Game Modules/' .. LunarVape.Place .. GAME_NAME .. '.lua'),
      tostring('Lunar Vape/Game Modules/' .. LunarVape.Place .. GAME_NAME .. '.lua')
    )()
  else
    if not _G.LunarVapeDeveloper and GAME_NAME then
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
