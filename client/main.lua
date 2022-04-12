local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData()
local PlayerJob = {}
local isJoinQueue, isContractStarted, Tier = false, false, nil
local carSpawned, carID, carmodel = nil, nil, nil
local display = false
local zone, inZone, blipDisplay, dropBlip, cooldown, inscratchPoint = nil, false, nil, nil, false, false
local scratchpoint 
OnlineCops = 0


local tabletDict = "amb@code_human_in_bus_passenger_idles@female@tablet@base"
local tabletAnim = "base"
local tabletProp = 'prop_cs_tablet'
local tabletBone = 60309
local tabletOffset = vector3(0.03, 0.002, -0.0)
local tabletRot = vector3(10.0, 160.0, 0.0)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    PlayerJob = QBCore.Functions.GetPlayerData().job
    onDuty = true
    TriggerServerEvent('jl-carboost:server:getItem')
    TriggerEvent('jl-carboost:client:setupLaptop')
end)

RegisterNetEvent('police:SetCopCount', function (amount)
    OnlineCops = amount
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    PlayerData = val
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function ()
    PlayerJob = {}
    TriggerServerEvent('jl-carboost:server:removeData', PlayerData.citizenid)  
    PlayerData = {}
    Config.BennysItems = {}
end)

RegisterNetEvent('QBCore:Client:SetDuty', function(duty)
    onDuty = duty
end)

-- function

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type="openlaptop",
        status = bool
    })
    doAnimation()
end

local function createRadiusBlips(v)
    local blip = Citizen.InvokeNative(0x46818D79B1F7499A,v.x + math.random(0.0,150.0), v.y + math.random(0.0,80.0), v.z + math.random(0.0,5.0) , 300.0)
    SetBlipHighDetail(blip, true)
    SetBlipColour(blip, 68)
    SetBlipAsShortRange(blip, true)
    SetBlipAlpha(blip, 128)
    blipDisplay = blip
end

local function CreateBlip(coords, name, sprite, colour)
    colour = colour or 4
	local blip = AddBlipForCoord(coords)
	SetBlipSprite(blip, sprite)
	SetBlipScale(blip, 0.6)
	SetBlipColour(blip, colour)
	SetBlipDisplay(blip, 4)
    SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(name)
	EndTextCommandSetBlipName(blip)
	return blip
end



local function spawnAngryPed(coords)
    if coords and coords[1] then
        for k, v in pairs(coords) do
            local npc = {
                'a_m_m_beach_01',
                'a_m_m_og_boss_01',
                'a_m_m_soucent_01',
            }
            local x,y,z = v.x, v.y, v.z
            local model = npc[math.random(1, #npc)]
            local hash = GetHashKey(model)
            RequestModel(hash)
            while not HasModelLoaded(model) do
                Wait(50)
            end
            local ped = CreatePed(1, hash, x, y, z, 0.0, true, true)
            SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(ped), true)
            SetPedAccuracy(ped, 30)
            SetPedRelationshipGroupHash(ped, `HATES_PLAYER`)
            SetPedKeepTask(ped, true)
            SetCanAttackFriendly(ped, false, true)
            TaskCombatPed(ped, PlayerPedId(), 0, 16)
            SetPedCombatAttributes(ped, 46, true)
            SetPedCombatAbility(ped, 1)
            SetPedCombatAttributes(ped, 0, true)
            GiveWeaponToPed(ped, "WEAPON_PISTOL", -1, false, true)
            SetPedDropsWeaponsWhenDead(ped, false)
            SetPedCombatRange(ped, 1)
            SetPedFleeAttributes(ped, 0, 0)
            SetPedConfigFlag(ped, 58, true)
            SetPedConfigFlag(ped, 75, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            SetEntityAsNoLongerNeeded(ped)
        end
    end
end

-- Zamn thanks qb-mdt 😎
function doAnimation()
    if not display then return end
    -- Animation
    RequestAnimDict(tabletDict)
    while not HasAnimDictLoaded(tabletDict) do Citizen.Wait(100) end
    -- Model
    RequestModel(tabletProp)
    while not HasModelLoaded(tabletProp) do Citizen.Wait(100) end

    local plyPed = PlayerPedId()

    local tabletObj = CreateObject(tabletProp, 0.0, 0.0, 0.0, true, true, false)

    local tabletBoneIndex = GetPedBoneIndex(plyPed, tabletBone)

    AttachEntityToEntity(tabletObj, plyPed, tabletBoneIndex, tabletOffset.x, tabletOffset.y, tabletOffset.z, tabletRot.x, tabletRot.y, tabletRot.z, true, false, false, false, 2, true)
    SetModelAsNoLongerNeeded(tabletProp)

    CreateThread(function()
        while display do
            Wait(0)
            if not IsEntityPlayingAnim(plyPed, tabletDict, tabletAnim, 3) then
                TaskPlayAnim(plyPed, tabletDict, tabletAnim, 3.0, 3.0, -1, 49, 0, 0, 0, 0)
            end
        end
        ClearPedSecondaryTask(plyPed)
        Wait(250)
        DetachEntity(tabletObj, true, false)
        DeleteEntity(tabletObj)
    end)
end

local function StartHacking(vehicle)
    local veh = Entity(vehicle)
    local trackerLeft = veh.state.trackerLeft
    if veh.state.tracker then
        if not veh.state.hacked then
            local success =  exports['boostinghack']:StartHack()
            if success then
                local randomSeconds = math.random(30)
                trackerLeft = trackerLeft - 1
                veh.state.trackerLeft = trackerLeft
                veh.state.hacked = true
                if trackerLeft == 0 then
                    veh.state.tracker = false
                    veh.state.hacked = true
                    return QBCore.Functions.Notify(Lang:t("success.disable_tracker"))
                else
                    QBCore.Functions.Notify(Lang:t('success.tracker_off', {time = randomSeconds, tracker_left = trackerLeft}))
                end
                CreateThread(function ()
                    Wait(randomSeconds*1000)
                    veh.state.hacked = false
                end)
            else
                QBCore.Functions.Notify(Lang:t('error.disable_fail'), "error")
            end
        else
            print("ALREADY HACKED")
        end
    else
        QBCore.Functions.Notify(Lang:t("error.no_tracker"), "error")
    end
end

local function RegisterCar(vehicle)
    local veh = Entity(vehicle)
    veh.state.tracker = true
    print(Tier)
    veh.state.trackerLeft = math.random(Config.Tier[Tier].attempt) or math.random(3)
    veh.state.hacked = false
end

local function finishBoosting(data)
    TriggerServerEvent('jl-carboost:server:finishBoosting', 'normal', Tier)
    TriggerEvent('jl-carboost:client:deleteContract')
    DeleteEntity(carSpawned)
    RemoveBlip(dropBlip)
    carSpawned = nil
    zone:destroy()
    zone = nil
    inZone = false
    isContractStarted = false
    carmodel = nil
    ContractID = nil
    Wait(1000)
    TriggerEvent('jl-carboost:client:refreshQueue')
end

local function Scratching()
    TriggerServerEvent('jl-carboost:server:finishBoosting', 'vin', Tier)
    TriggerEvent('jl-carboost:client:deleteContract')
    scratchpoint:destroy()
    scratchpoint = nil
    RemoveBlip(dropBlip)
    carSpawned = nil
    inscratchPoint = false
    isContractStarted = false
    carmodel = nil
    ContractID = nil
    Wait(1000)
    TriggerEvent('jl-carboost:client:refreshQueue')
end

local function BoostingAlert()
    if Config.Alert == 'qb-dispatch' then
        AlertBoosting(carID, 'qb-dispatch')
    elseif Config.Alert == 'linden_outlawalert' then
        AlertBoosting(carID, 'linden_outlawalert')
    else
        AlertBoosting(carID, 'notification')
    end
end

-- NUI
RegisterNUICallback('openlaptop', function (data)
    SetDisplay(false)
end)

RegisterNUICallback('exit', function (data)
    SetDisplay(false)
end)

RegisterNUICallback('wallpaper', function (data)
    local wallpaper = data.wallpaper
    TriggerServerEvent('jl-carboost:server:saveConfig', data)
    -- print(json.encode(PlayerData.metadata['laptopdata']))
end)

RegisterNUICallback('loadstore', function (data, cb)
    local storeitem = {}
    if Config.BennysSell then
        for k, v in pairs(Config.BennysSell) do
            local name
            if not storeitem[k] then
                if QBCore.Shared.Items[v.item] ~= nil then
                    if Config.BennysSell[k].name then
                        name = Config.BennysSell[k].name
                    else
                       if QBCore.Shared.Items[v.item] ~= nil then
                           name = QBCore.Shared.Items[v.item].label
                       else
                        name = "Unknown"
                         return TriggerServerEvent('jl-carboost:server:log', "")
                       end
                    end
                    storeitem[#storeitem+1] = {
                        name = name,
                        item = v.item,
                        image = Config.Inventory ..QBCore.Shared.Items[v.item].image,
                        price = v.price,
                        stock = v.stock
                    }
                else
                    TriggerServerEvent('jl-carboost:server:log', "The item is not found :"..k)
                end
            else
                TriggerServerEvent("jl-carboost:server:log", "Duplicate item found: " .. k)
            end
        end
        cb({
            storeitem = storeitem
        })
    else
        TriggerServerEvent('jl-carboost:server:log', "The store is empty")
        cb({
            error = "The store is empty"
        })
    end
end)

RegisterCommand('testconfig', function()
    TriggerServerEvent('jl-testing')
end)

RegisterNUICallback('canStartContract', function (data, cb)
    if OnlineCops < Config.MinimumPolice then
        return cb({
            error = "To start the contract you need at least "..Config.MinimumPolice.." cops online"
        })
    end
    if isContractStarted then
        return cb({
            error = "You already start the contract"
        })
    else
        if data.type == 'vin' then
            QBCore.Functions.TriggerCallback('jl-carboost:server:vinmoney', function(result)
                if result and not result.error then
                    return cb({
                        canStart = true
                    })
                else
                    return cb({
                        error = result.error or Lang:t('error.not_enough_money', {
                            money = Config.Payment
                        })
                    })
                end
            end, data)
        else
            return cb({
                canStart = true
            })
        end
    end
end)

RegisterNUICallback('startcontract', function (data)
    local data = data
    if not isContractStarted then
        isContractStarted = true
        Tier = data.data.tier
        QBCore.Functions.TriggerCallback('jl-carboost:server:getContractData', function (result)
            if result then
                TriggerEvent('jl-carboost:client:spawnCar', result)
            else
                print("NO RESULT")
            end
        end, data)
    else
    end
end)

RegisterNUICallback('stopcontract', function (data)
    if isContractStarted then
        isContractStarted = false
        TriggerEvent('jl-carboost:client:stopContract')
    end
end)

RegisterNUICallback('checkout', function (data)
    QBCore.Functions.TriggerCallback('jl-carboost:server:canBuy', function (result)
        if result then
            local firstTime = false
            if not Config.BennysItems[1] then
                firstTime = true
            end
            local itemData = {
                items = data.list,
                price = data.total
            }
            for k, v in pairs(itemData.items) do
                Config.BennysItems[#Config.BennysItems+1] = {
                    item = {
                        name = v.item,
                        quantity = v.quantity
                    }
                }
            end
            TriggerServerEvent('jl-carboost:server:buyItem', itemData.price, Config.BennysItems, firstTime)
            SendNUIMessage({
                type="checkout",
                success = result
            })
        else
            SendNUIMessage({
                type="checkout",
                success = result
            })
        end
    end, data.total)
end)

RegisterNUICallback('setupboostapp', function (data, cb)
    QBCore.Functions.TriggerCallback('jl-carboost:server:getboostdata', function (result)
        if result then
            local carboostdata = result
            for k, v in pairs(carboostdata.contract) do
                carboostdata.contract[k].carname = GetLabelText(GetDisplayNameFromVehicleModel(v.car))
                carboostdata.contract[k].vinprice = Config.Tier[v.tier].vinprice
            end
            cb({
                setting = {
                    payment = Config.Payment,
                    amount = Config.VINPayment,
                },
                boostdata = carboostdata
            })
        else
            cb({
                error = 'No boost data'
            })
        end
    end, PlayerData.citizenid)
end)

RegisterNUICallback('sellcontract', function(data, cb)
    QBCore.Functions.TriggerCallback('jl-carboost:server:sellContract', function (result)
        if result then
            cb(result)
        else
            cb({
                error = 'No data'
            })
        end
    end, data)
end)

RegisterNUICallback('transfercontract', function (data, cb)
    QBCore.Functions.TriggerCallback('jl-carboost:server:transfercontract', function (result)
        if result and not result.error then
            cb({
                success = result
            })
        else
            cb({
                error = result.error or "Invalid player"
            })
        end
    end, data)
end)

RegisterNUICallback('joinqueue', function (data)
    TriggerEvent('jl-carboost:client:joinQueue', data)
end)

RegisterNUICallback('buycontract', function(data, cb)
    QBCore.Functions.TriggerCallback('jl-carboost:server:buycontract', function(result)
        if result then
            cb(result)
        end
    end, data)
end)

-- Event

RegisterNetEvent('jl-carboost:client:setConfig', function (data)
    Config.BennysItems = data
end)

RegisterNetEvent('jl-carboost:client:joinQueue', function (data)
    isJoinQueue = data.status
    local citizenid = PlayerData.citizenid
    TriggerServerEvent('jl-carboost:server:joinQueue', isJoinQueue, citizenid)
end)

RegisterNetEvent('jl-carboost:client:refreshQueue', function ()
    local citizenid = PlayerData.citizenid
    if isJoinQueue then
        TriggerServerEvent('jl-carboost:server:joinQueue', false, citizenid)
        Wait(2000)
        TriggerServerEvent('jl-carboost:server:joinQueue', true, citizenid)
    end
end)

RegisterNetEvent('jl-carboost:client:giveContract', function ()
    SendNUIMessage({
        type="givecontract",
        data = {
            
        }
    })
end)

RegisterNetEvent('jl-carboost:client:setupLaptop', function ()
    TriggerEvent('jl-carboost:client:sendLaptopConfig')
    TriggerEvent('jl-carboost:client:setupBoostingApp')
    TriggerServerEvent('jl-carboost:server:getBoostSale')
end)

RegisterNetEvent('jl-carboost:client:setupBoostingApp', function ()
    SendNUIMessage({
        type="setupboostingapp",
    })
end)

RegisterNetEvent('jl-carboost:client:sendLaptopConfig', function ()
    local config = PlayerData.metadata['laptopdata']
    SendNUIMessage({
        type = "config",
        config = config
    })
end)

RegisterNetEvent('jl-carboost:client:newContract', function ()
    TriggerServerEvent('jl-carboost:server:newContract', PlayerData.citizenid)
end)

RegisterNetEvent('jl-carboost:client:addContract', function (data)
    local vehName = GetLabelText(GetDisplayNameFromVehicleModel(data.car))
    data.carname = vehName
    data.vinprice = Config.Tier[data.tier].vinprice
    SendNUIMessage({
        type="addcontract",
        boost = data
    })
end)

RegisterNetEvent('jl-carboost:client:takeAll', function ()
    TriggerServerEvent('jl-carboost:server:takeAll', Config.BennysItems)
    Config.BennysItems = {}
end)

RegisterNetEvent('jl-carboost:client:takeItem', function (data)
    TriggerServerEvent('jl-carboost:server:takeItem', data.item, data.quantity)
    for k, v in pairs(Config.BennysItems) do
        if v.item.name == data.item then
           table.remove(Config.BennysItems, k)
        end
    end
    if Config.BennysItems[1] == nil then
        Config.BennysItems = {}
    end
    TriggerServerEvent('jl-carboost:server:updateBennysConfig', Config.BennysItems)
end)

RegisterNetEvent('jl-carboost:client:openMenu', function ()
    if Config.BennysItems[1] then
        local menu = {
            {
                header = "| Post OP |",
                isMenuHeader = true
            },
        }
        for _, v in pairs(Config.BennysItems) do
            local item = v.item
            local name = tostring(item.name)

            menu[#menu+1] = {
                header = QBCore.Shared.Items[item.name]["label"],
                id = item.name,
                txt = "You have: "..item.quantity,
                params = {
                    event = "jl-carboost:client:takeItem",
                    args = {
                            item = item.name,
                            quantity = item.quantity
                    }
                }    
            }
        end
        menu[#menu+1] = {
            header = "Take all",
            id = "take all",
            txt = "Take all the items",
            params = {
                event = "jl-carboost:client:takeAll"
            }

        }
        exports['qb-menu']:openMenu(menu)
    else
        QBCore.Functions.Notify(Lang:t("error.empty_post"), "error")
    end
end)

RegisterNetEvent('jl-carboost:client:spawnCar', function(data)
    QBCore.Functions.TriggerCallback('jl-carboost:server:spawnCar', function(result)
        if result then
            local zoneName = GetNameOfZone(result.spawnlocation)
            local streetlabel = GetLabelText(zoneName)
            Wait(5000)
            createRadiusBlips(result.spawnlocation)
            carID = result.networkID
            carmodel = result.car
            TriggerServerEvent('qb-phone:server:sendNewMail', {
                sender = "Unknown",
                subject = "Car Location",
                message = "Hey this is the car location, its in near "..streetlabel,
             })
             TriggerEvent('jl-carboost:client:startBoosting', result)
        end
    end, data)
end)

RegisterNetEvent('jl-carboost:client:startBoosting', function (data)
    local data = data
    ContractID = data.id
    local modified = false
    CreateThread(function ()
        while true do
            Wait(5000)
            if carID ~= nil then
                if DoesEntityExist(NetworkGetEntityFromNetworkId(carID)) then
                    carSpawned = NetworkGetEntityFromNetworkId(carID)
                    if not modified then
                        QBCore.Functions.SetVehicleProperties(carSpawned, VehProp)
                        modified = true
                    end
                    local carcoords = GetEntityCoords(carSpawned)
                    local playerCoords = GetEntityCoords(PlayerPedId())
                    local dist = #(playerCoords - carcoords)
                    if dist <= 5.0 then
                        if blipDisplay ~= nil then
                            RemoveBlip(blipDisplay)
                            TriggerEvent('jl-carboost:client:playerInVehicle', data)
                            break
                        end
                    end
                end
            end
        end
    end)
end)

RegisterNetEvent('jl-carboost:client:checkvin', function ()
    local vehicle = QBCore.Functions.GetClosestVehicle()
    if vehicle ~= 0 then
        local vehPos = GetEntityCoords(vehicle)
        local PlayerPos = GetEntityCoords(PlayerPedId())
        if #(PlayerPos - vehPos) <= 5.0 then
            local networkID = NetworkGetNetworkIdFromEntity(vehicle)
            if GetVehicleDoorLockStatus(vehicle) == 1 then
                    QBCore.Functions.Progressbar('check_vin', 'Checking VIN Number', 6000, false, true, { -- Name | Label | Time | useWhileDead | canCancel
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                        animDict = '"anim@amb@clubhouse@tutorial@bkr_tut_ig3@"@',
                        anim = 'machinic_loop_mechandplayer',
                        flags = 16,
                    }, {}, {}, function() 
                        QBCore.Functions.TriggerCallback('jl-carboost:server:checkvin', function(result)
                            if result and result.success then
    
                                QBCore.Functions.Notify(result.message, "primary")
                               
                            else
                                QBCore.Functions.Notify("Hmm you can't found the VIN", "error")
                            end
                        end, networkID)
                        ClearPedTasks(PlayerPedId())
                    end, function() -- Play When Cancel
                        QBCore.Functions.Notify("Cancelled", "error")
                        ClearPedTasks(PlayerPedId())
                    end)
                else
                    QBCore.Functions.Notify("The vehicle is locked", "error")
                end
            else
                QBCore.Functions.Notify("No vehicle nearby", "error")
            end
        end
end)

RegisterNetEvent('jl-carboost:client:vinscratch', function(veh)
    local ID = NetworkGetNetworkIdFromEntity(veh)
    QBCore.Functions.Progressbar('vin_scratching', 'Scratching VIN', 7000, false, true, { -- Name | Label | Time | useWhileDead | canCancel
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = '"anim@amb@clubhouse@tutorial@bkr_tut_ig3@"@',
        anim = 'machinic_loop_mechandplayer',
        flags = 1,
    }, {}, {}, function() -- Play When Done
        QBCore.Functions.TriggerCallback('jl-carboost:server:checkvin', function(result)
            if result and result.owner == PlayerData.citizenid then
                if result.vinscratch == 1 then
                    return QBCore.Functions.Notify('You already scratch this vehicle VIN', 'error')
                end
            else
                QBCore.Functions.Notify('VIN Scratched, you can change your plate number', 'primary')
                local vehProp = QBCore.Functions.GetVehicleProperties(veh)
                TriggerServerEvent('jl-carboost:server:vinscratch', ID, vehProp, carmodel)
                TriggerEvent('jl-carboost:client:deleteContract')
                Scratching()
            end
        end, ID)
       
        ClearPedTasks(PlayerPedId())
    end, function() -- Play When Cancel
        --Stuff goes here
        ClearPedTasks(PlayerPedId())
    end)
end)
        
RegisterNetEvent('jl-carboost:client:playerInVehicle', function (data)
    local data = data
    CreateThread(function ()
        while true do
            Wait(100)
            if IsPedInVehicle(PlayerPedId(), carSpawned, false) then
                if IsVehicleAlarmActivated(carSpawned) or IsVehicleEngineStarting(carSpawned) or GetIsVehicleEngineRunning(carSpawned) then       
                    spawnAngryPed(data.npc)
                    TriggerEvent('jl-carboost:client:trackersReady', data)
                    break
                end
            end
        end
    end)
end)

RegisterNetEvent('jl-carboost:client:trackersReady', function (data)
    CreateThread(function ()
        while true do
            Wait(1000)
            if GetIsVehicleEngineRunning(carSpawned) then
                RegisterCar(carSpawned)
                BoostingAlert()
                TriggerEvent('jl-carboost:client:startTracker', data)
                break
            end
        end
    end)
end)

RegisterNetEvent('jl-carboost:client:startTracker', function(data)
    local veh = Entity(carSpawned)
    CreateThread(function ()
        while true do
            Wait(5000)
            if not veh.state.tracker then
                TriggerEvent("jl-carboost:client:bringtoPlace", data)
                break
            end
        end
    end)
end)

RegisterNetEvent("jl-carboost:client:bringtoPlace", function (data)
   
    if data.type == 'vin' then
        -- [todo] write vinscratch logic here
        local pz = Config.ScratchingPoint[math.random(1, #Config.ScratchingPoint)]
        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = "Unknown",
            subject = "VIN Scratching",
            message = "You can scratch your VIN here",
        })
        dropBlip = CreateBlip(pz.coords, 'VIN Scratch', 255, 1)
        scratchpoint = BoxZone:Create(pz.coords, pz.length, pz.width, {
            name=pz.name,
            heading=pz.heading,
            -- debugPoly=true,
            minZ=pz.minZ,
            maxZ=pz.maxZ
        })
        scratchpoint:onPointInOut(function ()
            return GetEntityCoords(carSpawned)
        end, function (isPointInside, point)
            inscratchPoint = isPointInside
            if inscratchPoint then
                QBCore.Functions.Notify(Lang:t("info.in_scratch"))
            else
                QBCore.Functions.Notify(Lang:t("info.not_in_scratch"))
            end
        end)
    else
        local polyZone = Config.DropPoint[math.random(1, #Config.DropPoint)]
        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = "Unknown",
            subject = "Drop point",
            message = "Hey this is the drop point, you can drop your car here, I'm sending you the coord on gps",
        })
        dropBlip = CreateBlip(polyZone.coords, "Drop Point", 225, 1)
        SetNewWaypoint(polyZone.coords)
        Wait(100)
        zone = BoxZone:Create(polyZone.coords, polyZone.length, polyZone.width, {
            name=polyZone.name,
            heading=polyZone.heading,
            -- debugPoly=true,
            minZ=polyZone.minZ,
            maxZ=polyZone.maxZ
        })
        zone:onPointInOut(function ()
            return GetEntityCoords(carSpawned)
        end, function (isPointInside, point)
            inZone = isPointInside
            if inZone then
                QBCore.Functions.Notify(Lang:t("info.car_inzone"))
            end
        end)
        CreateThread(function ()
            while true do
                Wait(100)
                if inZone then
                    if DoesEntityExist(carSpawned) then
                        if not IsPedInVehicle(PlayerPedId(), carSpawned, false) then
                            local playerCoords = GetEntityCoords(PlayerPedId())
                            local carcoords = GetEntityCoords(carSpawned)
                            local dist = #(playerCoords - carcoords)
                            if dist >= 30.0 then
                                finishBoosting(data)
                                break
                            end
                        end
                    end
                end
            end
        end)
    end
end)

RegisterNetEvent('jl-carboost:client:finishBoosting', function (data)

end)

RegisterNetEvent('jl-carboost:client:updateProggress', function (data)
    local data = {
        rep = PlayerData.metadata['carboostrep'],
        boostclass = PlayerData.metadata['carboostclass'],
        isNextLevel = data
    }
    SendNUIMessage({
        type = "updateProggress",
        boost = data
    })
end)

RegisterNetEvent('jl-carboost:client:deleteContract', function ()
    SendNUIMessage({
        type = "removeContract",
        id = ContractID
    })
    TriggerServerEvent('jl-carboost:server:deleteContract', ContractID)
end)

RegisterNetEvent('jl-carboost:client:playerUnload', function()
    if carSpawned then
        DeleteVehicle(carSpawned)
    end
    TriggerServerEvent('jl-carboost:server:joinQueue', false, PlayerData.citizenid)
end)

RegisterNetEvent('jl-carboost:client:failedBoosting', function ()
    if zone then
        zone:destroy()
        zone = nil
        inZone = false
    elseif scratchpoint then
        scratchpoint:destroy()
        scratchpoint = nil
        inscratchPoint = false
    end
    RemoveBlip(blipDisplay)
    RemoveBlip(dropBlip)
    DeleteEntity(carSpawned)
    carSpawned, carID, carmodel = nil, nil, nil
    blipDisplay, dropBlip = nil, nil
    isContractStarted = false
    QBCore.Functions.Notify(Lang:t("error.no_car"), "error")
    TriggerEvent('jl-carboost:client:refreshQueue')
    TriggerEvent('jl-carboost:client:deleteContract')
end)

RegisterNetEvent('jl-carboost:client:openLaptop', function ()
    SetDisplay(not display)
end)

RegisterNetEvent('jl-carboost:client:loadBoostStore', function(data)
    local cdata = data
    local saleData = {}
    for k, v in pairs(cdata) do
        local data = json.decode(v.data)
        saleData[#saleData+1] = {
            id = v.id,
            owner = data.owner,
            carname = GetLabelText(GetDisplayNameFromVehicleModel(data.car)),
            expire = v.expire,
            plate = data.plate,
            tier = data.tier,
            price = v.price
        }
    end
    SendNUIMessage({
        type = "setupboostingstore",
        store = saleData
    })
end)

RegisterNetEvent('jl-carboost:client:refreshContract', function ()
    QBCore.Functions.TriggerCallback('jl-carboost:server:getContractData')
    SendNUIMessage({
        type = "refreshContract",
    })
end)

RegisterNetEvent('jl-carboost:client:newContractSale', function(data)
    local data = data 
    data.carname = GetLabelText(GetDisplayNameFromVehicleModel(data.car))
    SendNUIMessage({
        type = "newContractSale",
        sale = data
    })
end)

RegisterNetEvent('jl-carboost:client:contractBought', function(id)
    SendNUIMessage({
        type = "contractbought",
        id = id
    })
end)

RegisterNetEvent('jl-carboost:client:useHackingDevice', function ()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if IsPedInVehicle(playerPed, vehicle) then
        if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), 0) ~= 0 then
            if cooldown then
                return QBCore.Functions.Notify(Lang:t("error.cannot_use"), "error")
            end
            StartHacking(vehicle)
            cooldown = true
            Wait(5000)
            cooldown = false
        else
            return QBCore.Functions.Notify(Lang:t('error.not_seat'), "error")
        end
    else
        QBCore.Functions.Notify(Lang:t("error.not_on_vehicle"), "error")
    end
end)

RegisterNetEvent('jl-carboost:client:fakeplate', function()
    local veh = QBCore.Functions.GetClosestVehicle()
    local vehID = NetworkGetNetworkIdFromEntity(veh)
    local playerpos = GetEntityCoords(PlayerPedId())
    local front = GetOffsetFromEntityInWorldCoords(veh, 0, -2.5, 0)
    local back = GetOffsetFromEntityInWorldCoords(veh, 0, 2.5, 0)
    local distFront = #(playerpos - front)
    local distBack = #(playerpos - back)
    if veh ~= 0 and not IsPedInAnyVehicle(PlayerPedId()) then
        if distFront < 2.0 or distBack < 2.0 then 
            QBCore.Functions.TriggerCallback('jl-carboost:server:checkvin', function (result)
                if result then
                    if result.owner == PlayerData.citizenid then
                        QBCore.Functions.Progressbar('change_plate', 'Changing the plate', 8000, false, true, { -- Name | Label | Time | useWhileDead | canCancel
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {
                            animDict = '"anim@amb@clubhouse@tutorial@bkr_tut_ig3@"@',
                            anim = 'machinic_loop_mechandplayer',
                            flags = 1,
                        }, {}, {}, function() -- Play When Done
                            TriggerEvent('jl-carboost:client:setPlate', vehID)
                            ClearPedTasks(PlayerPedId())
                        end, function() -- Play When Cancel
                            ClearPedTasks(PlayerPedId())
                            --Stuff goes here
                        end)
                    else
                        QBCore.Functions.Notify(Lang:t("error.not_owner"), "error")
                    end
                end
            end, vehID)
        else
            QBCore.Functions.Notify(Lang:t("error.not_plate"), "error")
        end
    end
end)

function RandomPlate()
	local random = tostring(QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(2)):upper()
   return random
end

RegisterNetEvent('jl-carboost:client:setPlate', function (vehID)
    local veh = NetworkGetEntityFromNetworkId(vehID)
    if veh and veh ~= 0 then
        local plate = QBCore.Functions.GetPlate(veh)
        local newPlate = RandomPlate()
        SetVehicleNumberPlateText(veh, newPlate)
        TriggerServerEvent('jl-carboost:server:setPlate', plate, newPlate)
        QBCore.Functions.Notify(Lang:t("success.plate_changed", {
            plate = newPlate
        }), "success")
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items["fake_plate"], "remove")
        TriggerServerEvent("QBCore:Server:RemoveItem", "fake_plate", 1)
        TriggerEvent('vehiclekeys:client:SetOwner', newPlate)
    end
end)

-- Threads
CreateThread(function ()
    while display do
        Wait(0)
        DisableControlAction(0, 1, display)
        DisableControlAction(0, 2, display)
        DisableControlAction(0, 142, display)
        DisableControlAction(0, 18, display)
        DisableControlAction(0, 322, display)
        DisableControlAction(0, 106, display)
    end
end)

CreateThread(function ()
    if LocalPlayer.state['isLoggedIn'] then
        Wait(5000)
        TriggerServerEvent('jl-carboost:server:getItem')
        TriggerEvent('jl-carboost:client:setupLaptop')
    end
    CreateBlip(vector3(1185.2, -3303.92, 6.92), "Post OP", 473)
end)



-- Prevent the boosting still running when the car is destroyed / disappeared for no reason
CreateThread(function ()
    while true do
        Wait(1000)
        if carSpawned ~= nil and not DoesEntityExist(carSpawned) then
            if carSpawned ~= 0 then
                TriggerEvent('jl-carboost:client:failedBoosting')
            end
        end
    end
end)

-- exports
exports['qb-target']:AddBoxZone("carboost:takeItem", vector3(1185.14, -3304.01, 7.1), 2, 2, {
	name = "BennysTakePoint",
    heading=0,
    minZ=5.1,
    maxZ=9.1,
	-- debugPoly = true,
    scale= {1.0, 1.0, 1.0},
    }, {
	options = {
		{
            type = "client",
            event = "jl-carboost:client:openMenu",
			icon = "fas fa-solid fa-box",
			label = "Take item",
		},
	},
	distance = 3.0
})


exports['qb-target']:AddTargetBone('windscreen', {
    options = {
        {
            icon = "fas fa-tally",
            label = "Scratch VIN",
            canInteract = function ()
                return inscratchPoint
            end,
            action = function (entity)
                TriggerEvent('jl-carboost:client:vinscratch', entity)
            end
        },
    },
    distance = 1.2
})

exports['qb-target']:AddTargetBone('windscreen', {
    options = {
        {
            type = "client",
            icon = "fas fa-solid fa-car",
            label = "Check VIN",
            event = "jl-carboost:client:checkvin",
            job = "police",
        },
    },
    distance = 2
})

AddEventHandler('onResourceStop', function(resource)
   if resource == GetCurrentResourceName() then
      if DoesEntityExist(carSpawned) then
          DeleteEntity(carSpawned)
      end
   end
end)

