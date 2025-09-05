-- if cloneref(game:GetService 'UserInputService' ).TouchEnabled then
--   return
-- end

local registry = {
  ['11630038968'] = 'Bridge Duels',
  ['12998806177'] = 'Killstreak',
  ['6872274481'] = 'Bedwars Match',
}

while not getgenv().LunarVape do task.wait() end
local LunarVape = getgenv().LunarVape
if not registry[tostring(LunarVape.Place)] then return end
local GAME_ID = tostring(LunarVape.Place)

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

local Dir = string.format('Lunar Vape/Extra/Profiles/%s', registry[GAME_ID])
if not isfolder(Dir) then makefolder(Dir) end

local Files = loadstring(downloadFile(Dir .. '/Files.lua'))()
if not isfolder('Lunar Vape/Profiles') then makefolder('Lunar Vape/Profiles') end
if Files then
	for _, File in Files do
		if isfile('Lunar Vape/Profiles/' .. File) then continue end
		local data = downloadFile(string.format('Lunar Vape/Extra/Profiles/%s/%s', registry[GAME_ID], File))
		if not data or data == '' then continue end
		writefile('Lunar Vape/Profiles/' .. File, data)
	end
end