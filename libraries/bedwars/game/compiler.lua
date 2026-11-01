--[[/

	construct.json compiler

	- gets all the bedwars meta sections from the live client
	- writes them to a construct.json file in the executor workspace

	Note: This code has been fully made with AI, take with caution.

]]

-- Compiles the bedwars meta sections from the live client into a construct.json
-- Load this in a bedwars match on any executor with require + writefile, it writes
-- 'construct.json' to the executor workspace.

local replicatedStorage = game:GetService('ReplicatedStorage')
local httpService = game:GetService('HttpService')

local TS = replicatedStorage.TS

local function gameCore()
	return replicatedStorage['rbxts_include']['node_modules']['@easy-games']['game-core'].out
end

local function countTable(tab)
	local count = 0
	for _ in tab do
		count += 1
	end
	return count
end

-- scans upvalues of a function for a table the predicate accepts, walking through
-- nested function upvalues so it survives game-core updates reordering the closure
local function scanUpvalues(fn, predicate, depth)
	depth = depth or 0
	if depth > 3 then return nil end
	for i = 1, 12 do
		local suc, first, second = pcall(debug.getupvalue, fn, i)
		if not suc then break end
		-- executors disagree on whether the name or the value comes back first
		local value = typeof(first) == 'string' and second or first
		if value == nil then break end
		if typeof(value) == 'function' then
			local found = scanUpvalues(value, predicate, depth + 1)
			if found then return found end
		elseif typeof(value) == 'table' and predicate(value) then
			return value
		end
	end
end

local function isShopItems(tab)
	if countTable(tab) < 50 then return false end
	local first
	for _, v in tab do
		first = v
		break
	end
	return typeof(first) == 'table' and first.itemType ~= nil and first.price ~= nil
end

local sections = {}
local failures = {}

local function gather(name, func)
	local suc, res = pcall(func)
	if not suc then
		table.insert(failures, name..': '..tostring(res))
		return
	end
	if res == nil then
		table.insert(failures, name..': returned nil')
		return
	end
	sections[name] = res
end

gather('ShopItems', function()
	-- getShopItem closes over the item list, grab it without touching the shop UI
	local bedwarsShop = require(TS.games.bedwars.shop['bedwars-shop']).BedwarsShop
	local items = scanUpvalues(bedwarsShop.getShopItem, isShopItems)
	assert(items, 'could not locate the shop item list in getShopItem upvalues')
	return items
end)
gather('CombatConstant', function()
	return require(TS.combat['combat-constant']).CombatConstant
end)
gather('WinEffectMeta', function()
	return require(TS.locker['win-effect']['win-effect-meta']).WinEffectMeta
end)
gather('EmoteType', function()
	return require(TS.locker.emote['emote-type']).EmoteType
end)
gather('SoundList', function()
	return require(TS.sound['game-sound']).GameSound
end)
gather('KillEffectMeta', function()
	return require(TS.locker['kill-effect']['kill-effect-meta']).KillEffectMeta
end)
gather('TeamUpgradeMeta', function()
	local func = require(TS.games.bedwars['team-upgrade']['team-upgrade-meta']).getTeamUpgradeMetaForQueue
	local meta = scanUpvalues(func, function(tab)
		return tab.DAMAGE ~= nil and tab.ARMOR ~= nil
	end)
	assert(meta, 'could not locate the team upgrade meta in getTeamUpgradeMetaForQueue upvalues')
	return meta
end)
gather('UILayers', function()
	return require(gameCore()).UILayers
end)
gather('BedwarsKitMeta', function()
	return require(TS.games.bedwars.kit['bedwars-kit-meta']).BedwarsKitMeta
end)
gather('AnimationType', function()
	return require(TS.animation['animation-type']).AnimationType
end)
gather('ItemMeta', function()
	local meta = scanUpvalues(require(TS.item['item-meta']).getItemMeta, function(tab)
		return countTable(tab) > 100
	end)
	assert(meta, 'could not locate the item meta in getItemMeta upvalues')
	return meta
end)
gather('QueueMeta', function()
	return require(TS.game['queue-meta']).QueueMeta
end)
gather('BedBreakEffectMeta', function()
	return require(TS.locker['bed-break-effect']['bed-break-effect-meta']).BedBreakEffectMeta
end)
gather('ProjectileMeta', function()
	return require(TS.projectile['projectile-meta']).ProjectileMeta
end)
gather('ProdAnimations', function()
	return require(TS.animation.definitions['prod-animations']).ProdAnimations
end)
gather('CrosshairImage', function()
	return require(TS.asphalt.generated.images).ui.hud.viewmodel_crosshair
end)
gather('AppLayers', function()
	local appController = require(gameCore().client.controllers['app-controller']).AppController
	local layers = {}
	for appId, app in appController.registeredApps do
		if app.layer ~= nil then
			layers[appId] = app.layer
		end
	end
	return layers
end)
gather('GameSoundMeta', function()
	return require(TS.sound['game-sound-meta']).GameSoundMeta
end)
-- sanitizer tokens, construct.json keeps NumberRange as null and drops every other
-- userdata/function, so the tree is normalized before encoding
local DROP = {__drop = true}
local NULL = {__null = true}

local function sanitize(value)
	local valueType = typeof(value)
	if valueType == 'function' then
		return DROP
	elseif valueType == 'Color3' then
		local suc, hex = pcall(function()
			return value:ToHex()
		end)
		return suc and typeof(hex) == 'string' and '#'..string.lower(hex) or DROP
	elseif valueType == 'EnumItem' then
		return value.Name
	elseif valueType == 'NumberRange' then
		return NULL
	elseif valueType ~= 'table' then
		-- strings/numbers/booleans encode directly, Vector3/CFrame and
		-- everything else userdata is unencodable and gets dropped
		if valueType == 'string' or valueType == 'number' or valueType == 'boolean' then
			return value
		end
		return DROP
	end

	local intKeys = {}
	local minKey, maxKey = math.huge, -math.huge
	local total = 0
	local intOnly = true
	for key in value do
		total += 1
		if typeof(key) == 'number' and key % 1 == 0 then
			table.insert(intKeys, key)
			minKey = math.min(minKey, key)
			maxKey = math.max(maxKey, key)
		else
			intOnly = false
		end
	end

	-- contiguous integer keys starting at 0 or 1 encode as a JSON array in key
	-- order, ProdAnimations is 0 based in game and the json array shifts it +1
	if intOnly and total > 0 and maxKey - minKey + 1 == total and (minKey == 0 or minKey == 1) then
		table.sort(intKeys)
		local items = {}
		for _, key in intKeys do
			local sanitized = sanitize(value[key])
			-- null instead of dropping, removing an element would shift every index after it
			table.insert(items, sanitized == DROP and NULL or sanitized)
		end
		if #items == 0 then return DROP end
		return {kind = 'array', items = items}
	end

	local entries = {}
	for key, member in value do
		local sanitized
		if key == 'projectileType' and typeof(member) == 'function' then
			-- projectile sources close over their projectile fn, the map of
			-- ammo type to projectile type is what construct.json carries
			local ammoTypes = {}
			if typeof(value.ammoItemTypes) == 'table' then
				for _, ammo in value.ammoItemTypes do
					table.insert(ammoTypes, ammo)
				end
			end
			table.insert(ammoTypes, 'arrow')
			local map = {}
			for _, ammo in ammoTypes do
				local suc, res = pcall(member, value, ammo)
				if not suc or typeof(res) ~= 'string' then
					suc, res = pcall(member, ammo)
				end
				map[ammo] = suc and typeof(res) == 'string' and res or ammo
			end
			sanitized = sanitize(map)
			key = 'projectileTypeMap'
		else
			sanitized = sanitize(member)
		end
		if sanitized ~= DROP then
			table.insert(entries, {key = tostring(key), value = sanitized})
		end
	end
	if #entries == 0 then return DROP end
	table.sort(entries, function(a, b)
		return a.key < b.key
	end)
	return {kind = 'object', entries = entries}
end
-- pretty printer matching construct.json's layout, 4 space indent and CRLF lines
local INDENT = '    '

local ESCAPE_MAP = {
	['"'] = '\\"',
	['\\'] = '\\\\',
	['\n'] = '\\n',
	['\r'] = '\\r',
	['\t'] = '\\t',
	['\b'] = '\\b',
	['\f'] = '\\f'
}

local function encodeString(str)
	local escaped = str:gsub('[%c"\\]', function(char)
		return ESCAPE_MAP[char] or string.format('\\u%04x', string.byte(char))
	end)
	return '"'..escaped..'"'
end

local function encodeNumber(num)
	if num ~= num or num == math.huge or num == -math.huge then
		return 'null'
	end
	if num % 1 == 0 and math.abs(num) < 2^53 then
		return string.format('%.0f', num)
	end
	-- tostring prints %.14g which flattens 12.600000000000001 to 12.6, walk
	-- precision until the text decodes back to the exact same double
	for precision = 14, 17 do
		local text = string.format('%.'..precision..'g', num)
		if tonumber(text) == num then
			return text
		end
	end
	return string.format('%.17g', num)
end

local function encodeValue(value, depth)
	local valueType = typeof(value)
	if value == NULL then
		return 'null'
	elseif valueType == 'string' then
		return encodeString(value)
	elseif valueType == 'number' then
		return encodeNumber(value)
	elseif valueType == 'boolean' then
		return value and 'true' or 'false'
	end

	local pad = string.rep(INDENT, depth)
	local innerPad = string.rep(INDENT, depth + 1)
	local parts = {}
	if value.kind == 'array' then
		for _, item in value.items do
			table.insert(parts, innerPad..encodeValue(item, depth + 1))
		end
		if #parts == 0 then return '[]' end
		return '[\r\n'..table.concat(parts, ',\r\n')..'\r\n'..pad..']'
	end
	for _, entry in value.entries do
		table.insert(parts, innerPad..encodeString(entry.key)..': '..encodeValue(entry.value, depth + 1))
	end
	if #parts == 0 then return '{}' end
	return '{\r\n'..table.concat(parts, ',\r\n')..'\r\n'..pad..'}'
end

-- top level order matches the existing construct.json so diffs stay readable
local ORDER = {
	'ShopItems', 'CombatConstant', 'WinEffectMeta', 'EmoteType', 'SoundList',
	'KillEffectMeta', 'TeamUpgradeMeta', 'UILayers', 'BedwarsKitMeta', 'AnimationType',
	'ItemMeta', 'QueueMeta', 'BedBreakEffectMeta', 'ProjectileMeta', 'ProdAnimations',
	'CrosshairImage', 'AppLayers', 'GameSoundMeta'
}

if #failures > 0 then
	warn('[compiler] failed to gather sections:')
	for _, failure in failures do
		warn('  '..failure)
	end
	error('[compiler] missing '..#failures..' sections, nothing written')
end

local lines = {'{'}
for i, name in ORDER do
	local encoded = sanitize(sections[name])
	assert(encoded ~= DROP, '[compiler] section '..name..' has no encodable values')
	local comma = i < #ORDER and ',' or ''
	table.insert(lines, INDENT..encodeString(name)..': '..encodeValue(encoded, 1)..comma)
end
table.insert(lines, '}')
local result = table.concat(lines, '\r\n')..'\r\n'

-- round trip check before touching disk
local decoded = httpService:JSONDecode(result)
for _, name in ORDER do
	if decoded[name] == nil then
		error('[compiler] round trip lost section '..name)
	end
end

writefile('construct.json', result)
print(string.format('[compiler] wrote construct.json (%d bytes)', #result))
for _, name in ORDER do
	local section = sections[name]
	print(string.format('  %s: %s', name, typeof(section) == 'table' and countTable(section) or 'scalar'))
end
