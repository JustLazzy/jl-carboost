local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData()
local isJoinQueue, isContractStarted = false, false
local carSpawned, carID = nil, nil
local display = false
local zone, inZone, blipDisplay, dropBlip, cooldown = nil, false, nil, nil, false
local laptopdict = "amb@code_human_in_bus_passenger_idles@female@tablet@base"
local laptopanim = "base"

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    TriggerServerEvent('jl-carboost:server:getItem')
    TriggerEvent('jl-carboost:client:setupBoostingApp')
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    PlayerData = val
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function ()
    TriggerServerEvent('jl-carboost:server:removeData', PlayerData.citizenid)  
    PlayerData = {}
    Config.BennysItems = {}
end)

-- function
function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type="openlaptop",
        status = bool
    })
end

local function createRadiusBlips(x, y, z)
    local blip = AddBlipForRadius(x,y, z, 100.0)
    SetBlipHighDetail(blip, true)
    SetBlipColour(blip, 44)
    SetBlipAsShortRange(blip, true)
    SetBlipAlpha(blip, 50)
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
        local peds = {}
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
            peds[#peds+1] = ped
            SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(ped), true)
            SetPedAccuracy(ped, 30)
            SetPedRelationshipGroupHash(ped, GetHashKey("AMBIENT_GANG_WEICHENG"))
            SetPedRelationshipGroupDefaultHash(ped, GetHashKey("AMBIENT_GANG_WEICHENG"))
            SetPedCombatAttributes(ped, 46, true)
            SetPedCombatAbility(ped, 1)
            SetPedCombatAttributes(ped, 0, true)
            GiveWeaponToPed(ped, "WEAPON_PISTOL", -1, false, true)
            SetPedDropsWeaponsWhenDead(ped, false)
            SetPedCombatRange(ped, 1)
            SetPedFleeAttributes(ped, 0, 0)
            SetPedConfigFlag(ped, 58, true)
            SetPedConfigFlag(ped, 75, true)
            TaskGotoEntityAiming(ped, PlayerPedId(), 4.0, 50.0)
        end
        Wait(2000)
        for k, v in pairs(peds) do
            TaskShootAtEntity(v, PlayerPedId(), -1)
        end
    end
end

local function StartHacking(vehicle)
    local veh = Entity(vehicle)
    local trackerLeft = veh.state.trackerLeft
    if veh.state.tracker then
        if not veh.state.hacked then
            local success = exports['boostinghack']:StartHack()
            if success then
                local randomSeconds = math.random(30)
                trackerLeft = trackerLeft - 1
                veh.state.trackerLeft = trackerLeft
                veh.state.hacked = true
                if trackerLeft == 0 then
                    veh.state.tracker = false
                    veh.state.hacked = true
                    return QBCore.Functions.Notify("You have successfully disable the tracker")
                else
                    QBCore.Functions.Notify("You turn off the tracker for "..randomSeconds.." seconds, "..trackerLeft.." left ", "success")
                end
                CreateThread(function ()
                    Wait(randomSeconds*1000)
                    veh.state.hacked = false
                end)
            else
                QBCore.Functions.Notify("You failed to disable the tracker", "error")
            end
        else
            print("ALREADY HACKED")
        end
    else
        QBCore.Functions.Notify("This vehicle doesn't have a tracker", "error")
    end
    -- Entity(vehicle).state.hacked = true
end

local function RegisterCar(vehicle)
    local veh = Entity(vehicle)
    veh.state.tracker = true
    veh.state.trackerLeft = 2
    veh.state.hacked = false
end

local function BoostingAlert()
    if Config.Alert == 'qb-dispatch' then
        TriggerEvent('dispatch:carboost', carID)
    elseif Config.Alert == 'linden_outlawalert' then

    else
        TriggerEvent('jl-carboost:client:notifyBoosting', carID)
    end
end

-- NUI
RegisterNUICallback('openlaptop', function (data)
    SetDisplay(false)
end)

RegisterNUICallback('exit', function (data)
    SetDisplay(false)
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
                        image = v.image,
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

RegisterNUICallback('canStartContract', function (data, cb)
    if isContractStarted then
        cb({
            error = "You already start the contract"
        })
    else
        cb({
            canStart = true
        })
    end
end)

RegisterNUICallback('startcontract', function (data)
    local data = data
    if not isContractStarted then
        isContractStarted = true
        QBCore.Functions.TriggerCallback('jl-carboost:server:getContractData', function (result)
            if result then
                -- print(json.encode(result))
                TriggerEvent('jl-carboost:client:spawnCar', result)
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
            end
            cb({
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
            cb({
                success = result
            })
        else
            cb({
                error = 'No boost data'
            })
        end
    end, data)
end)

RegisterNUICallback('joinqueue', function (data)
    TriggerEvent('jl-carboost:client:joinQueue', data)
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

RegisterNetEvent('jl-carboost:client:setupBoostingApp', function ()
    SendNUIMessage({
        type="setupboostingapp",
    })
end)

RegisterNetEvent('jl-carboost:client:newContract', function ()
    TriggerServerEvent('jl-carboost:server:newContract', PlayerData.citizenid)
end)

RegisterNetEvent('jl-carboost:client:addContract', function (data)
    local vehName = GetLabelText(GetDisplayNameFromVehicleModel(data.car))
    data.carname = vehName
    print(json.encode(data))
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
            -- print(#menu+1)
            print(json.encode(QBCore.Shared.Items[name]))
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
        QBCore.Functions.Notify("You don't have anything in here...", "error")
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
            TriggerServerEvent('qb-phone:server:sendNewMail', {
                sender = "Unknown",
                subject = "Car Location",
                message = "Hey this is the car location, its in near "..streetlabel,
             })
             TriggerEvent('jl-carboost:client:startBoosting', result)
             print(json.encode(result))
        else
            print('no result')
        end
    end, data)
end)

RegisterNetEvent('jl-carboost:client:startBoosting', function (data)
    local data = data
    local modified = false
    CreateThread(function ()
        while true do
            Wait(5000)
            if carID ~= nil then
                -- carSpawned = NetworkGetEntityFromNetworkId(carID)
                if DoesEntityExist(NetworkGetEntityFromNetworkId(carID)) then
                    carSpawned = NetworkGetEntityFromNetworkId(carID)
                    if not modified then
                        QBCore.Functions.SetVehicleProperties(carSpawned, props)
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
    data = data
 
    local polyZone = Config.DropPoint[math.random(1, #Config.DropPoint)]
    TriggerServerEvent('qb-phone:server:sendNewMail', {
        sender = "Unknown",
        subject = "Drop point",
        message = "Hey this is the drop point, you can drop your car here, I'm sending you the coord on gps",
    })

    dropBlip = CreateBlip(polyZone.coords, "Drop Point", 225, 66)
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
            QBCore.Functions.Notify("Okay, leave the car there, I'll pay you later", "success")
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
                            TriggerEvent('jl-carboost:client:finishBoosting', data)
                            break
                        end
                    end
                end
            end
        end
    end)
end)

RegisterNetEvent('jl-carboost:client:finishBoosting', function (data)
    DeleteEntity(carSpawned)
    RemoveBlip(dropBlip)
    carSpawned = nil
    zone:destroy()
    zone = nil
    inZone = false
    isContractStarted = false
    TriggerServerEvent('jl-carboost:server:finishBoosting', data)
    Wait(100)
    TriggerEvent('jl-carboost:client:deleteContract', data)
    Wait(1000)
    TriggerEvent('jl-carboost:client:refreshQueue')
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

RegisterNetEvent('jl-carboost:client:deleteContract', function (data)
    local id = data.id
    SendNUIMessage({
        type = "removeContract",
        id = id
    })
    TriggerServerEvent('jl-carboost:server:deleteContract', id)
end)


RegisterNetEvent('jl-carboost:client:failedBoosting', function ()
    carSpawned = nil
    carID = nil
    RemoveBlip(dropBlip)
    if zone then
        zone:destroy()
        zone = nil
        inZone = false
    end
    QBCore.Functions.Notify("Something went wrong, contact your developer", "error")
    TriggerEvent('jl-carboost:client:refreshContract')
end)

RegisterNetEvent('jl-carboost:client:openLaptop', function ()
    SetDisplay(not display)
end)

RegisterNetEvent('jl-carboost:client:refreshContract', function ()
    QBCore.Functions.TriggerCallback('jl-carboost:server:getContractData')
    SendNUIMessage({
        type = "refreshContract",
    })
end)

RegisterNetEvent('jl-carboost:client:useHackingDevice', function ()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if IsPedInVehicle(playerPed, vehicle) then

        -- if GetPedInVehicleSeat(vehicle, 2) then   
            if cooldown then
                return QBCore.Functions.Notify("You can't use this device for now", "error")
            end
            StartHacking(vehicle)
            cooldown = true
            Wait(5000)
            cooldown = false
        -- else
        --     return QBCore.Functions.Notify("You need to be in front seat passenger to do this", "error")
        -- end
    else
        QBCore.Functions.Notify("You need to be in a vehicle", "error")
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
        TriggerEvent('jl-carboost:client:setupBoostingApp')
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

AddEventHandler('onResourceStop', function(resource)
   if resource == GetCurrentResourceName() then
      if DoesEntityExist(carSpawned) then
          DeleteEntity(carSpawned)
      end
   end
end)