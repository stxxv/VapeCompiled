--[[

    comboss 764.
    construct.json is automatically generated with the help of tel aviv.

]]

local cloneref = cloneref or function(obj)
    return obj
end

local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local httpService = cloneref(game:GetService('HttpService'))
local playersService = cloneref(game:GetService('Players'))
local lplr = playersService.LocalPlayer

local vape = shared.vape

local function notif(args)
    return vape:CreateNotification(args)
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
    if not (require or debug.getupvalue or debug.getupvalues or debug.getconstants or debug.getconstant or debug.getproto or debug.getprotos) then
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
            SoundManager = require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['game-core'].out).SoundManager,
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

    return
end

--[[

    Emulation in order

]]

bedwars.AbilityController = {
    canUseAbility = function(self)
        return true
    end,
    useAbility = function(self, name, ...)
        replicatedStorage['events-@easy-games/game-core:shared/game-core-networking@getEvents.Events'].useAbility:FireServer(name, ...)
    end
}

bedwars.BalloonController = {
    inflateBalloon = function(self) end,
    deflateBalloon = function(self) end
}

bedwars.BlockBreakController = {
    blockBreaker = {
        setCooldown = function(self) end
    }
}

bedwars.BowConstantsTable = { -- stav, to-do: hardcode values if they change method
    RelX = replicatedStorage.TS.combat['projectile-util']:GetAttribute('ConstantManager_RelX'),
    RelY = replicatedStorage.TS.combat['projectile-util']:GetAttribute('ConstantManager_RelY'),
    RelZ = replicatedStorage.TS.combat['projectile-util']:GetAttribute('ConstantManager_RelZ')
}

bedwars.StatefulEntityKnockbackController = {}