--[[

    comboss 764.
    construct.json is automatically generated with the help of tel aviv.

    Note: This code has been altered with AI, take with caution.

]]

local cloneref = cloneref or function(obj)
    return obj
end

local playersService = cloneref(game:GetService('Players'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local runService = cloneref(game:GetService('RunService'))
local inputService = cloneref(game:GetService('UserInputService'))
local tweenService = cloneref(game:GetService('TweenService'))
local httpService = cloneref(game:GetService('HttpService'))
local textChatService = cloneref(game:GetService('TextChatService'))
local collectionService = cloneref(game:GetService('CollectionService'))
local contextActionService = cloneref(game:GetService('ContextActionService'))
local guiService = cloneref(game:GetService('GuiService'))
local coreGui = cloneref(game:GetService('CoreGui'))
local starterGui = cloneref(game:GetService('StarterGui'))
local debris = cloneref(game:GetService('Debris'))

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
    local suc, res = pcall(func)
    
    if not suc then
        notif('Vape', 'Module failed to load: '..tostring(res), 60, 'alert')
        return
    end

    return res
end

local function ceCheck()
    if not (require or debug.getupvalue or debug.getupvalues or debug.getconstants or debug.getconstant or debug.getproto or debug.getprotos or debug.setconstant) then
        return true
    end

    local exec = string.lower(getexecutorname()) or 'none'
    if table.find({'xeno', 'solara', 'none'}, exec) then
        return true
    end
	
	local request = http and http.request or http_request or request or httprequest
	local req = request({
		Url = 'https://mockhttp.org/get',
		Method = 'GET',
		Headers = {
			['Content-Type'] = 'application/json'
		}
	})

	if req.Success then
		local data = httpService:JSONDecode(req.Body)

		for i,v in data.headers do
			if string.find(i, 'xeno') then
				return true
			end
		end
	end

	local suc, res = pcall(function()
		return require(lplr.PlayerScripts.PlayerModule).controls
	end)

	if not suc or not res or type(res) ~= 'table' then
		return true
	end

	return false
end

local ce, remoteNames = ceCheck(), {
    AfkStatus = 'AfkInfo',
    AttackEntity = 'SwordHit',
    BeePickup = 'PickUpBee',
    CannonAim = 'AimCannon',
    CannonLaunch = 'LaunchSelfFromCannon',
    ConsumeBattery = 'ConsumeBattery',
    ConsumeItem = 'ConsumeItem',
    ConsumeSoul = 'ConsumeGrimReaperSoul',
    ConsumeTreeOrb = 'ConsumeTreeOrb',
    DepositPinata = 'DepositCoins',
    DragonBreath = 'DragonBreath',
    DragonEndFly = 'VoidDragonEndFlying',
    DragonFly = 'DragonFlap',
    DropItem = 'DropItem',
    EquipItem = 'SetInvItem',
    FireProjectile = 'ProjectileFire',
    GroundHit = 'GroundHit',
    GuitarHeal = 'PlayGuitar',
    HannahKill = 'HannahPromptTrigger',
    HarvestCrop = 'CropHarvest',
    KaliyahPunch = 'RequestDragonPunch',
    MageSelect = 'LearnElementTome',
    MinerDig = 'DestroyPetrifiedPlayer',
    PickupItem = 'PickupItemDrop',
    PickupMetal = 'CollectCollectableEntity',
    ReportPlayer = 'ReportPlayer',
    ResetCharacter = 'ResetCharacter',
    SpawnRaven = 'SpawnRaven',
    SummonerClawAttack = 'SummonerClawAttackRequest',
    WarlockTarget = 'WarlockLinkTarget'
}

for i, v in remoteNames do
    remotes[i] = v
end

getgenv().ce = ce
if not ce then
    run(function()
        local KnitInit, Knit
        repeat
            KnitInit, Knit = pcall(function()
                return debug.getupvalue(require(lplr.PlayerScripts.TS.knit).setup, 9)
            end)
            if KnitInit then break end
            task.wait()
        until KnitInit

        if not debug.getupvalue(Knit.Start, 1) then
            repeat task.wait() until debug.getupvalue(Knit.Start, 1)
        end

        local Flamework = require(replicatedStorage['rbxts_include']['node_modules']['@flamework'].core.out).Flamework
        local InventoryUtil = require(replicatedStorage.TS.inventory['inventory-util']).InventoryUtil
        local Client = require(replicatedStorage.TS.remotes).default.Client
        local OldGet, OldBreak = Client.Get

        bedwars = setmetatable({
            AbilityController = Flamework.resolveDependency('@easy-games/game-core:client/controllers/ability/ability-controller@AbilityController'),
            AnimationType = require(replicatedStorage.TS.animation['animation-type']).AnimationType,
            AnimationUtil = require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['game-core'].out['shared'].util['animation-util']).AnimationUtil,
            AppController = require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['game-core'].out.client.controllers['app-controller']).AppController,
            BedBreakEffectMeta = require(replicatedStorage.TS.locker['bed-break-effect']['bed-break-effect-meta']).BedBreakEffectMeta,
            BedwarsKitMeta = require(replicatedStorage.TS.games.bedwars.kit['bedwars-kit-meta']).BedwarsKitMeta,
            BlockBreaker = Knit.Controllers.BlockBreakController.blockBreaker,
            BlockController = require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['block-engine'].out).BlockEngine,
            BlockEngine = require(lplr.PlayerScripts.TS.lib['block-engine']['client-block-engine']).ClientBlockEngine,
            BlockPlacer = require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['block-engine'].out.client.placement['block-placer']).BlockPlacer,
            BowConstantsTable = debug.getupvalue(Knit.Controllers.ProjectileController.enableBeam, 5),
            ClickHold = require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['game-core'].out.client.ui.lib.util['click-hold']).ClickHold,
            Client = Client,
            ClientConstructor = require(replicatedStorage['rbxts_include']['node_modules']['@rbxts'].net.out.client),
            ClientDamageBlock = require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['block-engine'].out.shared.remotes).BlockEngineRemotes.Client,
            CombatConstant = require(replicatedStorage.TS.combat['combat-constant']).CombatConstant,
            DamageIndicator = Knit.Controllers.DamageIndicatorController.spawnDamageIndicator,
            DefaultKillEffect = require(lplr.PlayerScripts.TS.controllers.global.locker['kill-effect'].effects['default-kill-effect']),
            EmoteType = require(replicatedStorage.TS.locker.emote['emote-type']).EmoteType,
            GameAnimationUtil = require(replicatedStorage.TS.animation['animation-util']).GameAnimationUtil,
            getIcon = function(item, showinv)
                local itemmeta = bedwars.ItemMeta[item.itemType]
                return itemmeta and showinv and itemmeta.image or ''
            end,
            getInventory = function(plr)
                local suc, res = pcall(function()
                    return InventoryUtil.getInventory(plr)
                end)
                return suc and res or {
                    items = {},
                    armor = {}
                }
            end,
            HudAliveCount = require(lplr.PlayerScripts.TS.controllers.global['top-bar'].ui.game['hud-alive-player-counts']).HudAlivePlayerCounts,
            ItemMeta = debug.getupvalue(require(replicatedStorage.TS.item['item-meta']).getItemMeta, 1),
            KillEffectMeta = require(replicatedStorage.TS.locker['kill-effect']['kill-effect-meta']).KillEffectMeta,
            KillFeedController = Flamework.resolveDependency('client/controllers/game/kill-feed/kill-feed-controller@KillFeedController'),
            Knit = Knit,
            KnockbackUtil = require(replicatedStorage.TS.damage['knockback-util']).KnockbackUtil,
            MageKitUtil = require(replicatedStorage.TS.games.bedwars.kit.kits.mage['mage-kit-util']).MageKitUtil,
            NametagController = Knit.Controllers.NametagController,
            PartyController = Flamework.resolveDependency('@easy-games/lobby:client/controllers/party-controller@PartyController'),
            ProjectileMeta = require(replicatedStorage.TS.projectile['projectile-meta']).ProjectileMeta,
            QueryUtil = require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['game-core'].out).GameQueryUtil,
            QueueCard = require(lplr.PlayerScripts.TS.controllers.global.queue.ui['queue-card']).QueueCard,
            QueueMeta = require(replicatedStorage.TS.game['queue-meta']).QueueMeta,
            Roact = require(replicatedStorage['rbxts_include']['node_modules']['@rbxts']['roact'].src),
            RuntimeLib = require(replicatedStorage['rbxts_include'].RuntimeLib),
            SoundList = require(replicatedStorage.TS.sound['game-sound']).GameSound,
            SoundManager = require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['game-core'].out).AudioManager,
            Store = require(lplr.PlayerScripts.TS.ui.store).ClientStore,
            TeamUpgradeMeta = debug.getupvalue(require(replicatedStorage.TS.games.bedwars['team-upgrade']['team-upgrade-meta']).getTeamUpgradeMetaForQueue, 6),
            UILayers = require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['game-core'].out).UILayers,
            VisualizerUtils = require(lplr.PlayerScripts.TS.lib.visualizer['visualizer-utils']).VisualizerUtils,
            WeldTable = require(replicatedStorage.TS.util['weld-util']).WeldUtil,
            WinEffectMeta = require(replicatedStorage.TS.locker['win-effect']['win-effect-meta']).WinEffectMeta,
            ZapNetworking = require(lplr.PlayerScripts.TS.lib.network)
        }, {
            __index = function(self, ind)
                print(ind)
                rawset(self, ind, Knit.Controllers[ind])
                return rawget(self, ind)
            end
        })

        OldBreak = bedwars.BlockController.isBlockBreakable
        Client.Get = function(self, remoteName)
            local call = OldGet(self, remoteName)

            if remoteName == remotes.AttackEntity then
                return {
                    instance = call.instance,
                    SendToServer = function(_, attackTable, ...)
                        local suc, plr = pcall(function()
                            return playersService:GetPlayerFromCharacter(attackTable.entityInstance)
                        end)

                        local selfpos = attackTable.validate.selfPosition.value
                        local targetpos = attackTable.validate.targetPosition.value
                        store.attackReach = ((selfpos - targetpos).Magnitude * 100) // 1 / 100
                        store.attackReachUpdate = tick() + 1

                        if Reach.Enabled or HitBoxes.Enabled then
                            attackTable.validate.raycast = attackTable.validate.raycast or {}
                            attackTable.validate.selfPosition.value += CFrame.lookAt(selfpos, targetpos).LookVector * math.max((selfpos - targetpos).Magnitude - 14.399, 0)
                        end

                        if suc and plr then
                            if not select(2, whitelist:get(plr)) then return end
                        end

                        return call:SendToServer(attackTable, ...)
                    end
                }
            elseif remoteName == 'StepOnSnapTrap' and TrapDisabler.Enabled then
                return {SendToServer = function() end}
            end

            return call
        end

        bedwars.SoundManager.playSound = function(self, ...)
            return self:playAudio(...)
        end

        bedwars.BlockController.isBlockBreakable = function(self, breakTable, plr)
            local obj = bedwars.BlockController:getStore():getBlockAt(breakTable.blockPosition)

            if obj and obj.Name == 'bed' then
                for _, plr in playersService:GetPlayers() do
                    if obj:GetAttribute('Team'..(plr:GetAttribute('Team') or 0)..'NoBreak') and not select(2, whitelist:get(plr)) then
                        return false
                    end
                end
            end

            return OldBreak(self, breakTable, plr)
        end

        local cache, blockhealthbar = {}, {blockHealth = -1, breakingBlockPosition = Vector3.zero}
        store.blockPlacer = bedwars.BlockPlacer.new(bedwars.BlockEngine, 'wool_white')

        local function getBlockHealth(block, blockpos)
            local blockdata = bedwars.BlockController:getStore():getBlockData(blockpos)
            return (blockdata and (blockdata:GetAttribute('1') or blockdata:GetAttribute('Health')) or block:GetAttribute('Health'))
        end

        local function getBlockHits(block, blockpos)
            if not block then return 0 end
            local breaktype = bedwars.ItemMeta[block.Name].block.breakType
            local tool = store.tools[breaktype]
            tool = tool and bedwars.ItemMeta[tool.itemType].breakBlock[breaktype] or 2
            return getBlockHealth(block, bedwars.BlockController:getBlockPosition(blockpos)) / tool
        end

        --[[
            Pathfinding using a luau version of dijkstra's algorithm
            Source: https://stackoverflow.com/questions/39355587/speeding-up-dijkstras-algorithm-to-solve-a-3d-maze
        ]]
        
        local function calculatePath(target, blockpos)
            if cache[blockpos] then
                return unpack(cache[blockpos])
            end
            local visited, unvisited, distances, air, path = {}, {{0, blockpos}}, {[blockpos] = 0}, {}, {}

            for _ = 1, 10000 do
                local _, node = next(unvisited)
                if not node then break end
                table.remove(unvisited, 1)
                visited[node[2]] = true

                for _, side in sides do
                    side = node[2] + side
                    if visited[side] then continue end

                    local block = getPlacedBlock(side)
                    if not block or block:GetAttribute('NoBreak') or block == target then
                        if not block then
                            air[node[2]] = true
                        end
                        continue
                    end

                    local curdist = getBlockHits(block, side) + node[1]
                    if curdist < (distances[side] or math.huge) then
                        table.insert(unvisited, {curdist, side})
                        distances[side] = curdist
                        path[side] = node[2]
                    end
                end
            end

            local pos, cost = nil, math.huge
            for node in air do
                if distances[node] < cost then
                    pos, cost = node, distances[node]
                end
            end

            if pos then
                cache[blockpos] = {
                    pos,
                    cost,
                    path
                }
                return pos, cost, path
            end
        end

        bedwars.placeBlock = function(pos, item)
            if getItem(item) then
                store.blockPlacer.blockType = item
                return store.blockPlacer:placeBlock(bedwars.BlockController:getBlockPosition(pos))
            end
        end

        bedwars.breakBlock = function(block, effects, anim, customHealthbar)
            if lplr:GetAttribute('DenyBlockBreak') or not entitylib.isAlive or InfiniteFly.Enabled then return end
            local handler = bedwars.BlockController:getHandlerRegistry():getHandler(block.Name)
            local cost, pos, target, path = math.huge

            for _, v in (handler and handler:getContainedPositions(block) or {block.Position / 3}) do
                local dpos, dcost, dpath = calculatePath(block, v * 3)
                if dpos and dcost < cost then
                    cost, pos, target, path = dcost, dpos, v * 3, dpath
                end
            end

            if pos then
                if (entitylib.character.RootPart.Position - pos).Magnitude > 30 then return end
                local dblock, dpos = getPlacedBlock(pos)
                if not dblock then return end

                if (workspace:GetServerTimeNow() - bedwars.SwordController.lastAttack) > 0.4 then
                    local breaktype = bedwars.ItemMeta[dblock.Name].block.breakType
                    local tool = store.tools[breaktype]
                    if tool then
                        switchItem(tool.tool)
                    end
                end

                if blockhealthbar.blockHealth == -1 or dpos ~= blockhealthbar.breakingBlockPosition then
                    blockhealthbar.blockHealth = getBlockHealth(dblock, dpos)
                    blockhealthbar.breakingBlockPosition = dpos
                end

                bedwars.ClientDamageBlock:Get('DamageBlock'):CallServerAsync({
                    blockRef = {blockPosition = dpos},
                    hitPosition = pos,
                    hitNormal = Vector3.FromNormalId(Enum.NormalId.Top)
                }):andThen(function(result)
                    if result then
                        if result == 'cancelled' then
                            store.damageBlockFail = tick() + 1
                            return
                        end

                        if effects then
                            local blockdmg = (blockhealthbar.blockHealth - (result == 'destroyed' and 0 or getBlockHealth(dblock, dpos)))
                            customHealthbar = customHealthbar or bedwars.BlockBreaker.updateHealthbar
                            customHealthbar(bedwars.BlockBreaker, {blockPosition = dpos}, blockhealthbar.blockHealth, dblock:GetAttribute('MaxHealth'), blockdmg, dblock)
                            blockhealthbar.blockHealth = math.max(blockhealthbar.blockHealth - blockdmg, 0)

                            if blockhealthbar.blockHealth <= 0 then
                                bedwars.BlockBreaker.breakEffect:playBreak(dblock.Name, dpos, lplr)
                                bedwars.BlockBreaker.healthbarMaid:DoCleaning()
                                blockhealthbar.breakingBlockPosition = Vector3.zero
                            else
                                bedwars.BlockBreaker.breakEffect:playHit(dblock.Name, dpos, lplr)
                            end
                        end

                        if anim then
                            local animation = bedwars.AnimationUtil:playAnimation(lplr, bedwars.BlockController:getAnimationController():getAssetId(1))
                            bedwars.ViewmodelController:playAnimation(15)
                            task.wait(0.3)
                            animation:Stop()
                            animation:Destroy()
                        end
                    end
                end)

                if effects then
                    return pos, path, target
                end
            end
        end

        for _, v in Enum.NormalId:GetEnumItems() do
            table.insert(sides, Vector3.FromNormalId(v) * 3)
        end

        local function updateStore(new, old)
            if new.Bedwars ~= old.Bedwars then
                store.equippedKit = new.Bedwars.kit ~= 'none' and new.Bedwars.kit or ''
            end

            if new.Game ~= old.Game then
                store.matchState = new.Game.matchState
                store.queueType = new.Game.queueType or 'bedwars_test'
            end

            if new.Inventory ~= old.Inventory then
                local newinv = (new.Inventory and new.Inventory.observedInventory or {inventory = {}})
                local oldinv = (old.Inventory and old.Inventory.observedInventory or {inventory = {}})
                store.inventory = newinv

                if newinv ~= oldinv then
                    vapeEvents.InventoryChanged:Fire()
                end

                if newinv.inventory.items ~= oldinv.inventory.items then
                    vapeEvents.InventoryAmountChanged:Fire()
                    store.tools.sword = getSword()
                    for _, v in {'stone', 'wood', 'wool'} do
                        store.tools[v] = getTool(v)
                    end
                end

                if newinv.inventory.hand ~= oldinv.inventory.hand then
                    local currentHand, toolType = new.Inventory.observedInventory.inventory.hand, ''
                    if currentHand then
                        local handData = bedwars.ItemMeta[currentHand.itemType]
                        toolType = handData.sword and 'sword' or handData.block and 'block' or currentHand.itemType:find('bow') and 'bow'
                    end

                    store.hand = {
                        tool = currentHand and currentHand.tool,
                        amount = currentHand and currentHand.amount or 0,
                        toolType = toolType
                    }
                end
            end
        end

        local storeChanged = bedwars.Store.changed:connect(updateStore)
        updateStore(bedwars.Store:getState(), {})

        for _, event in {'MatchEndEvent', 'EntityDeathEvent', 'BedwarsBedBreak', 'BalloonPopped', 'AngelProgress', 'GrapplingHookFunctions'} do
            if not vape.Connections then return end
            bedwars.Client:WaitFor(event):andThen(function(connection)
                vape:Clean(connection:Connect(function(...)
                    vapeEvents[event]:Fire(...)
                end))
            end)
        end

        vape:Clean(bedwars.ZapNetworking.EntityDamageEventZap.On(function(...)
            vapeEvents.EntityDamageEvent:Fire({
                entityInstance = ...,
                damage = select(2, ...),
                damageType = select(3, ...),
                fromPosition = select(4, ...),
                fromEntity = select(5, ...),
                knockbackMultiplier = select(6, ...),
                knockbackId = select(7, ...),
                disableDamageHighlight = select(13, ...)
            })
        end))

        for _, event in {'PlaceBlockEvent', 'BreakBlockEvent'} do
            vape:Clean(bedwars.ZapNetworking[event..'Zap'].On(function(...)
                local data = {
                    blockRef = {
                        blockPosition = ...,
                    },
                    player = select(5, ...)
                }
                for i, v in cache do
                    if ((data.blockRef.blockPosition * 3) - v[1]).Magnitude <= 30 then
                        table.clear(v[3])
                        table.clear(v)
                        cache[i] = nil
                    end
                end
                vapeEvents[event]:Fire(data)
            end))
        end

        store.blocks = collection('block', gui)
        store.shop = collection({'BedwarsItemShop', 'TeamUpgradeShopkeeper'}, gui, function(tab, obj)
            table.insert(tab, {
                Id = obj.Name,
                RootPart = obj,
                Shop = obj:HasTag('BedwarsItemShop'),
                Upgrades = obj:HasTag('TeamUpgradeShopkeeper')
            })
        end)
        store.enchant = collection({'enchant-table', 'broken-enchant-table'}, gui, nil, function(tab, obj, tag)
            if obj:HasTag('enchant-table') and tag == 'broken-enchant-table' then return end
            obj = table.find(tab, obj)
            if obj then
                table.remove(tab, obj)
            end
        end)

        local kills = sessioninfo:AddItem('Kills')
        local beds = sessioninfo:AddItem('Beds')
        local wins = sessioninfo:AddItem('Wins')
        local games = sessioninfo:AddItem('Games')

        local mapname = 'Unknown'
        sessioninfo:AddItem('Map', 0, function()
            return mapname
        end, false)

        task.delay(1, function()
            games:Increment()
        end)

        task.spawn(function()
            pcall(function()
                repeat task.wait() until store.matchState ~= 0 or vape.Loaded == nil
                if vape.Loaded == nil then return end
                mapname = workspace:WaitForChild('Map', 5):WaitForChild('Worlds', 5):GetChildren()[1].Name
                mapname = string.gsub(string.split(mapname, '_')[2] or mapname, '-', '') or 'Blank'
            end)
        end)

        vape:Clean(vapeEvents.BedwarsBedBreak.Event:Connect(function(bedTable)
            if bedTable.player and bedTable.player.UserId == lplr.UserId then
                beds:Increment()
            end
        end))

        vape:Clean(vapeEvents.MatchEndEvent.Event:Connect(function(winTable)
            if (bedwars.Store:getState().Game.myTeam or {}).id == winTable.winningTeamId or lplr.Neutral then
                wins:Increment()
            end
        end))

        vape:Clean(vapeEvents.EntityDeathEvent.Event:Connect(function(deathTable)
            local killer = playersService:GetPlayerFromCharacter(deathTable.fromEntity)
            local killed = playersService:GetPlayerFromCharacter(deathTable.entityInstance)
            if not killed or not killer then return end

            if killed ~= lplr and killer == lplr then
                kills:Increment()
            end
        end))

        task.spawn(function()
            repeat
                if entitylib.isAlive then
                    entitylib.character.AirTime = entitylib.character.Humanoid.FloorMaterial ~= Enum.Material.Air and tick() or entitylib.character.AirTime
                end

                for _, v in entitylib.List do
                    v.LandTick = math.abs(v.RootPart.Velocity.Y) < 0.1 and v.LandTick or tick()
                    if (tick() - v.LandTick) > 0.2 and v.Jumps ~= 0 then
                        v.Jumps = 0
                        v.Jumping = false
                    end
                end
                task.wait()
            until vape.Loaded == nil
        end)

        pcall(function()
            if getthreadidentity and setthreadidentity then
                local old = getthreadidentity()
                setthreadidentity(2)

                bedwars.Shop = require(replicatedStorage.TS.games.bedwars.shop['bedwars-shop']).BedwarsShop
                bedwars.ShopItems = debug.getupvalue(debug.getupvalue(bedwars.Shop.getShopItem, 1), 2)
                bedwars.Shop.getShopItem('iron_sword', lplr)

                setthreadidentity(old)
                store.shopLoaded = true
            else
                task.spawn(function()
                    repeat
                        task.wait(0.1)
                    until vape.Loaded == nil or bedwars.AppController:isAppOpen('BedwarsItemShopApp')

                    bedwars.Shop = require(replicatedStorage.TS.games.bedwars.shop['bedwars-shop']).BedwarsShop
                    bedwars.ShopItems = debug.getupvalue(debug.getupvalue(bedwars.Shop.getShopItem, 1), 2)
                    store.shopLoaded = true
                end)
            end
        end)

        vape:Clean(function()
            Client.Get = OldGet
            bedwars.BlockController.isBlockBreakable = OldBreak
            store.blockPlacer:disable()
            for _, v in vapeEvents do
                v:Destroy()
            end
            for _, v in cache do
                table.clear(v[3])
                table.clear(v)
            end
            table.clear(store.blockPlacer)
            table.clear(vapeEvents)
            table.clear(bedwars)
            table.clear(store)
            table.clear(cache)
            table.clear(sides)
            table.clear(remotes)
            storeChanged:disconnect()
            storeChanged = nil
        end)
    end)

    return {loaded = true}
end

--[[

    Emulation in order

]]

local netManaged = replicatedStorage.rbxts_include.node_modules['@rbxts'].net.out._NetManaged
local blockEngineRemotes = replicatedStorage.rbxts_include.node_modules['@easy-games']['block-engine'].node_modules['@rbxts'].net.out._NetManaged
local inventoriesFolder = replicatedStorage:FindFirstChild('Inventories')

local function newPromise(func, ...)
    local promiseArgs = table.pack(...)
    local promise = {thenFunctions = {}, errFunctions = {}, results = nil, resolved = false, rejected = false}
    local function resolve(...)
        if promise.resolved or promise.rejected then return end
        promise.resolved = true
        promise.results = table.pack(...)
        for _, v in promise.thenFunctions do
            task.spawn(v, ...)
        end
        table.clear(promise.thenFunctions)
        table.clear(promise.errFunctions)
    end
    local function reject(...)
        if promise.resolved or promise.rejected then return end
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
    CallServerAsync = function() return newPromise(function() end) end
}

local function getRemoteData(remote)
    if not remote then return nil end
    return {
        instance = remote,
        SendToServer = function(self, ...)
            return remote:FireServer(...)
        end,
        CallServer = function(self, ...)
            return remote:InvokeServer(...)
        end,
        CallServerAsync = function(self, ...)
            local args = {...}
            return newPromise(function()
                return remote:InvokeServer(table.unpack(args))
            end)
        end
    }
end

local clientCache = {}
bedwars.Client = {
    Get = function(self, remoteName)
        local name = remotes[remoteName] or remoteName
        if not clientCache[name] then
            clientCache[name] = getRemoteData(netManaged:FindFirstChild(name)) or emptyRemote
        end
        return clientCache[name]
    end,
    GetNamespace = function(self, namespace)
        return {
            Get = function(_, remoteName)
                return bedwars.Client:Get(namespace..'/'..remoteName)
            end
        }
    end,
    WaitFor = function(self, remoteName)
        return newPromise(function()
            return netManaged:WaitForChild(remotes[remoteName] or remoteName)
        end)
    end
}

bedwars.ClientDamageBlock = {
    Get = function(_, remoteName)
        return getRemoteData(blockEngineRemotes:FindFirstChild(remoteName)) or emptyRemote
    end
}

local function newMaid()
    local tasks = {}
    return {
        GiveTask = function(self, taskFn)
            table.insert(tasks, taskFn)
        end,
        DoCleaning = function()
            for _, v in tasks do
                task.spawn(v)
            end
            table.clear(tasks)
        end
    }
end

bedwars.RuntimeLib = {
    Promise = {
        defer = function(func)
            return newPromise(func)
        end,
        delay = function(seconds)
            return {
                andThen = function(self, callback)
                    task.delay(seconds, callback)
                    return self
                end
            }
        end
    },
    await = function(promise)
        if promise.resolved then
            return table.unpack(promise.results, 1, promise.results.n)
        end
        local signal = Instance.new('BindableEvent')
        promise:andThen(function(...)
            signal:Fire(table.pack(...))
        end)
        local result = signal.Event:Wait()
        signal:Destroy()
        return table.unpack(result, 1, result.n)
    end
}

local roactRef = {}
local function roactMount(element, parent)
    if type(element) ~= 'table' then return nil end
    local instance = Instance.new(element.kind)
    for key, value in element.props or {} do
        if key == roactRef then
            if type(value) == 'table' and value.SetValue then
                value:SetValue(instance)
            end
        else
            pcall(function()
                instance[key] = value
            end)
        end
    end
    for _, child in element.children or {} do
        local mounted = roactMount(child, nil)
        if mounted then
            mounted.Parent = instance
        end
    end
    if parent then
        instance.Parent = parent
    end
    return instance
end

bedwars.Roact = {
    Ref = roactRef,
    createElement = function(kind, props, children)
        return {kind = kind, props = props, children = children}
    end,
    mount = roactMount,
    unmount = function(mounted)
        if mounted then
            mounted:Destroy()
        end
    end,
    createRef = function()
        local ref = {}
        function ref:SetValue(value)
            self.current = value
        end
        function ref:getValue()
            return self.current
        end
        return ref
    end
}

bedwars.QueryUtil = {
    isQueryIgnored = function(part)
        if not part:IsA('BasePart') then
            return false
        end
        
        return part:GetAttribute('gamecore_GameQueryIgnore') == true
    end,
    setQueryIgnored = function(self, part, tog)
        if not tog then tog = true end
        if not part:IsA('BasePart') then return end

        part:SetAttribute('gamecore_GameQueryIgnore', tog)

        if self.ADJUST_CAN_QUERY then
            a2.CanQuery = tog
        end
    end,
    raycast = function(self, origin: Vector3, direction: Vector3, raycastParams: RaycastParams?, options: table?)
        if debug and debug.profilebegin then
            debug.profilebegin('gq-cast')
        end

        local params, world, ignore = RaycastParams.new(), (options and options.world) or workspace, options and options.ignorePart
        if raycastParams then
            local copy = {}
            for i, v in raycastParams.FilterDescendantsInstances or {} do
                copy[i] = v
            end
            params.FilterDescendantsInstances = copy
            params.FilterType = raycastParams.FilterType
            params.IgnoreWater = raycastParams.IgnoreWater
            params.RespectCanCollide = raycastParams.RespectCanCollide
        end
        local currentFilter, hitRes = params.FilterDescendantsInstances or {}, nil

        repeat
            if hitRes then
                params.FilterDescendantsInstances = currentFilter
            end

            hitRes = world:Raycast(origin, direction, params)
            if hitRes then
                local hitInst = hitRes.Instance

                if not bedwars.QueryUtil.isQueryIgnored(hitInst) then
                    if not ignore or not ignore(hitInst) then
                        break
                    end
                end

                if params.FilterType == Enum.RaycastFilterType.Exclude or params.FilterType == Enum.RaycastFilterType.Blacklist then
                    params:AddToFilter(hitInst)
                else
                    local hitIndex = -1
                    for index, instance in ipairs(currentFilter) do
                        if hitInst == instance or hitInst:IsDescendantOf(instance) then
                            hitIndex = index
                            break
                        end
                    end

                    if hitIndex ~= -1 then
                        table.remove(currentFilter, hitIndex)
                    end
                end
            end
        until hitRes == nil

        if debug and debug.profileend then
            debug.profileend()
        end
        
        return hitRes
    end,
    ADJUST_CAN_QUERY = false
}

bedwars.SoundManager = {
    playAudio = function(_, id, options)
        if typeof(id) ~= 'string' then return end
        local sound = Instance.new('Sound')
        sound.SoundId = id
        if options and typeof(options.position) == 'Vector3' then
            local part = Instance.new('Part')
            part.Anchored = true
            part.CanCollide = false
            part.Transparency = 1
            part.Size = Vector3.one
            part.Position = options.position
            part.Parent = workspace
            sound.Parent = part
            debris:AddItem(part, 10)
        else
            sound.Parent = workspace
            debris:AddItem(sound, 10)
        end
        sound:Play()
        return sound
    end,
    playSound = function(self, id, options)
        return self:playAudio(id, options)
    end
}

--[[

    Metadata

]]

local function downloadFile(path, callback)
	if not isfile(path) then
		createDownloader(path)
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

local meta
local suc, res = pcall(function()
    local file = downloadFile('newvape/libraries/bedwars/construct.json')
    return httpService:JSONDecode(file)
end)

if suc and res ~= nil and type(res) == 'table' then
    meta = res
else
    notif('Vape', 'Failed to download construct.json, most features will not work! --> report this error to @.__stav on Discord! (error is in: newvape/error.txt)', 6)
    writefile('newvape/error.txt', debug.traceback(tostring(res)))
    warn(debug.traceback(tostring(res)))

    meta = {}
end

bedwars.ItemMeta = meta.ItemMeta or setmetatable({}, {__index = function() return {} end})
bedwars.ProjectileMeta = meta.ProjectileMeta or {}
bedwars.QueueMeta = meta.QueueMeta or {}
bedwars.BedwarsKitMeta = meta.BedwarsKitMeta or {}
bedwars.KillEffectMeta = meta.KillEffectMeta or {}
bedwars.BedBreakEffectMeta = meta.BedBreakEffectMeta or {}
bedwars.WinEffectMeta = meta.WinEffectMeta or {}
bedwars.TeamUpgradeMeta = meta.TeamUpgradeMeta or {}
bedwars.CombatConstant = meta.CombatConstant or {RAYCAST_SWORD_CHARACTER_DISTANCE = 14.4, REGION_SWORD_CHARACTER_DISTANCE = 12.6}
bedwars.AnimationType = meta.AnimationType or {}
bedwars.EmoteType = meta.EmoteType or {}
bedwars.UILayers = meta.UILayers or {MAIN = 'MAIN', HUD = 'HUD', OVERLAY = 'OVERLAY'}
bedwars.SoundList = meta.SoundList or {}
bedwars.ShopItems = meta.ShopItems or {}
bedwars.ProdAnimations = meta.ProdAnimations or {}
bedwars.CrosshairImage = meta.CrosshairImage or ''
bedwars.AppLayers = meta.AppLayers or {}

for _, item in bedwars.ItemMeta do
    local projectileSource = item.projectileSource
    local typeMap = projectileSource and projectileSource.projectileTypeMap
    if typeMap then
        projectileSource.projectileType = function(ammo)
            return typeMap[ammo] or ammo
        end
    end
end

local function getAnimationAsset(animType)
    return bedwars.ProdAnimations[tonumber(animType) and tonumber(animType) + 1 or nil]
end

bedwars.Shop = {
    getShopItem = function(itemType)
        for _, v in bedwars.ShopItems do
            if v.itemType == itemType then
                return v
            end
        end
    end,
    getTeamWool = function(team)
        local queueMeta = bedwars.QueueMeta[store.queueType]
        local teamData = queueMeta and (queueMeta.teams[tonumber(team) or 1] or queueMeta.teams[(tonumber(team) or 1) + 1])
        local color = teamData and teamData.displayName:split(' ')[1]:lower() or 'white'
        return 'wool_'..color
    end
}

--[[

    Inventory & block state

]]

local function getCharacter(plr)
    if typeof(plr) == 'Instance' and plr:IsA('Player') then
        return plr.Character
    elseif typeof(plr) == 'Instance' and plr:IsA('Model') then
        return plr
    end
    return lplr.Character
end

local function getInventoryFolder(plr)
    local character = getCharacter(plr)
    local folderRef = character and character:FindFirstChild('InventoryFolder')
    local folder = folderRef and folderRef.Value
    if not folder and inventoriesFolder and character then
        folder = inventoriesFolder:FindFirstChild(character.Name)
    end
    return folder
end

local function getItemData(tool)
    return {
        tool = tool,
        itemType = tool.Name,
        amount = tool:GetAttribute('Amount'),
        addedToBackpackTime = tool:GetAttribute('AddedToBackpackTime'),
        itemSkin = tool:GetAttribute('ItemSkin')
    }
end

local function getInventory(plr)
    local inventory = {items = {}, armor = {'empty', 'empty', 'empty'}}
    local character = getCharacter(plr)
    if not character then return inventory end

    local folder = getInventoryFolder(plr)
    if folder then
        for _, v in folder:GetChildren() do
            table.insert(inventory.items, getItemData(v))
        end
    end

    for i = 0, 2 do
        local armorSlot = character:FindFirstChild('ArmorInvItem_'..i)
        if armorSlot and armorSlot.Value then
            inventory.armor[i + 1] = getItemData(armorSlot.Value)
        end
    end

    local backpackSlot = character:FindFirstChild('BedWarsBackpackSlot')
    if backpackSlot and backpackSlot.Value then
        inventory.backpack = getItemData(backpackSlot.Value)
    end

    local hand = character:FindFirstChild('HandInvItem')
    if hand and hand.Value then
        inventory.hand = getItemData(hand.Value)
    end

    return inventory
end

bedwars.getInventory = function(plr)
    local suc, res = pcall(getInventory, plr or lplr)
    return suc and res or {items = {}, armor = {}}
end

bedwars.getIcon = function(item, showinv)
    local itemmeta = bedwars.ItemMeta[item.itemType]
    return itemmeta and showinv and itemmeta.image or ''
end

local function roundBlockPos(pos)
    return Vector3.new(math.round(pos.X / 3) * 3, math.round(pos.Y / 3) * 3, math.round(pos.Z / 3) * 3)
end

local blockIndex, blockIndexTick = {}, 0
local function getBlockIndex()
    if tick() - blockIndexTick > 0.5 then
        table.clear(blockIndex)
        for _, v in collectionService:GetTagged('block') do
            if v.Size == Vector3.one * 3 then
                blockIndex[roundBlockPos(v.Position)] = v
            end
        end
        blockIndexTick = tick()
    end
    return blockIndex
end

local function findBlock(pos)
    if typeof(pos) ~= 'Vector3' then return nil end
    return getBlockIndex()[roundBlockPos(pos)]
end

local blockStore = {
    getBlockAt = function(_, pos)
        return findBlock(pos)
    end,
    getBlockData = function(_, pos)
        return findBlock(pos)
    end,
    getAllBlockPositions = function()
        local positions = {}
        for pos in getBlockIndex() do
            table.insert(positions, pos)
        end
        return positions
    end,
    removeBlockInstance = function() end
}

bedwars.BlockController = {
    getBlockPosition = function(_, pos)
        return roundBlockPos(pos)
    end,
    getWorldPosition = function(_, pos)
        return pos
    end,
    getStore = function()
        return blockStore
    end,
    isBlockBreakable = function()
        return true
    end,
    getAnimationController = function()
        return {
            getAssetId = function()
                return nil
            end
        }
    end,
    getHandlerRegistry = function()
        return {
            getHandler = function()
                return nil
            end
        }
    end,
    calculateBlockDamage = function(_, plr, breakTable)
        local block = findBlock(breakTable.blockPosition)
        if not block then return math.huge end
        local blockmeta = bedwars.ItemMeta[block.Name]
        local breaktype = blockmeta and blockmeta.block and blockmeta.block.breakType
        local tool = breaktype and store.tools[breaktype]
        local toolmeta = tool and bedwars.ItemMeta[tool.itemType]
        return toolmeta and toolmeta.breakBlock and toolmeta.breakBlock[breaktype] or 2
    end
}

local function getAnimator(target)
    if typeof(target) ~= 'Instance' then return nil end
    if target:IsA('Player') then
        local character = target.Character
        local humanoid = character and character:FindFirstChildOfClass('Humanoid')
        return humanoid and humanoid:FindFirstChildOfClass('Animator')
    elseif target:IsA('Model') then
        local humanoid = target:FindFirstChildWhichIsA('Humanoid', true)
        local animator = humanoid and humanoid:FindFirstChildOfClass('Animator')
        if not animator then
            local controller = target:FindFirstChildWhichIsA('AnimationController', true)
            animator = controller and controller:FindFirstChildOfClass('Animator')
        end
        return animator
    elseif target:IsA('Animator') then
        return target
    end
end

bedwars.AnimationUtil = {
    playAnimation = function(_, target, assetId, options)
        local handle = {
            Stop = function() end,
            Destroy = function() end
        }
        if not assetId or assetId == '' then return handle end

        local animator = getAnimator(target)
        if not animator or not animator:IsDescendantOf(game) then return handle end

        local animation = Instance.new('Animation')
        animation.AnimationId = assetId

        local ok, track = pcall(animator.LoadAnimation, animator, animation)
        animation:Destroy()
        if not ok or not track then return handle end

        if options and options.looped ~= nil then
            track.Looped = options.looped
        end
        if options and options.priority then
            track.Priority = options.priority
        end

        local speed = options and tonumber(options.speed) or 1
        local fadeIn = options and tonumber(options.fadeInTime)
        pcall(function()
            track:Play(fadeIn, nil, speed)
        end)

        handle.Stop = function()
            pcall(function()
                track:Stop()
            end)
        end
        handle.Destroy = function()
            pcall(function()
                track:Destroy()
            end)
        end
        handle.GetTrack = function()
            return track
        end
        return handle
    end
}

local function getMouseInfo(_, mode, params)
    local origin, direction
    if params and params.ray then
        origin, direction = params.ray.Origin, params.ray.Direction
    else
        local mouse = inputService:GetMouseLocation()
        local ray, rayDirection = gameCamera:ViewportPointToRay(mouse.X, mouse.Y)
        if typeof(ray) == 'Ray' then
            origin, direction = ray.Origin, ray.Direction
        else
            origin, direction = ray, rayDirection
        end
    end

    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = {lplr.Character}

    local result = bedwars.QueryUtil:raycast(origin, direction * 100, rayParams)
    if not result or not result.Instance or not result.Instance:GetAttribute('Block') then return nil end

    return {
        placementPosition = roundBlockPos(result.Position + result.Normal * 1.5),
        target = {
            blockRef = {blockPosition = roundBlockPos(result.Instance.Position)},
            blockInstance = result.Instance,
            hitPosition = result.Position,
            hitNormal = result.Normal
        }
    }
end

bedwars.BlockBreaker = {
    clientManager = {
        getBlockSelector = function()
            return {
                getMouseInfo = getMouseInfo
            }
        end
    },
    healthbarMaid = newMaid(),
    healthbarProgressRef = bedwars.Roact.createRef(),
    healthbarPart = nil,
    healthbarBlockRef = nil,
    breakEffect = {
        playBreak = function() end,
        playHit = function() end
    },
    setCooldown = function() end,
    hitBlock = function() end,
    updateHealthbar = function() end
}

--[[

    Store

]]

local gameState = {
    Bedwars = {kit = 'none', teamUpgrades = {}},
    Game = {matchState = 0, queueType = 'bedwars_test', myTeam = nil, customMatch = {}},
    Inventory = {observedInventory = {inventory = {items = {}, armor = {}}, hotbar = {}, hotbarSlot = 0}},
    Party = {leader = nil, members = {}, queueState = 'Idle'},
    Settings = {fov = 70}
}

local cachedInventory, inventorySignature = nil, nil

local function refreshInventory()
    local inventory = getInventory(lplr)
    local hotbar = {}
    local signature = {}
    for i, v in inventory.items do
        hotbar[i] = {item = v, slot = i - 1}
        table.insert(signature, v.itemType..':'..tostring(v.amount)..':'..tostring(v.tool))
    end
    for _, v in inventory.armor do
        table.insert(signature, typeof(v) == 'table' and v.itemType or tostring(v))
    end
    table.insert(signature, inventory.hand and inventory.hand.itemType or '')

    local hotbarSlot = 0
    for i, v in inventory.items do
        if inventory.hand and v.tool == inventory.hand.tool then
            hotbarSlot = i - 1
            break
        end
    end
    inventory.hotbar = hotbar
    inventory.hotbarSlot = hotbarSlot

    local str = table.concat(signature, '|')
    if str ~= inventorySignature then
        inventorySignature = str
        cachedInventory = {inventory = inventory, hotbar = hotbar, hotbarSlot = hotbarSlot}
        gameState.Inventory.observedInventory = cachedInventory
    end

    return cachedInventory
end

local updateStore

bedwars.Store = {
    getState = function()
        return gameState
    end,
    dispatch = function(_, action)
        if not action or not action.type then return end

        if action.type == 'InventorySelectHotbarSlot' then
            local entry = gameState.Inventory.observedInventory.hotbar[action.slot + 1]
            if entry and entry.item and lplr.Character then
                local handValue = lplr.Character:FindFirstChild('HandInvItem')
                if handValue then
                    handValue.Value = entry.item.tool
                end
                bedwars.Client:Get(remotes.EquipItem):CallServerAsync({hand = entry.item.tool})
                task.delay(0.1, updateStore)
            end
        elseif action.type == 'InventorySetArmorItem' then
            if action.item and lplr.Character then
                local armorValue = lplr.Character:FindFirstChild('ArmorInvItem_'..tostring(action.armorSlot))
                if armorValue then
                    armorValue.Value = action.item.tool
                end
            end
            task.delay(0.1, updateStore)
        elseif action.type == 'BedwarsAddItemPurchased' then
            bedwars.BedwarsShopController.alreadyPurchasedMap[action.itemType] = true
        end
    end,
    changed = {
        connect = function()
            return {disconnect = function() end}
        end
    }
}

updateStore = function()
    local newinv = refreshInventory()
    local oldinv = store.inventory

    store.equippedKit = gameState.Bedwars.kit ~= 'none' and gameState.Bedwars.kit or ''
    store.matchState = gameState.Game.matchState
    store.queueType = gameState.Game.queueType or 'bedwars_test'
    bedwars.SprintController.sprinting = lplr:GetAttribute('Sprinting') or false

    if newinv == oldinv then return end
    store.inventory = newinv
    vapeEvents.InventoryChanged:Fire()
    vapeEvents.InventoryAmountChanged:Fire()

    store.tools.sword = getSword()
    for _, v in {'stone', 'wood', 'wool'} do
        store.tools[v] = getTool(v)
    end

    local currentHand, toolType = newinv.inventory.hand, ''
    if currentHand then
        local handData = bedwars.ItemMeta[currentHand.itemType]
        if handData and handData.sword then
            toolType = 'sword'
        elseif handData and handData.block then
            toolType = 'block'
        elseif currentHand.itemType:find('bow') then
            toolType = 'bow'
        end
    end

    store.hand = {
        tool = currentHand and currentHand.tool,
        amount = currentHand and currentHand.amount or 0,
        toolType = toolType
    }
end

--[[

    Controllers

]]

local abilityCooldowns = {}
local gameCoreEvents = replicatedStorage:FindFirstChild('events-@easy-games/game-core:shared/game-core-networking@getEvents.Events')

if gameCoreEvents then
    local cooldownRemote = gameCoreEvents:FindFirstChild('abilityCooldownUpdate')
    if cooldownRemote then
        vape:Clean(cooldownRemote.OnClientEvent:Connect(function(abilityId, duration)
            duration = tonumber(duration) or 0
            if duration > 3600 then
                duration = duration / 1000
            end
            duration = math.clamp(duration, 0, 120)
            abilityCooldowns[tostring(abilityId)] = workspace:GetServerTimeNow() + duration
        end))
    end
end

bedwars.AbilityController = {
    enabledAbilities = {},
    blockedAbilities = {},
    abilityProgressValues = {},
    canUseAbility = function(self, abilityId, opts)
        if self.blockedAbilities[abilityId] then return false end
        local enabled = self.enabledAbilities[abilityId]
        if enabled and enabled.abilityState == 'DISABLED' then return false end
        local expires = abilityCooldowns[tostring(abilityId)]
        if expires and workspace:GetServerTimeNow() < expires then return false end
        if not lplr.Character then return false end
        return true
    end,
    useAbility = function(self, abilityId, inputState, extraData)
        if not self:canUseAbility(abilityId) then return end
        if type(extraData) ~= 'table' then
            local enabled = self.enabledAbilities[abilityId]
            extraData = enabled and enabled.getExtraData and enabled.getExtraData() or nil
        end
        local remote = gameCoreEvents and gameCoreEvents:FindFirstChild('useAbility')
        if remote then
            remote:FireServer(abilityId, extraData)
        end
    end
}

bedwars.BalloonController = {
    inflateBalloon = function(self)
        bedwars.Client:Get('InflateBalloon'):SendToServer()
    end,
    deflateBalloon = function(self)
        bedwars.Client:Get('DeflateBalloon'):SendToServer()
    end
}

bedwars.BlockBreakController = {
    blockBreaker = bedwars.BlockBreaker
}

bedwars.BowConstantsTable = { -- stav, to-do: hardcode values if they change method
    RelX = replicatedStorage.TS.combat['projectile-util']:GetAttribute('ConstantManager_RelX'),
    RelY = replicatedStorage.TS.combat['projectile-util']:GetAttribute('ConstantManager_RelY'),
    RelZ = replicatedStorage.TS.combat['projectile-util']:GetAttribute('ConstantManager_RelZ')
}

local function layerMatches(appLayers, layerId)
    if type(appLayers) == 'table' then
        return table.find(appLayers, layerId) ~= nil
    end
    return appLayers == layerId
end

bedwars.AppController = {
    isAppOpen = function(_, appId)
        local playerGui = lplr:FindFirstChild('PlayerGui')
        return playerGui ~= nil and playerGui:FindFirstChild(appId) ~= nil
    end,
    isLayerOpen = function(self, layerId)
        if layerId then
            for appId, appLayers in bedwars.AppLayers do
                if layerMatches(appLayers, layerId) and self:isAppOpen(appId) then return true end
            end
            return false
        end
        for appId in bedwars.AppLayers do
            if self:isAppOpen(appId) then return true end
        end
        return false
    end,
    getOpenApps = function(self)
        local open = {}
        for appId in bedwars.AppLayers do
            if self:isAppOpen(appId) then
                table.insert(open, appId)
            end
        end
        return open
    end,
    closeApp = function(_, appId)
        local playerGui = lplr:FindFirstChild('PlayerGui')
        local app = playerGui and playerGui:FindFirstChild(appId)
        if app then
            pcall(function()
                app:Destroy()
            end)
        end
    end
}

local clickHoldSignal = {
    Connect = function()
        return {Disconnect = function() end}
    end,
    Once = function()
        return {Disconnect = function() end}
    end,
    Wait = function()
        return end
}

bedwars.ClickHold = {
    pressedSignal = clickHoldSignal,
    new = function(_, position, onCompleted, options, duration)
        duration = tonumber(duration) or 1
        local gui = Instance.new('ScreenGui')
        gui.Name = 'ClickHold'
        gui.IgnoreGuiInset = true
        gui.ResetOnSpawn = false
        gui.DisplayOrder = 100
        local bar = Instance.new('Frame')
        bar.AnchorPoint = Vector2.new(0.5, 0.5)
        if typeof(position) == 'UDim2' then
            bar.Position = position
        elseif typeof(position) == 'Vector2' then
            bar.Position = UDim2.fromOffset(position.X, position.Y)
        else
            bar.Position = UDim2.fromScale(0.5, 0.5)
        end
        bar.Size = UDim2.fromOffset(180, 6)
        bar.BackgroundColor3 = Color3.new(0, 0, 0)
        bar.BackgroundTransparency = 0.4
        bar.BorderSizePixel = 0
        bar.Parent = gui
        local fill = Instance.new('Frame')
        fill.Size = UDim2.fromScale(0, 1)
        fill.BackgroundColor3 = Color3.new(1, 1, 1)
        fill.BorderSizePixel = 0
        fill.Parent = bar
        gui.Parent = lplr:FindFirstChild('PlayerGui')

        local started = tick()
        local conn
        conn = runService.Heartbeat:Connect(function()
            local alpha = math.clamp((tick() - started) / duration, 0, 1)
            fill.Size = UDim2.fromScale(alpha, 1)
            if alpha < 1 then return end
            conn:Disconnect()
            gui:Destroy()
            if onCompleted then
                task.spawn(onCompleted)
            end
        end)

        local destroy = function()
            if conn then
                conn:Disconnect()
                conn = nil
            end
            gui:Destroy()
        end
        return {
            Disconnect = destroy,
            Destroy = destroy,
            pressedSignal = clickHoldSignal
        }
    end,
    startClick = function(self)
        if self and self.showProgress then
            self:showProgress(Vector2.new(workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.X / 2 or 0, workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.Y / 2 or 0), 1)
        end
    end,
    showProgress = function(self, position, duration)
        return bedwars.ClickHold.new(self, position, nil, nil, duration)
    end
}

bedwars.FovController = {
    setFOV = function(_, fov)
        if typeof(fov) == 'number' then
            gameCamera.FieldOfView = fov
        end
    end,
    getFOV = function()
        return gameCamera.FieldOfView
    end
}

bedwars.ViewmodelController = {
    crosshair = nil,
    crosshairImage = bedwars.CrosshairImage,
    isVisible = function()
        local viewmodel = gameCamera:FindFirstChild('Viewmodel')
        local primary = viewmodel and viewmodel.PrimaryPart
        if not primary then return false end
        return primary.Position.X > -9000
    end,
    showCrosshair = function(self)
        self.crosshair = true
        inputService.MouseIcon = self.crosshairImage or ''
    end,
    hideCrosshair = function(self)
        self.crosshair = false
        inputService.MouseIcon = ''
    end,
    setMouseIcon = function(_, icon)
        inputService.MouseIcon = icon
    end,
    clearMouseIcon = function()
        inputService.MouseIcon = ''
    end,
    playAnimation = function(_, animType, options)
        local viewmodel = gameCamera:FindFirstChild('Viewmodel')
        local humanoid = viewmodel and viewmodel:FindFirstChildOfClass('Humanoid')
        local animator = humanoid and humanoid:FindFirstChildOfClass('Animator')
        if not animator then return nil end
        return bedwars.AnimationUtil:playAnimation(animator, getAnimationAsset(animType), options)
    end
}

bedwars.InventoryViewmodelController = {
    handleStore = function() end
}

bedwars.GameAnimationUtil = {
    getAssetId = function(_, animType)
        return getAnimationAsset(animType)
    end,
    playAnimation = function(_, target, animType, options)
        return bedwars.AnimationUtil:playAnimation(target, getAnimationAsset(animType), options)
    end
}

bedwars.VisualizerUtils = {}
bedwars.QueueCard = {render = function() end}
bedwars.DamageIndicator = function() end
bedwars.NametagController = {addGameNametag = function() end}
bedwars.KillFeedController = {addToKillFeed = function() end}
bedwars.KillEffectController = {killEffects = {}}

local SprintConstants = {
    WALK_SPEED = 14,
    RUN_SPEED = 20,
    RUN_FOV_MULT = 1.1
}

local sprintModifiers = {}
local sprintRestore = nil

bedwars.SprintController = {
    sprinting = false,
    attemptingSprint = false,
    blockSprint = false,
    moveSpeedMultiplier = 1,
    maxSpeed = nil,
    immediateStop = false
}

local function updateSprintMovement()
    local blocked, percent, zero = false, 0, false
    for _, v in sprintModifiers do
        if v.moveSpeedMultiplier ~= nil then
            if v.moveSpeedMultiplier == 0 then
                zero = true
            else
                percent = percent + (v.moveSpeedMultiplier - 1)
            end
        end
        if v.blockSprint ~= nil then
            blocked = blocked or v.blockSprint
        end
    end
    bedwars.SprintController.blockSprint = blocked
    bedwars.SprintController.moveSpeedMultiplier = zero and 0 or (percent + 1)
    for _, v in sprintModifiers do
        if v.constantSpeedMultiplier ~= nil then
            bedwars.SprintController.moveSpeedMultiplier = v.constantSpeedMultiplier
        end
    end
    if bedwars.SprintController.blockSprint then
        bedwars.SprintController:stopSprinting(true)
    elseif bedwars.SprintController.attemptingSprint and not bedwars.SprintController.sprinting then
        bedwars.SprintController:startSprinting()
    end
    bedwars.SprintController:setSpeed(bedwars.SprintController.sprinting and SprintConstants.RUN_SPEED or SprintConstants.WALK_SPEED)
end

local sprintMovementModifier = {
    modifiers = sprintModifiers,
    addModifier = function(_, modifier)
        table.insert(sprintModifiers, modifier)
        updateSprintMovement()
        local removed = false
        local remove = function()
            if removed then return end
            removed = true
            local index = table.find(sprintModifiers, modifier)
            if index then
                table.remove(sprintModifiers, index)
            end
            updateSprintMovement()
        end
        return {remove = remove, DoCleaning = remove, Destroy = remove}
    end,
    removeModifier = function(_, modifier)
        local index = table.find(sprintModifiers, modifier)
        if index then
            table.remove(sprintModifiers, index)
        end
        updateSprintMovement()
    end,
    getModifiers = function()
        return sprintModifiers
    end,
    clear = function()
        table.clear(sprintModifiers)
        updateSprintMovement()
    end
}

bedwars.SprintController.setSpeed = function(self, speed)
    local character = lplr.Character
    local humanoid = character and character:FindFirstChildOfClass('Humanoid')
    if not humanoid then return end
    local value = speed * (self.moveSpeedMultiplier or 1)
    if self.maxSpeed and self.maxSpeed > 0 then
        value = math.min(self.maxSpeed, value)
    end
    humanoid.WalkSpeed = value
end

bedwars.SprintController.tweenCameraFOV = function(_, fov, duration)
    local info = TweenInfo.new(duration or 0.1, Enum.EasingStyle.Linear)
    local tween = tweenService:Create(gameCamera, info, {FieldOfView = fov})
    tween:Play()
    return tween
end

bedwars.SprintController.getFovMultiplier = function()
    return SprintConstants.RUN_FOV_MULT
end

bedwars.SprintController.startSprinting = function(self)
    if workspace:GetAttribute('FreecamEnabled') then return end
    if self.blockSprint then return end

    self.sprinting = true
    self.attemptingSprint = true
    lplr:SetAttribute('Sprinting', true)
    self:setSpeed(SprintConstants.RUN_SPEED)
    self:tweenCameraFOV(bedwars.FovController:getFOV() * SprintConstants.RUN_FOV_MULT, 0.1)

    sprintRestore = function()
        bedwars.SprintController:setSpeed(SprintConstants.WALK_SPEED)
        bedwars.SprintController:tweenCameraFOV(bedwars.FovController:getFOV(), 0.1)
    end
end

bedwars.SprintController.stopSprinting = function(self, resetAttempting)
    lplr:SetAttribute('Sprinting', false)
    if not self.sprinting then return end
    self.immediateStop = true
    local restore = sprintRestore
    sprintRestore = nil
    if restore then
        restore()
    end
    self.sprinting = false
    self.immediateStop = false
    if resetAttempting then
        self.attemptingSprint = false
    end
end

bedwars.SprintController.getMovementStatusModifier = function()
    return sprintMovementModifier
end

bedwars.SprintController.isSprinting = function(self)
    return self.sprinting
end

bedwars.SprintController:stopSprinting(true)

bedwars.SwordController = {
    lastAttack = 0,
    lastSwing = 0,
    swingCounter = 0,
    disableSwingState = false,
    thirdPersonSwingTrack = nil,

    getHandItem = function()
        return gameState.Inventory.observedInventory.inventory.hand
    end,
    isClickingTooFast = function(self)
        if tick() - self.lastSwing < 0.1111111111111111 then return true end
        self.lastSwing = tick()
        return false
    end,
    canAttack = function(_, entity)
        return entity.Targetable == true and entitylib.isVulnerable(entity)
    end,
    getEntityFromInstance = function(_, instance)
        if not instance then return nil end
        local current = instance
        while current do
            local entity = entitylib.getEntity(current)
            if entity then return entity end
            current = current.Parent
        end
        return nil
    end,
    canSee = function(_, entity)
        local character = lplr.Character
        local target = entity.getInstance and entity:getInstance() or entity.Character
        if not character or not target or not character.PrimaryPart or not target.PrimaryPart then return false end

        local bodyScale = 1
        local humanoid = target:FindFirstChildWhichIsA('Humanoid')
        local scale = humanoid and humanoid:FindFirstChild('BodyHeightScale')
        if scale then
            bodyScale = scale.Value or 1
        end

        local function bottomPosition(model)
            local primary = model.PrimaryPart
            if not primary then return nil end
            local hum = model:FindFirstChildWhichIsA('Humanoid')
            local hip = hum and hum.HipHeight or 0
            return primary.Position - Vector3.new(0, hip + primary.Size.Y / 2, 0)
        end

        local a = bottomPosition(character)
        local b = bottomPosition(target)
        if not a or not b then return false end
        local aHigh = a + Vector3.new(0, 5 * bodyScale, 0)
        local bHigh = b + Vector3.new(0, 5 * bodyScale, 0)

        local params = RaycastParams.new()
        local ignored = {character, target}
        for _, obj in collectionService:GetTagged('DontBlockSwordRaycast') do
            table.insert(ignored, obj)
        end
        params.FilterDescendantsInstances = ignored
        params.FilterType = Enum.RaycastFilterType.Exclude

        local function clear(from, to)
            local result = workspace:Raycast(from, to - from, params)
            if not result then return true end
            local model = result.Instance.Parent
            if not model then return false end
            return model:IsA('Model') and model:HasTag('DontBlockSwordRaycast')
        end

        local function pairClear(from, to)
            return clear(from, to) and clear(to, from)
        end

        return pairClear(a, b) or pairClear(aHigh, bHigh)
    end,
    getTargetInRegion = function(self, range, chargeTime)
        if store.matchState == 0 then return nil end
        local character = lplr.Character
        local primary = character and character.PrimaryPart
        if not primary or not entitylib.isAlive then return nil end

        local humanoid = character:FindFirstChildOfClass('Humanoid')
        local hipHeight = humanoid and humanoid.HipHeight or 0
        local half = Vector3.new(range / 2, math.max(3, hipHeight), range / 2)
        local center = primary.Position + primary.CFrame.LookVector.Unit * (range / 2)
        local min, max = center - half, center + half

        for _, entity in entitylib.List do
            local root = entity.RootPart
            if root and entity.Character ~= character and self:canAttack(entity) then
                local pos = root.Position
                if pos.X >= min.X and pos.X <= max.X
                    and pos.Y >= min.Y and pos.Y <= max.Y
                    and pos.Z >= min.Z and pos.Z <= max.Z
                    and (pos - primary.Position).Magnitude <= range
                    and self:canSee(entity) then
                    return entity
                end
            end
        end
        return nil
    end,
    sendServerRequest = function(self, entity, chargeRatio, options)
        if self.disableSwingState then return false end
        local character = lplr.Character
        local primary = character and character.PrimaryPart
        if not primary or not gameCamera then return false end
        local hand = self:getHandItem()
        if not hand or not hand.tool then return false end

        local inst = entity.getInstance and entity:getInstance() or entity.Character
        if not inst then return false end

        local camPos = gameCamera.CFrame.Position
        local selfPos = character:GetPivot().Position
        local targetPos = inst:GetPivot().Position
        local validate = {
            targetPosition = {value = targetPos},
            selfPosition = {value = selfPos}
        }
        local rayDirection = options and options.rayDirection
        if rayDirection then
            validate.raycast = {
                cameraPosition = {value = camPos},
                cursorDirection = {value = rayDirection}
            }
        end

        local payload = {
            weapon = hand.tool,
            entityInstance = inst,
            validate = validate,
            chargedAttack = {chargeRatio = chargeRatio or 0}
        }
        local swingStartTime = options and options.swingStartTime
        if type(swingStartTime) == 'number' and swingStartTime > 0 then
            payload.timeSinceSwingStart = workspace:GetServerTimeNow() - swingStartTime
        end

        store.attackReach = ((selfPos - targetPos).Magnitude * 100) // 1 / 100
        store.attackReachUpdate = tick() + 1
        self.lastAttack = workspace:GetServerTimeNow()

        bedwars.Client:Get(remotes.AttackEntity):SendToServer(payload)
        return true
    end,
    attackEntity = function(self, entity, rayDirection, chargeTime, config)
        if self.disableSwingState then return false end
        local character = lplr.Character
        local primary = character and character.PrimaryPart
        if not primary or not gameCamera then return false end
        local hand = self:getHandItem()
        if not hand or not hand.tool then return false end

        local itemMeta = bedwars.ItemMeta[hand.itemType]
        local sword = itemMeta and itemMeta.sword
        if not sword then return false end

        local inst = entity.getInstance and entity:getInstance() or entity.Character
        if not inst or not inst.Parent or not inst.PrimaryPart then return false end

        local range = sword.attackRange
        if not range or range == 0 or range ~= range then
            range = bedwars.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE or 14.4
        end
        if range + 2 <= (primary.Position - inst.PrimaryPart.Position).Magnitude then return false end

        local chargeSeconds = type(chargeTime) == 'table' and chargeTime.chargeTime or (type(chargeTime) == 'number' and chargeTime or 0)
        local ratio = 0
        if chargeSeconds > 0 and sword.chargedAttack and sword.chargedAttack.maxChargeTimeSec then
            ratio = math.clamp(chargeSeconds / sword.chargedAttack.maxChargeTimeSec, 0, 1)
        end

        if not config or config.playAnimation ~= false then
            self:playSwordEffect(itemMeta, ratio >= 1, config)
        end

        return self:sendServerRequest(entity, ratio, rayDirection and {rayDirection = rayDirection} or nil)
    end,
    swingSwordInRegion = function(self, chargeTime)
        if not entitylib.isAlive then return end
        local hand = self:getHandItem()
        if not hand or not hand.tool then return end

        local itemMeta = bedwars.ItemMeta[hand.itemType]
        local sword = itemMeta and itemMeta.sword
        if not sword then return end

        local range = sword.attackRange
        if not range or range == 0 or range ~= range then
            range = 3.8 * 3
        end

        local charge = type(chargeTime) == 'number' and chargeTime or 0
        local target = self:getTargetInRegion(range, charge)
        if not target then return end

        local ratio = 0
        if charge > 0 and sword.chargedAttack and sword.chargedAttack.maxChargeTimeSec then
            ratio = math.clamp(charge / sword.chargedAttack.maxChargeTimeSec, 0, 1)
        end

        local options
        if charge > 0 then
            options = {swingStartTime = workspace:GetServerTimeNow() - charge}
        end
        self:sendServerRequest(target, ratio, options)
        return true
    end,
    swingSwordAtMouse = function(self, chargeTime)
        if self:isClickingTooFast() then return end
        local hand = self:getHandItem()
        if not hand or not hand.tool then return end
        if not entitylib.isAlive then return end

        local character = lplr.Character
        local primary = character and character.PrimaryPart
        if not primary then return end

        local itemMeta = bedwars.ItemMeta[hand.itemType]
        local sword = itemMeta and itemMeta.sword
        local range = sword and sword.attackRange
        if not range or range == 0 or range ~= range then
            range = bedwars.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE or 14.4
        end

        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {character}
        params.FilterType = Enum.RaycastFilterType.Exclude

        local mouse = lplr:GetMouse()
        local direction = mouse.UnitRay.Direction
        local result = workspace:Raycast(mouse.UnitRay.Origin, direction * 200, params)
        local target = result and self:getEntityFromInstance(result.Instance)
        if result and target and (primary.Position - result.Instance.Position).Magnitude <= range
            and self:canAttack(target) and self:canSee(target) then
            self:attackEntity(target, direction, chargeTime)
            return
        end

        self:swingSwordInRegion(chargeTime)
    end,
    playSwordEffect = function(self, swordMeta, charged, config)
        if not swordMeta then return end
        local sword = swordMeta.sword
        if not sword then return end
        local hand = self:getHandItem()
        if not hand or not hand.tool then return end

        local chargedMeta = sword.chargedAttack
        if chargedMeta and chargedMeta.ignoreEffectsOnFullyCharged and charged then return end

        local swingAnimations = sword.swingAnimations
        if not swingAnimations or #swingAnimations == 0 then
            swingAnimations = {bedwars.AnimationType.SWORD_SWING}
        end
        local fpAnimations = sword.firstPersonSwingAnimations
        if not fpAnimations or #fpAnimations == 0 then
            fpAnimations = {bedwars.AnimationType.FP_SWING_SWORD}
        end
        local swingSounds = sword.swingSounds
        if not swingSounds or #swingSounds == 0 then
            swingSounds = {bedwars.SoundList.SWORD_SWING_1, bedwars.SoundList.SWORD_SWING_2}
        end

        if charged then
            swingAnimations = {bedwars.AnimationType.NEW_SWORD_SWING}
            fpAnimations = {bedwars.AnimationType.NEW_SWORD_SWING_FP}
            if chargedMeta and chargedMeta.chargedSwingAnimations then
                swingAnimations = chargedMeta.chargedSwingAnimations
            end
            if chargedMeta and chargedMeta.chargedFirstPersonSwingAnimations then
                fpAnimations = chargedMeta.chargedFirstPersonSwingAnimations
            end
        end

        local animIndex = math.min(self.swingCounter, #swingAnimations - 1) + 1
        local fpIndex = math.min(self.swingCounter, #fpAnimations - 1) + 1
        local anim = swingAnimations[animIndex]
        local fpAnim = fpAnimations[fpIndex]
        if not config or config.playAnimation ~= false then
            self.thirdPersonSwingTrack = bedwars.GameAnimationUtil:playAnimation(lplr, anim, {fadeSamePriorityTracks = false})
            if bedwars.ViewmodelController:isVisible() then
                bedwars.ViewmodelController:playAnimation(fpAnim)
            end
        end

        self.swingCounter = self.swingCounter + 1 < #swingAnimations and (self.swingCounter + 1) or 0

        if config and config.playSound == false then return end
        if swingSounds and #swingSounds > 0 then
            local sound = swingSounds[math.random(1, #swingSounds)]
            if sound then
                bedwars.SoundManager:playAudio(sound)
            end
        end
    end
}

bedwars.ProjectileController = {
    calculateImportantLaunchValues = function()
        return {}
    end,
    createLocalProjectile = function(_, source, ammo, projectileName, position, shootId, velocity, options)
        if typeof(position) == 'CFrame' then
            position = position.Position
        end
        if typeof(position) ~= 'Vector3' or typeof(velocity) ~= 'Vector3' then return end

        local assets = replicatedStorage:FindFirstChild('Assets')
        local folder = assets and assets:FindFirstChild('Projectiles')
        local template = folder and folder:FindFirstChild(projectileName)
        local model
        if template then
            model = template:Clone()
        else
            model = Instance.new('Part')
            model.Shape = Enum.PartType.Ball
            model.Size = Vector3.one * 0.4
            model.Material = Enum.Material.Neon
            model.Color = Color3.fromRGB(255, 220, 130)
            model.Anchored = true
            model.CanCollide = false
        end

        local part = model:IsA('BasePart') and model or (model.PrimaryPart or model:FindFirstChildWhichIsA('BasePart', true))
        if not part then
            model:Destroy()
            return
        end
        part.Anchored = true
        part.CanCollide = false
        part.CFrame = CFrame.new(position, position + velocity)
        model.Parent = workspace

        local lifetime = math.clamp(tonumber(options and options.drawDurationSeconds) or 3, 0.1, 10)
        local elapsed = 0
        local currentPos = position
        local currentVelocity = velocity
        local conn
        conn = runService.Heartbeat:Connect(function(dt)
            if not model.Parent then
                conn:Disconnect()
                return
            end
            elapsed = elapsed + dt
            currentVelocity = currentVelocity + Vector3.new(0, -workspace.Gravity * dt, 0)
            local nextPos = currentPos + currentVelocity * dt
            local params = RaycastParams.new()
            params.FilterDescendantsInstances = {model, lplr.Character}
            params.FilterType = Enum.RaycastFilterType.Exclude
            local result = workspace:Raycast(currentPos, nextPos - currentPos, params)
            if result then
                part.CFrame = CFrame.new(result.Position, result.Position + currentVelocity)
                currentPos = result.Position
                conn:Disconnect()
            else
                currentPos = nextPos
                part.CFrame = CFrame.new(currentPos, currentPos + currentVelocity)
            end
            if elapsed >= lifetime then
                if conn.Connected then
                    conn:Disconnect()
                end
                model:Destroy()
            end
        end)
        return model
    end
}

local knockbackModule = replicatedStorage.TS and replicatedStorage.TS.damage and replicatedStorage.TS.damage['knockback-util']

local function knockbackConstant(name, default)
    if knockbackModule then
        local value = knockbackModule:GetAttribute(name)
        if type(value) == 'number' then return value end
    end
    return default
end

local function getKnockbackConstants()
    return {
        kbUpwardStrength = knockbackConstant('ConstantManager_kbUpwardStrength', 10000),
        kbDirectionStrength = knockbackConstant('ConstantManager_kbDirectionStrength', 11750),
        kbStandardMass = knockbackConstant('ConstantManager_kbStandardMass', 300),
        nonGroundedHorizontalResistence = knockbackConstant('ConstantManager_nonGroundedHorizontalResistence', 0.6),
        nonGroundedVerticalResistence = knockbackConstant('ConstantManager_nonGroundedVerticalResistence', 0.75)
    }
end

bedwars.KnockbackUtil = {
    getDirection = function(_, from, dir)
        if typeof(dir) ~= 'Vector3' or (dir.X == 0 and dir.Y == 0 and dir.Z == 0) then
            return Vector3.zero
        end
        local flat = Vector3.new(dir.X, 0, dir.Z)
        if flat.Magnitude < 0.0001 then
            flat = workspace.CurrentCamera.CFrame.LookVector
        end
        return (flat.Unit * 0.7 + Vector3.new(0, 1, 0) * 0.4 + dir.Unit * 0.4).Unit
    end,
    calculateKnockbackVelocity = function(_, dir, mass, options)
        local workspaceAttr = tonumber(workspace:GetAttribute('kbmultiplier')) or 1
        local horizontalMultiplier = workspaceAttr * ((options and options.horizontalMultiplier) or 1)
        local verticalMultiplier = workspaceAttr * ((options and options.verticalMultiplier) or 1)
        local constants = getKnockbackConstants()
        return dir
            * constants.kbDirectionStrength
            * (mass / constants.kbStandardMass)
            * horizontalMultiplier
            + Vector3.new(0, 1, 0) * constants.kbUpwardStrength * (mass / constants.kbStandardMass) * verticalMultiplier
    end,
    calculateKnockbackVelocityRelative = function(_, entity, mass, dir, options)
        local from = entity and entity.PrimaryPart and entity.PrimaryPart.Position or Vector3.zero
        return bedwars.KnockbackUtil:calculateKnockbackVelocity(bedwars.KnockbackUtil:getDirection(from, dir), mass, options)
    end,
    applyKnockback = function(_, rootPart, mass, dir, options)
        if rootPart == nil or typeof(dir) ~= 'Vector3' or (dir.X == 0 and dir.Y == 0 and dir.Z == 0) then return end
        local direction = bedwars.KnockbackUtil:getDirection(rootPart.Position, dir)
        direction = direction - Vector3.new(0, 1, 0) * direction.Y
        local velocity = bedwars.KnockbackUtil:calculateKnockbackVelocity(direction, mass, options)
        if velocity.Magnitude < 0.0001 then return end
        bedwars.KnockbackUtil:applyKnockbackPlatformStand(rootPart)
        rootPart:ApplyImpulse(velocity * rootPart.AssemblyMass)
        return velocity
    end,
    applyKnockbackDirection = function(_, rootPart, mass, dir, options)
        if rootPart == nil or typeof(dir) ~= 'Vector3' or (dir.X == 0 and dir.Y == 0 and dir.Z == 0) then return end
        local velocity = bedwars.KnockbackUtil:calculateKnockbackVelocity(dir, mass, options)
        if velocity.Magnitude < 0.0001 then return end
        bedwars.KnockbackUtil:applyKnockbackPlatformStand(rootPart)
        rootPart:ApplyImpulse(velocity * rootPart.AssemblyMass)
        return velocity
    end,
    predictKnockBackVelocity = function(_, rootPart, mass, dir, options)
        local direction = bedwars.KnockbackUtil:getDirection(rootPart.Position, dir)
        direction = direction - Vector3.new(0, 1, 0) * direction.Y
        return bedwars.KnockbackUtil:calculateKnockbackVelocity(direction, mass, options)
    end,
    applyKnockbackPlatformStand = function(_, rootPart)
        if rootPart == nil then return end
        local assembly = rootPart:FindFirstAncestorWhichIsA('Model') or rootPart
        local humanoid = assembly:FindFirstChildWhichIsA('Humanoid')
        if humanoid then
            humanoid.PlatformStand = true
        end
    end
}

bedwars.StatefulEntityKnockbackController = {lastImpulseTime = 0}

bedwars.PartyController = {
    leaveParty = function()
        bedwars.Client:Get('LeaveParty'):CallServer()
    end
}

bedwars.QueueController = {
    joinQueue = function(_, queueType)
        bedwars.Client:Get('QueueForPlaylist'):SendToServer(queueType)
    end,
    leaveQueue = function()
        bedwars.Client:Get('LeaveQueue'):CallServer()
    end
}

bedwars.BedwarsShopController = {alreadyPurchasedMap = {}}
bedwars.BlockCpsController = {lastPlaceTimestamp = 0}
bedwars.BlockPlacementController = {
    blockPlacer = nil
}

bedwars.BlockPlacer = {
    new = function(_, blockEngine, blockType)
        local placer = {
            blockType = blockType,
            clientManager = bedwars.BlockBreaker.clientManager,
            placed = {},
            blockQueue = {},
            maxQueuedBlocks = 20,
            blockHealth = nil,
            disable = function() end,
            destroy = function() end
        }
        placer.placeBlock = function(self, pos)
            local placed = bedwars.placeBlock(pos, self.blockType)
            if placed then
                self.lastPlaceTimestamp = workspace:GetServerTimeNow()
                table.insert(self.placed, pos)
            end
            return placed
        end
        return placer
    end
}

bedwars.BlockPlacementController.blockPlacer = bedwars.BlockPlacer.new(nil, nil, 'wool_white')
bedwars.DaoController = {chargingMaid = nil}
bedwars.VoidDragonController = {flapWings = function() end, inDragonForm = false}
bedwars.WindWalkerController = {updateSpeed = function() end, spawnOrb = function() end}
bedwars.BatteryEffectsController = {liveBatteries = {}, getBatteryInfo = function() return nil end}
bedwars.GrimReaperController = {soulsByPosition = {}}
bedwars.BlockKickerKitController = {getKickBlockProjectileOriginPosition = function() return nil end}
bedwars.CannonHandController = {launchSelf = function() end}
bedwars.CatController = {leap = function() end}
bedwars.DragonSlayerController = {playPunchAnimation = function() end, deleteEmblem = function() end}
bedwars.FishingMinigameController = {startMinigame = function() end}
bedwars.JailorController = {collectEntity = function() end}
bedwars.StarCollectorController = {collectEntity = function() end}
bedwars.LaunchPadController = {attemptLaunch = function() end}
bedwars.ScytheController = {playLocalAnimation = function() end}
bedwars.SpiritAssassinController = {useSpirit = function() bedwars.Client:Get('UseSpirit'):SendToServer() end}
bedwars.RavenController = {detonateRaven = function() bedwars.Client:Get('DetonateRaven'):SendToServer() end}
bedwars.ItemDropController = {
    dropItemInHand = function()
        local hand = lplr.Character and lplr.Character:FindFirstChild('HandInvItem')
        if hand and hand.Value then
            bedwars.Client:Get(remotes.DropItem):SendToServer({item = hand.Value})
        end
    end
}
bedwars.GuidedProjectileController = {
    fireGuidedProjectile = getRemoteData(netManaged:FindFirstChild('FireGuidedProjectile')) or emptyRemote
}

local kitControllers = setmetatable({}, {
    __index = function(self, ind)
        rawset(self, ind, {})
        return rawget(self, ind)
    end
})
bedwars.Knit = {Controllers = kitControllers}

--[[

    Store sync

]]

for _, v in Enum.NormalId:GetEnumItems() do
    table.insert(sides, Vector3.FromNormalId(v) * 3)
end

local cache = {}
local function getBlockHits(block, blockpos)
    if not block then return 0 end
    local blockmeta = bedwars.ItemMeta[block.Name]
    local breaktype = blockmeta and blockmeta.block and blockmeta.block.breakType
    local tool = breaktype and store.tools[breaktype]
    local toolmeta = tool and bedwars.ItemMeta[tool.itemType]
    local damage = toolmeta and toolmeta.breakBlock and toolmeta.breakBlock[breaktype] or 2
    return (block:GetAttribute('1') or block:GetAttribute('Health') or 0) / damage
end

--[[[
    Pathfinding using a luau version of dijkstra's algorithm
    Source: https://stackoverflow.com/questions/39355587/speeding-up-dijkstras-algorithm-to-solve-a-3d-maze
]]

local function calculatePath(target, blockpos)
    if cache[blockpos] then
        return unpack(cache[blockpos])
    end
    local visited, unvisited, distances, air, path = {}, {{0, blockpos}}, {[blockpos] = 0}, {}, {}

    for _ = 1, 10000 do
        local _, node = next(unvisited)
        if not node then break end
        table.remove(unvisited, 1)
        visited[node[2]] = true

        for _, side in sides do
            side = node[2] + side
            if visited[side] then continue end

            local block = findBlock(side)
            if not block or block:GetAttribute('NoBreak') or block == target then
                if not block then
                    air[side] = true
                end
                continue
            end

            local curdist = getBlockHits(block, side) + node[1]
            if curdist < (distances[side] or math.huge) then
                table.insert(unvisited, {curdist, side})
                distances[side] = curdist
                path[side] = node[2]
            end
        end
    end

    local pos, cost = nil, math.huge
    for node in air do
        if distances[node] < cost then
            pos, cost = node, distances[node]
        end
    end

    if pos then
        cache[blockpos] = {
            pos,
            cost,
            path
        }
        return pos, cost, path
    end
end

bedwars.placeBlock = function(pos, item)
    if not getItem(item) then return end
    local blockpos = bedwars.BlockController:getBlockPosition(pos)
    local success, result = pcall(function()
        bedwars.ClientDamageBlock:Get('PlaceBlock'):CallServer({
            blockType = item,
            position = blockpos
        })
    end)
    if success then
        bedwars.BlockCpsController.lastPlaceTimestamp = workspace:GetServerTimeNow()
    end
    return success, result
end

bedwars.breakBlock = function(block, effects, anim, customHealthbar)
    if lplr:GetAttribute('DenyBlockBreak') or not entitylib.isAlive or InfiniteFly.Enabled then return end
    local cost, pos, target, path = math.huge

    for _, v in {block.Position / 3} do
        local dpos, dcost, dpath = calculatePath(block, v * 3)
        if dpos and dcost < cost then
            cost, pos, target, path = dcost, dpos, v * 3, dpath
        end
    end

    if pos then
        if (entitylib.character.RootPart.Position - pos).Magnitude > 30 then return end
        local dblock, dpos = findBlock(pos), pos
        if not dblock then return end

        if (workspace:GetServerTimeNow() - bedwars.SwordController.lastAttack) > 0.4 then
            local blockmeta = bedwars.ItemMeta[dblock.Name]
            local breaktype = blockmeta and blockmeta.block and blockmeta.block.breakType
            local tool = breaktype and store.tools[breaktype]
            if tool then
                switchItem(tool.tool)
            end
        end

        bedwars.ClientDamageBlock:Get('DamageBlock'):CallServerAsync({
            blockRef = {blockPosition = dpos},
            hitPosition = pos,
            hitNormal = Vector3.FromNormalId(Enum.NormalId.Top)
        }):andThen(function(result)
            if not result then return end
            if result == 'cancelled' then
                store.damageBlockFail = tick() + 1
                return
            end

            if effects then
                customHealthbar = customHealthbar or bedwars.BlockBreaker.updateHealthbar
                customHealthbar(bedwars.BlockBreaker, {blockPosition = dpos}, 0, dblock:GetAttribute('MaxHealth'), dblock:GetAttribute('Health'), dblock)
            end

            if anim then
                local animation = bedwars.AnimationUtil:playAnimation(lplr, bedwars.BlockController:getAnimationController():getAssetId(1))
                bedwars.ViewmodelController:playAnimation(15)
                task.wait(0.3)
                animation:Stop()
                animation:Destroy()
            end
        end)

        if effects then
            return pos, path, target
        end
    end
end

local function hookEvent(name, callback)
    local remote = netManaged:FindFirstChild(name)
    if remote then
        vape:Clean(remote.OnClientEvent:Connect(callback))
    end
end

hookEvent('MatchStateEvent', function(state)
    if typeof(state) == 'number' then
        gameState.Game.matchState = state
    end
end)

hookEvent('QueueTypeEvent', function(queueType)
    if typeof(queueType) == 'string' then
        gameState.Game.queueType = queueType
    end
end)

hookEvent('TeamsUpdateEvent', function(teams)
    if typeof(teams) == 'table' then
        gameState.Game.myTeam = teams[tonumber(lplr:GetAttribute('Team')) or 1] or gameState.Game.myTeam
    end
end)

hookEvent('MatchEndEvent', function(winTable)
    gameState.Game.matchState = 2
    vapeEvents.MatchEndEvent:Fire(winTable)
end)

for _, event in {'EntityDeathEvent', 'BedwarsBedBreak', 'BalloonPopped', 'AngelProgress', 'GrapplingHookFunctions'} do
    hookEvent(event, function(...)
        vapeEvents[event]:Fire(...)
    end)
end

local zapFolder = replicatedStorage:FindFirstChild('ZAP')
local zapRemote = zapFolder and zapFolder:FindFirstChild('ZAP_RELIABLE')
local zapBlockHandlers = {PlaceBlockEvent = {}, BreakBlockEvent = {}}
local zapFiredAt = {}

local function dispatchZapBlock(kind, blockPosition, blockName, normal, player)
    local key = kind .. tostring(blockPosition)
    if zapFiredAt[key] and tick() - zapFiredAt[key] < 1 then return end
    zapFiredAt[key] = tick()
    for _, handler in zapBlockHandlers[kind] do
        task.spawn(handler, blockPosition, blockName, normal, player)
    end
end

local function signedU16(value)
    return value > 32767 and value - 65536 or value
end

if zapRemote and typeof(buffer) == 'table' then
    vape:Clean(zapRemote.OnClientEvent:Connect(function(data, instances)
        if typeof(data) ~= 'buffer' then return end
        local length = buffer.len(data)
        local cursor = 0
        local instanceIndex = 0

        local function readU8()
            if cursor >= length then error('ZAP buffer overflow') end
            local value = buffer.readu8(data, cursor)
            cursor += 1
            return value
        end
        local function readU16()
            if cursor + 2 > length then error('ZAP buffer overflow') end
            local value = buffer.readu16(data, cursor)
            cursor += 2
            return value
        end
        local function readF32()
            if cursor + 4 > length then error('ZAP buffer overflow') end
            local value = buffer.readf32(data, cursor)
            cursor += 4
            return value
        end
        local function readString(len)
            if cursor + len > length then error('ZAP buffer overflow') end
            local value = buffer.readstring(data, cursor, len)
            cursor += len
            return value
        end

        pcall(function()
            while cursor < length do
                local id = readU8()
                if id == 5 then
                    local position = Vector3.new(signedU16(readU16()), signedU16(readU16()), signedU16(readU16()))
                    local blockName = readString(readU16())
                    dispatchZapBlock('PlaceBlockEvent', position, blockName)
                elseif id == 6 then
                    local position = Vector3.new(signedU16(readU16()), signedU16(readU16()), signedU16(readU16()))
                    local blockName = readString(readU16())
                    local hitPosition = Vector3.new(readF32(), readF32(), readF32())
                    local normal = nil
                    if readU8() == 1 then
                        normal = Vector3.new(readU8(), readU8(), readU8())
                    end
                    local player = nil
                    if readU8() == 1 then
                        instanceIndex += 1
                        player = instances and instances[instanceIndex]
                    end
                    dispatchZapBlock('BreakBlockEvent', position, blockName, hitPosition, normal, player)
                else
                    return
                end
            end
        end)
    end))
end

bedwars.ZapNetworking = {
    SendEvents = function() end,
    EntityDamageEventZap = {
        On = function(handler)
            local remote = netManaged:FindFirstChild('EntityDamageEvent')
            if not remote then return function() end end
            local conn = remote.OnClientEvent:Connect(handler)
            return function()
                conn:Disconnect()
            end
        end
    },
    PickupItemEventZap = {On = function() return function() end end},
    ProjectileLaunchZap = {On = function() return function() end end},
    ProjectileImpactZap = {On = function() return function() end end},
    UpdateMapDataZap = {On = function() return function() end end},
    EntityHealEventZap = {On = function() return function() end end},
    AddMatchEventCountdownZap = {On = function() return function() end end},
    KitsUpdateEventZap = {On = function() return function() end end},
    FetchMapDataFuncZap = {Call = function() return nil end}
}

local function blockEventSubscription(kind)
    return function(handler)
        table.insert(zapBlockHandlers[kind], handler)
        return function()
            local index = table.find(zapBlockHandlers[kind], handler)
            if index then
                table.remove(zapBlockHandlers[kind], index)
            end
        end
    end
end

bedwars.ZapNetworking.PlaceBlockEventZap = {On = blockEventSubscription('PlaceBlockEvent')}
bedwars.ZapNetworking.BreakBlockEventZap = {On = blockEventSubscription('BreakBlockEvent')}

vape:Clean(bedwars.ZapNetworking.EntityDamageEventZap.On(function(...)
    vapeEvents.EntityDamageEvent:Fire({
        entityInstance = ...,
        damage = select(2, ...),
        damageType = select(3, ...),
        fromPosition = select(4, ...),
        fromEntity = select(5, ...),
        knockbackMultiplier = select(6, ...),
        knockbackId = select(7, ...),
        disableDamageHighlight = select(13, ...)
    })
end))

local function invalidateBlockCache(blockPosition)
    for i, v in cache do
        if ((blockPosition * 3) - v[1]).Magnitude <= 30 then
            table.clear(v[3])
            table.clear(v)
            cache[i] = nil
        end
    end
end

vape:Clean(bedwars.ZapNetworking.PlaceBlockEventZap.On(function(blockPosition)
    invalidateBlockCache(blockPosition)
    vapeEvents.PlaceBlockEvent:Fire({
        blockRef = {blockPosition = blockPosition}
    })
end))

vape:Clean(bedwars.ZapNetworking.BreakBlockEventZap.On(function(blockPosition, blockName, hitPosition, normal, player)
    invalidateBlockCache(blockPosition)
    vapeEvents.BreakBlockEvent:Fire({
        blockRef = {blockPosition = blockPosition},
        player = player
    })
end))

local knownBlocks = {}

local function scanBlockIndex()
    local current = {}
    for _, block in collectionService:GetTagged('block') do
        if block.Size == Vector3.one * 3 then
            current[roundBlockPos(block.Position)] = block
        end
    end
    return current
end

knownBlocks = scanBlockIndex()

task.spawn(function()
    while vape.Loaded ~= nil do
        task.wait(0.25)
        local current = scanBlockIndex()
        for pos, block in current do
            if not knownBlocks[pos] then
                dispatchZapBlock('PlaceBlockEvent', pos / 3, block.Name)
            end
        end
        for pos, block in knownBlocks do
            if not current[pos] then
                dispatchZapBlock('BreakBlockEvent', pos / 3, block.Name)
            end
        end
        knownBlocks = current
    end
end)

local kills = sessioninfo:AddItem('Kills')
local beds = sessioninfo:AddItem('Beds')
local wins = sessioninfo:AddItem('Wins')
local games = sessioninfo:AddItem('Games')

local mapname = 'Unknown'
sessioninfo:AddItem('Map', 0, function()
    return mapname
end, false)

task.delay(1, function()
    games:Increment()
end)

task.spawn(function()
    pcall(function()
        repeat task.wait() until store.matchState ~= 0 or vape.Loaded == nil
        if vape.Loaded == nil then return end
        mapname = workspace:WaitForChild('Map', 5):WaitForChild('Worlds', 5):GetChildren()[1].Name
        mapname = string.gsub(string.split(mapname, '_')[2] or mapname, '-', '') or 'Blank'
    end)
end)

vape:Clean(vapeEvents.BedwarsBedBreak.Event:Connect(function(bedTable)
    if bedTable.player and bedTable.player.UserId == lplr.UserId then
        beds:Increment()
    end
end))

vape:Clean(vapeEvents.MatchEndEvent.Event:Connect(function(winTable)
    if (gameState.Game.myTeam or {}).id == winTable.winningTeamId or lplr.Neutral then
        wins:Increment()
    end
end))

vape:Clean(vapeEvents.EntityDeathEvent.Event:Connect(function(deathTable)
    local killer = playersService:GetPlayerFromCharacter(deathTable.fromEntity)
    local killed = playersService:GetPlayerFromCharacter(deathTable.entityInstance)
    if not killed or not killer then return end

    if killed ~= lplr and killer == lplr then
        kills:Increment()
    end
end))

task.spawn(function()
    gameState.Game.matchState = workspace:FindFirstChild('Map') and 1 or 0
    gameState.Game.queueType = workspace:GetAttribute('QueueType') or 'bedwars_test'
    updateStore()

    repeat
        if entitylib.isAlive then
            entitylib.character.AirTime = entitylib.character.Humanoid.FloorMaterial ~= Enum.Material.Air and tick() or entitylib.character.AirTime
        end

        for _, v in entitylib.List do
            v.LandTick = math.abs(v.RootPart.Velocity.Y) < 0.1 and v.LandTick or tick()
            if (tick() - v.LandTick) > 0.2 and v.Jumps ~= 0 then
                v.Jumps = 0
                v.Jumping = false
            end
        end

        gameState.Game.queueType = workspace:GetAttribute('QueueType') or gameState.Game.queueType
        updateStore()
        task.wait(0.5)
    until vape.Loaded == nil
end)

vape:Clean(function()
    for _, v in vapeEvents do
        v:Destroy()
    end
    for _, v in cache do
        table.clear(v[3])
        table.clear(v)
    end
    table.clear(cache)
    table.clear(sides)
    table.clear(remotes)
    table.clear(store)
    table.clear(bedwars)
end)

return {loaded = true}
