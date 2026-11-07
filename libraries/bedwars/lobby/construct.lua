--[[

    comboss 764.
    construct.json is automatically generated with the help of tel aviv.

    Note: This code has been altered with AI, take with caution.

]]

local cloneref = cloneref or function(obj)
	return obj
end

local playersService = cloneref(game:GetService("Players"))
local replicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local runService = cloneref(game:GetService("RunService"))
local inputService = cloneref(game:GetService("UserInputService"))
local tweenService = cloneref(game:GetService("TweenService"))
local httpService = cloneref(game:GetService("HttpService"))
local textChatService = cloneref(game:GetService("TextChatService"))
local collectionService = cloneref(game:GetService("CollectionService"))
local contextActionService = cloneref(game:GetService("ContextActionService"))
local guiService = cloneref(game:GetService("GuiService"))
local coreGui = cloneref(game:GetService("CoreGui"))
local starterGui = cloneref(game:GetService("StarterGui"))
local debris = cloneref(game:GetService("Debris"))
local workspace = cloneref(game:GetService("Workspace"))
local lighting = cloneref(game:GetService("Lighting"))
local soundService = cloneref(game:GetService("SoundService"))

local gameCamera = workspace.CurrentCamera
local lplr = playersService.LocalPlayer

local vape = shared.vape
local entitylib = vape.Libraries.entity
local targetinfo = vape.Libraries.targetinfo
local sessioninfo = vape.Libraries.sessioninfo
local uipallet = vape.Libraries.uipallet
local tween = vape.Libraries.tween
local color = vape.Libraries.color
local whitelist = vape.Libraries.whitelist
local prediction = vape.Libraries.prediction
local getfontbounds = vape.Libraries.getfontbounds
local getvapeasset = vape.Libraries.getvapeasset

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

local function ceCheck()
	if not (require or debug.getupvalue or debug.getupvalues or debug.getconstants or debug.getconstant or debug.getproto or debug.getprotos or debug.setconstant) then
		return true
	end

	local exec = string.lower(getexecutorname()) or "none"
	if table.find({'xeno', 'solara', 'none'}, exec) then
		return true
	end

	local request = http and http.request or http_request or request or httprequest
	local req = request({
		Url = "https://mockhttp.org/get",
		Method = "GET",
		Headers = {
			["Content-Type"] = "application/json",
		},
	})

	if req.Success then
		local data = httpService:JSONDecode(req.Body)

		for i, v in data.headers do
			if string.find(i, "xeno") then
				return true
			end
		end
	end

	local suc, res = pcall(function()
		return require(lplr.PlayerScripts.PlayerModule).controls
	end)

	if not suc or not res or type(res) ~= "table" then
		return true
	end

	return false
end

getgenv().ce = ceCheck()
if not ce then
    run(function()
        local function dumpRemote(tab)
            local ind = table.find(tab, 'Client')
            return ind and tab[ind + 1] or ''
        end

        local KnitInit, Knit
        repeat
            KnitInit, Knit = pcall(function() return debug.getupvalue(require(lplr.PlayerScripts.TS.knit).setup, 9) end)
            if KnitInit then break end
            task.wait()
        until KnitInit
        if not debug.getupvalue(Knit.Start, 1) then
            repeat task.wait() until debug.getupvalue(Knit.Start, 1)
        end
        local Flamework = require(replicatedStorage['rbxts_include']['node_modules']['@flamework'].core.out).Flamework
        local Client = require(replicatedStorage.TS.remotes).default.Client

        bedwars = setmetatable({
            Client = Client,
            CrateItemMeta = debug.getupvalue(Flamework.resolveDependency('client/controllers/global/reward-crate/crate-controller@CrateController').onStart, 3),
            Store = require(lplr.PlayerScripts.TS.ui.store).ClientStore
        }, {
            __index = function(self, ind)
                rawset(self, ind, Knit.Controllers[ind])
                return rawget(self, ind)
            end
        })

        local kills = sessioninfo:AddItem('Kills')
        local beds = sessioninfo:AddItem('Beds')
        local wins = sessioninfo:AddItem('Wins')
        local games = sessioninfo:AddItem('Games')

        vape:Clean(function()
            table.clear(bedwars)
        end)
    end)

    return {loaded = true}
end

local meta
run(function()
	for _, v in {'newvape/libraries/bedwars', 'newvape/libraries/bedwars/lobby'} do
		if not isfolder(v) then
			makefolder(v)
		end
	end

	meta = downloadFile('newvape/libraries/bedwars/lobby/construct.json')
	repeat
		task.wait()
	until meta ~= nil

	local suc, res = pcall(function()
		return httpService:JSONDecode(meta)
	end)

	if suc and res ~= nil and type(res) == 'table' then
		meta = res
	else
		meta = {}
	end
end)

bedwars.CrateItemMeta = setmetatable(meta.CrateItemMeta or {}, {
	__index = function()
		return {}
	end,
})

--[[

    Emulation in order

]]

local netManaged = replicatedStorage.rbxts_include.node_modules['@rbxts'].net.out._NetManaged

local function newPromise(func, ...)
	local promiseArgs = table.pack(...)
	local promise = { thenFunctions = {}, errFunctions = {}, results = nil, resolved = false, rejected = false }
	local function resolve(...)
		if promise.resolved or promise.rejected then
			return
		end
		promise.resolved = true
		promise.results = table.pack(...)
		for _, v in promise.thenFunctions do
			task.spawn(v, ...)
		end
		table.clear(promise.thenFunctions)
		table.clear(promise.errFunctions)
	end
	local function reject(...)
		if promise.resolved or promise.rejected then
			return
		end
		promise.rejected = true
		promise.results = table.pack(...)
		for _, v in promise.errFunctions do
			task.spawn(v, ...)
		end
		table.clear(promise.thenFunctions)
		table.clear(promise.errFunctions)
	end
	promise.andThen = function(self, callback)
		if self.resolved then
			task.spawn(callback, table.unpack(self.results, 1, self.results.n))
		elseif not self.rejected then
			table.insert(self.thenFunctions, callback)
		end
		return self
	end
	promise.catch = function(self, callback)
		if self.rejected then
			task.spawn(callback, table.unpack(self.results, 1, self.results.n))
		elseif not self.resolved then
			table.insert(self.errFunctions, callback)
		end
		return self
	end
	task.spawn(function()
		local args = table.pack(pcall(func, table.unpack(promiseArgs, 1, promiseArgs.n)))
		if args[1] then
			resolve(table.unpack(args, 2, args.n))
		else
			reject(args[2])
		end
	end)
	return promise
end

local emptyRemote = {
	instance = nil,
	SendToServer = function() end,
	CallServer = function() end,
	CallServerAsync = function()
		return newPromise(function() end)
	end,
	Connect = function()
		return { Disconnect = function() end, disconnect = function() end }
	end,
}

local function getRemoteData(remote)
	if not remote then
		return nil
	end
	return {
		instance = remote,
		SendToServer = function(self, ...)
			return remote:FireServer(...)
		end,
		CallServer = function(self, ...)
			return remote:InvokeServer(...)
		end,
		CallServerAsync = function(self, ...)
			local args = { ... }
			return newPromise(function()
				return remote:InvokeServer(table.unpack(args))
			end)
		end,
		Connect = function(self, callback)
			return remote.OnClientEvent:Connect(callback)
		end,
	}
end

local clientCache = {}
bedwars.Client = {
	Get = function(self, remoteName)
		if not clientCache[remoteName] then
			clientCache[remoteName] = getRemoteData(netManaged:FindFirstChild(remoteName)) or emptyRemote
		end
		return clientCache[remoteName]
	end,
	GetNamespace = function(self, namespace)
		return {
			Get = function(_, remoteName)
				return bedwars.Client:Get(namespace .. '/' .. remoteName)
			end,
		}
	end,
	WaitFor = function(self, remoteName)
		return newPromise(function()
			return netManaged:WaitForChild(remoteName)
		end)
	end,
}

local lobbyState = {
	Consumable = {
		inventory = {},
		record = {},
	},
}

bedwars.Store = {
	getState = function()
		return lobbyState
	end,
	dispatch = function() end,
	changed = {
		connect = function()
			return { disconnect = function() end }
		end,
	},
}

local consumableUpdate = netManaged:FindFirstChild('ConsumableUpdate')
if consumableUpdate then
	vape:Clean(consumableUpdate.OnClientEvent:Connect(function(data)
		lobbyState.Consumable.inventory = data.inventory or {}
		lobbyState.Consumable.record = data.record or {}
	end))
end

bedwars.FovController = {
	fov = gameCamera.FieldOfView,
	fovMultiplier = 1,

	setFOV = function(self, fov)
		if typeof(fov) ~= 'number' then
			return
		end
		self.fov = fov * self.fovMultiplier
		gameCamera.FieldOfView = self.fov
	end,

	getFOV = function(self)
		return self.fov
	end,
}

local SprintConstants = {
	WALK_SPEED = 14,
	RUN_SPEED = 20,
	RUN_FOV_MULT = 1.1,
}

bedwars.SprintController = {
	sprinting = false,
	attemptingSprint = false,
	blockSprint = false,
	moveSpeedMultiplier = 1,
	maxSpeed = nil,
	immediateStop = false,
	shiftLockEnabled = false,
	RUN_SPEED = SprintConstants.RUN_SPEED,
	WALK_SPEED = SprintConstants.WALK_SPEED,
}

bedwars.SprintController.setSpeed = function(self, speed)
	local character = lplr.Character
	local humanoid = character and character:FindFirstChild('Humanoid')
	if not humanoid then
		return
	end
	local value = speed * (self.moveSpeedMultiplier or 1)
	if self.maxSpeed and self.maxSpeed > 0 then
		value = math.min(self.maxSpeed, value)
	end
	humanoid.WalkSpeed = value
end

bedwars.SprintController.tweenCameraFOV = function(_, fov, duration)
	local tween =
		tweenService:Create(gameCamera, TweenInfo.new(duration or 0.1, Enum.EasingStyle.Linear), { FieldOfView = fov })
	tween:Play()
	local cleaned = false
	local maid = {
		DoCleaning = function()
			if cleaned then
				return
			end
			cleaned = true
			pcall(function()
				tween:Cancel()
				tween:Destroy()
			end)
		end,
	}
	maid.Destroy = maid.DoCleaning
	return maid
end

bedwars.SprintController.isSprinting = function(self)
	return self.sprinting
end

bedwars.SprintController.startSprinting = function(self)
	if self.blockSprint then
		return nil
	end
	self.sprinting = true
	self.attemptingSprint = true
	lplr:SetAttribute('Sprinting', true)
	self:setSpeed(SprintConstants.RUN_SPEED)
	self:tweenCameraFOV(bedwars.FovController:getFOV() * SprintConstants.RUN_FOV_MULT, 0.1)
end

bedwars.SprintController.stopSprinting = function(self, resetAttempting, immediateStop)
	if immediateStop == nil then
		immediateStop = false
	end
	lplr:SetAttribute('Sprinting', false)
	if not self.sprinting then
		return nil
	end
	self.sprinting = false
	self:setSpeed(SprintConstants.WALK_SPEED)
	local restoreTween = self:tweenCameraFOV(bedwars.FovController:getFOV(), 0.1)
	if immediateStop then
		restoreTween:DoCleaning()
	end
	self.immediateStop = false
	if resetAttempting then
		self.attemptingSprint = false
	end
end

-- respawn: re-apply sprint state (real WatchCharacter behavior)
vape:Clean(lplr.CharacterAdded:Connect(function()
	task.defer(function()
		if bedwars.SprintController.sprinting then
			bedwars.SprintController:startSprinting()
		else
			bedwars.SprintController:stopSprinting(false)
		end
	end)
end))

bedwars.CrateAltarController = {
	altars = {},
	activeCrates = {},
	pickCrate = function(self, crateType, altarId, useAltarUpgrade)
		bedwars.Client:Get('RewardCrate/SpawnRewardCrate'):SendToServer({ crateType = crateType, altarId = altarId, useAltarUpgrade = useAltarUpgrade })
	end,
	requestOpenCrate = function(self, crateId, altarId)
		bedwars.Client:Get('RewardCrate/OpenRewardCrate'):SendToServer({ crateId = crateId, altarId = altarId })
		self:onCrateOpened(altarId)
	end,
	onCrateOpened = function(self, altarId) end,
}

-- components are flamework-only on the real client, so the tag itself is what the
-- emulation watches: RewardCrate models carry altarId/crateId/crateType attributes
local function trackCrateAltars()
	local controller = bedwars.CrateAltarController

	local function addAltar(model)
		if not model:IsA('Model') then
			return
		end
		local id = model:GetAttribute('id')
		if id == nil then
			return
		end
		-- attributes is the component's plain attribute table, not the instance
		controller.altars[id] = { instance = model, attributes = model:GetAttributes() }
	end

	local function addCrate(model)
		if not model:IsA('Model') then
			return
		end
		-- the real component only mounts once its crateId attribute validates
		if model:GetAttribute('crateId') == nil then
			return
		end
		local altarId = model:GetAttribute('altarId')
		if altarId == nil then
			return
		end
		-- normalize numeric-string altar ids to numbers so ActiveCrates[1] (number)
		-- lookups from modules like AutoGamble match the attribute key
		if type(altarId) == 'string' then
			local num = tonumber(altarId)
			if num then
				altarId = num
			end
		end

		local list = controller.activeCrates[altarId]
		if not list then
			list = {}
			controller.activeCrates[altarId] = list
		end
		table.insert(list, { instance = model, attributes = model:GetAttributes() })
	end

	local function removeCrate(model)
		for altarId, list in controller.activeCrates do
			for i = #list, 1, -1 do
				if list[i].instance == model then
					table.remove(list, i)
				end
			end
			if #list == 0 then
				controller.activeCrates[altarId] = nil
			end
		end
	end

	for _, model in collectionService:GetTagged('InitializedCrateAltar') do
		addAltar(model)
	end
	for _, model in collectionService:GetTagged('RewardCrate') do
		addCrate(model)
	end

	-- flamework only mounts a component once its attribute guards pass, and attribute
	-- replication can trail the tag by a frame, so signal-added components re-check deferred
	vape:Clean(collectionService:GetInstanceAddedSignal('InitializedCrateAltar'):Connect(function(model)
		task.defer(addAltar, model)
	end))
	vape:Clean(collectionService:GetInstanceAddedSignal('RewardCrate'):Connect(function(model)
		task.defer(addCrate, model)
	end))
	vape:Clean(collectionService:GetInstanceRemovedSignal('RewardCrate'):Connect(removeCrate))
end
trackCrateAltars()

local crateAltarDeactivated = netManaged:FindFirstChild('RewardCrate/CrateAltarDeactivated')
if crateAltarDeactivated then
	vape:Clean(crateAltarDeactivated.OnClientEvent:Connect(function(data)
		local altarId = data and data.altarId
		if type(altarId) == 'string' then
			local num = tonumber(altarId)
			if num then
				altarId = num
			end
		end
		bedwars.CrateAltarController.activeCrates[altarId] = nil
	end))
end

vape:Clean(function()
	table.clear(bedwars)
end)

return { loaded = true }