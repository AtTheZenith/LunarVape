pcall(function()
  local c = cloneref or function(v)
    return v
  end
  if getgenv().LunarVapeErrorLogger then return end
  if getgenv().NoLogs then return end

  local function t(ymd)
    local t = tick()
    local ms = string.sub(t - math.floor(t), 2, 7)

    local d = ymd and string.gsub(string.gsub(DateTime.now():ToIsoDate(), 'T', ' ', 1), 'Z', '', 1)
      or string.gsub(string.split(DateTime.now():ToIsoDate(), 'T')[2], 'Z', '', 1)

    return string.format('%s%s', d, ms)
  end

  if not isfolder 'Lunar Vape' then
    makefolder 'Lunar Vape'
  end
  if not isfolder 'Lunar Vape/Logs' then
    makefolder 'Lunar Vape/Logs'
  end

  local name = string.format('Lunar Vape/Logs/Log %04d.txt', #listfiles 'Lunar Vape/Logs' + 1)
  local header = string.format(
    'Lunar Vape Diagnostics Logging\nRoblox Username: %s\nExecutor Name: %s\nTouchEnabled: %s\nHWID: %s\nTime: %s\n=========================================================================',
    c(game:GetService 'Players').LocalPlayer.Name,
    identifyexecutor and identifyexecutor() or 'Cheat Engine',
    c(game:GetService 'UserInputService').TouchEnabled and 'Yes' or 'No',
    gethwid and gethwid() or 'Samsung Fridge',
    t(true)
  )
  writefile(name, header)

  local function debounce_tick(ratio): number
    return math.floor(tick() / (ratio or 1))
  end

  --- {debounce, count, timeWindow, maxCount}
  local debounce1 = {debounce_tick(), 0, 1, 60}
  local debounce2 = {debounce_tick(5), 0, 10, 3}

  getgenv().LunarVapeErrorLogger = c(game:GetService 'LogService').MessageOut:Connect(function(m, v)
    task.wait() -- to prevent potential crashes from recursive logging
    if debounce_tick() ~= debounce1[1] then
      debounce1[1] = debounce_tick(debounce1[3])
      debounce1[2] = 1
    elseif debounce1[2] >= debounce1[4] then
      return
    else
      debounce1[2] = debounce1[2] + 1
    end
    appendfile(name, string.format('\n%s [%s]: %s', t(), string.upper(string.sub(tostring(v), 25)), m))

    if getgenv().LunarVape and getgenv().LunarVape.CreateNotification and string.upper(string.sub(tostring(v), 25)) == 'ERROR' then
      -- function mainapi:CreateNotification(title, text, duration, type)

      if getgenv().LunarVape.Loaded and not string.find(m, 'Lunar Vape') then
        return
      end

      if debounce_tick(debounce2[3]) ~= debounce2[1] then
        debounce2[1] = debounce_tick(debounce2[3])
        debounce2[2] = 1
      elseif debounce2[2] >= debounce2[4] then
        return
      else
        debounce2[2] = debounce2[2] + 1
      end
      
      getgenv().LunarVape:CreateNotification(
        'Lunar Vape Error', m, 5, 'alert'
      )
    end
  end)
end)

print 'Lunar Vape error logging has started.'
print 'Lunar Vape/Loader.lua'

local isfile = isfile
  or function(file)
    local suc, res = pcall(function()
      return readfile(file)
    end)
    return suc and res ~= nil and res ~= ''
  end
local delfile = delfile or function(file)
  writefile(file, '')
end

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

if not isfile 'Lunar Vape/Loader.lua' then
  downloadFile 'Lunar Vape/Loader.lua'
end

local function wipeFolder(path): ()
  if not isfolder(path) then
    return
  end
  for _, file in listfiles(path) do
    if isfolder(file) then
      wipeFolder(file)
    end
    if
      isfile(file)
        and select(
          1,
          readfile(file):find '--This watermark is used to delete the file if its cached, remove it to make the file persist after Lunar Vape updates.'
        ) == 1
      or file:find 'json'
    then
      delfile(file)
    end
  end
end

local folders = {
  'Lunar Vape',
  'Lunar Vape/Game Modules',
  'Lunar Vape/Profiles',
  'Lunar Vape/Assets',
  'Lunar Vape/Libraries',
  'Lunar Vape/GUI',
  'Lunar Vape/Extra',
  'Lunar Vape/Extra/Profiles',
}
for _, folder in folders do
  if not isfolder(folder) then
    makefolder(folder)
  end
end

if not getgenv().LunarVapeDeveloper then
  local _, subbed = pcall(function()
    return game:HttpGet 'https://github.com/AtTheZenith/LunarVape'
  end)
  local commit = subbed:find 'currentOid'
  commit = commit and subbed:sub(commit + 13, commit + 52) or nil
  commit = commit and #commit == 40 and commit or 'main'
  if
    commit == 'main'
    or (isfile 'Lunar Vape/Profiles/Commit.txt' and readfile 'Lunar Vape/Profiles/Commit.txt' or '') ~= commit
  then
    wipeFolder 'Lunar Vape'
    wipeFolder 'Lunar Vape/Game Modules'
    wipeFolder 'Lunar Vape/GUI'
    wipeFolder 'Lunar Vape/Libraries'
    wipeFolder 'Lunar Vape/Extra'
  end
  writefile('Lunar Vape/Profiles/Commit.txt', commit)
end

print 'Lunar Vape/Main.lua'
loadstring(downloadFile 'Lunar Vape/Main.lua', 'Lunar Vape/Main.lua')()