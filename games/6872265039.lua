local cloneref = cloneref or function(obj)
	return obj
end

local playersService = cloneref(game:GetService('Players'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local inputService = cloneref(game:GetService('UserInputService'))

local lplr = playersService.LocalPlayer
local vape = shared.vape
local entitylib = vape.Libraries.entity
local sessioninfo = vape.Libraries.sessioninfo
getgenv().bedwars = {}

local function notif(...)
	return vape:CreateNotification(...)
end

local function run(func)
	xpcall(func, function(err)
        local time, timestamp, date, filecontents, contents = string.lower(os.date('%I:%M%p')), nil, os.date('%d/%m/%y')

        do
            if isfile('newvape/error.txt') then
                filecontents = readfile('newvape/error.txt')
            end

            timestamp = `{time}, {date}`
            contents = ((filecontents and filecontents ~= '') and `{filecontents}\n\ntimestamp: {timestamp}\nerror: {debug.traceback(err, 2)}`) or `timestamp: {timestamp}\nerror: {debug.traceback(err, 2)}`
        end

        writefile('newvape/error.txt', contents)
        notif('Vape', `Module failed to load: {tostring(err)}`, 10, 'alert')
    end)
end

local function downloadFile(path, callback)
	if not isfile(path) then
		local success, data = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/stxxv/VapeCompiled/'..readfile('newvape/profiles/commit.txt')..'/'..select(1, path:gsub('newvape/', '')), true)
		end)
		if not success or data == '404: Not Found' then
			error(data)
		end
		if path:find('.lua') then
			data = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..data
		end
		writefile(path, data)
	end
	return (callback or readfile)(path)
end
getgenv().downloadFile = downloadFile

run(function()
	for _, v in {'newvape/libraries/bedwars', 'newvape/libraries/bedwars/lobby'} do
		if not isfolder(v) then
			makefolder(v)
		end
	end

	local construct = loadstring(downloadFile('newvape/libraries/bedwars/lobby/construct.lua'))()
	repeat task.wait() until construct ~= nil and construct.loaded
end)

entitylib.start()

for i, v in vape.Modules do
	if v.Category == 'Combat' then
		vape:Remove(i)
	end
end


run(function()
	local Sprint
	local old
	
	Sprint = vape.Categories.Combat:CreateModule({
		Name = 'Sprint',
		Function = function(callback)
			if callback then
				if inputService.TouchEnabled then pcall(function() lplr.PlayerGui.MobileUI['2'].Visible = false end) end
				old = bedwars.SprintController.stopSprinting
				bedwars.SprintController.stopSprinting = function(...)
					local call = old(...)
					bedwars.SprintController:startSprinting()
					return call
				end
				Sprint:Clean(entitylib.Events.LocalAdded:Connect(function() bedwars.SprintController:stopSprinting() end))
				bedwars.SprintController:stopSprinting()
			else
				if inputService.TouchEnabled then pcall(function() lplr.PlayerGui.MobileUI['2'].Visible = true end) end
				bedwars.SprintController.stopSprinting = old
				bedwars.SprintController:stopSprinting()
			end
		end,
		Tooltip = 'Sets your sprinting to true.'
	})
end)

run(function()
	local AutoGamble
	
	AutoGamble = vape.Categories.World:CreateModule({
		Name = 'AutoGamble',
		Function = function(callback)
			if callback then
				AutoGamble:Clean(bedwars.Client:GetNamespace('RewardCrate'):Get('CrateOpened'):Connect(function(data)
					if data.openingPlayer == lplr then
						local tab = bedwars.CrateItemMeta[data.reward.itemType] or {displayName = data.reward.itemType or 'unknown'}
						notif('AutoGamble', 'Won '..tab.displayName, 5)
					end
				end))
	
				repeat
					if not bedwars.CrateAltarController.activeCrates[1] then
						for _, v in bedwars.Store:getState().Consumable.inventory do
							if v.consumable:find('crate') then
								bedwars.CrateAltarController:pickCrate(v.consumable, 1)
								task.wait(1.2)
								if bedwars.CrateAltarController.activeCrates[1] and bedwars.CrateAltarController.activeCrates[1][2] then
									bedwars.Client:GetNamespace('RewardCrate'):Get('OpenRewardCrate'):SendToServer({
										crateId = bedwars.CrateAltarController.activeCrates[1][2].attributes.crateId
									})
								end
								break
							end
						end
					end
					task.wait(1)
				until not AutoGamble.Enabled
			end
		end,
		Tooltip = 'Automatically opens lucky crates, piston inspired!'
	})
end)