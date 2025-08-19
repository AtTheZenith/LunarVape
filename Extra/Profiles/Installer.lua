local registry = {
  ['11630038968'] = 'Bridge Duels',
  ['6872274481'] = 'Bedwars Match',
}

registry.__index = function(...): boolean return false end

while not _G.LunarVape do task.wait() end
local LunarVape = _G.LunarVape
if not registry[tostring(LunarVape.Place)] then return end
local GAME_NAME = tostring(LunarVape.Place)

local function downloadFile(path, func)
	if not isfile(path) and not _G.LunarVapeDeveloper then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/AtTheZenith/LunarVape/'..(isfile('Lunar Vape/Profiles/commit.txt') and readfile('Lunar Vape/Profiles/commit.txt') or 'main')..'/'..(string.gsub(path, 'Lunar Vape/', '')), true)
		end)
		if res == '404: Not Found' or res == '' then
			warn(string.format('Error while downloading file %s: %s', path, res)); return
		elseif not suc then
			warn(string.format('Error while downloading file %s: %s', path, res)); return
		end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after Lunar Vape updates.\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

local Dir = string.format('Lunar Vape/Extra/Profiles/%s', registry[GAME_NAME])
if not isfolder(Dir) then makefolder(Dir) end

local Files = loadstring(downloadFile(Dir .. '/Files.lua'))()
if not isfolder('Lunar Vape/Profiles') then makefolder('Lunar Vape/Profiles') end
if Files then
	for _, File in Files do
		if isfile('Lunar Vape/Profiles/' .. File) then continue end
		writefile('Lunar Vape/Profiles/' .. File, downloadFile(string.format('Lunar Vape/Extra/Profiles/%s/%s', registry[GAME_NAME], File)))
	end
end