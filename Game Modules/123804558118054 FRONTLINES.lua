local LunarVape = _G.LunarVape
local loadstring = function(...)
  local res, err = loadstring(...)
  if err and LunarVape then
    warn(err)
    LunarVape:CreateNotification('Lunar Vape', 'Failed to load : ' .. err, 30, 'Alert')
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
    if not suc or res == '404: Not Found' then
      error(res)
    end
    if path:find '.lua' then
      res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after LunarVape updates.\n'
        .. res
    end
    writefile(path, res)
  end
  return (func or readfile)(path)
end

LunarVape.Place = 5938036553
local GAME_REGISTRY = loadstring(downloadFile 'Lunar Vape/Game Modules/Registry.lua')()
local GAME_NAME = if GAME_REGISTRY[tostring(LunarVape.Place)]
  then ' ' .. GAME_REGISTRY[tostring(LunarVape.Place)]
  else false

if GAME_NAME and isfile('Lunar Vape/Game Modules/' .. LunarVape.Place .. GAME_NAME .. '.lua') then
  loadstring(
    readfile('Lunar Vape/Game Modules/' .. LunarVape.Place .. GAME_NAME .. '.lua'),
    'Lunar Vape/Game Modules/' .. LunarVape.Place .. GAME_NAME .. '.lua'
  )()
else
  if not _G.LunarVapeDeveloper then
    local suc, res = pcall(function()
      return downloadFile('Lunar Vape/Game Modules/' .. LunarVape.Place .. GAME_NAME .. '.lua')
    end)
    if suc and res ~= '404: Not Found' then
      loadstring(
        readfile('Lunar Vape/Game Modules/' .. LunarVape.Place .. GAME_NAME .. '.lua'),
        'Lunar Vape/Game Modules/' .. LunarVape.Place .. GAME_NAME .. '.lua'
      )()
    end
  end
end

