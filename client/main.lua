local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData()
local isPoliceCalled = false
local isJoinQueue = false
local carSpawned
local carID
local display = false
local zone
local inZone = false
local blipDisplay
local boostingCar
local laptopdict = "amb@code_human_in_bus_passenger_idles@female@tablet@base"
local laptopanim = "base"
local carInzone

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    TriggerServerEvent('jl-carboost:server:getItem')
    TriggerServerEvent('jl-carboost:server:getBoostData')
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

local function CreateBlip(coords, name, sprite)
	local blip = AddBlipForCoord(coords)
	SetBlipSprite(blip, sprite)
	SetBlipScale(blip, 0.6)
	SetBlipColour(blip, 4)
	SetBlipDisplay(blip, 4)
    SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(name)
	EndTextCommandSetBlipName(blip)
	return blip
end

local function spawnAngryPed()
    local npc = {
        'a_m_m_beach_01',
        'a_m_m_og_boss_01',
        'a_m_m_soucent_01',
    }
    local x,y,z = vector3(1177.08, -3308.74, 6.03)
    local x2, y2, z2 = vector3(1173.66, -3305.24, 5.9)
    for k, v in pairs(npc) do
        local hash = GetHashKey(v)
        RequestModel(hash)
        while not HasModelLoaded(v) do
            Wait(50)
        end
        local ped = CreatePed(1, hash, x, y, z, 0.0, true, true)
        SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(ped), true)
        SetPedAccuracy(ped, 60)
        SetPedRelationshipGroupHash(ped, GetHashKey("AMBIENT_GANG_WEICHENG"))
        SetPedRelationshipGroupDefaultHash(ped, GetHashKey("AMBIENT_GANG_WEICHENG"))
        SetPedCombatAttributes(ped, 46, true)
        GiveWeaponToPed(ped, "WEAPON_COMBATPISTOL", -1, false, true)
        SetPedDropsWeaponsWhenDead(ped, false)
        TaskCombatHatedTargetsAroundPed(ped, 100.0, 0)
        Wait(1)
        TaskGotoEntityAiming(ped, PlayerPedId(), 10.0, 50.0)
        TaskShootAtEntity(ped, PlayerPedId(), -1, -1)
    end
end

RegisterCommand("givecontract", function ()
    TriggerEvent('jl-carboost:client:newContract')
end)

RegisterCommand('spawnped', function ()
    spawnAngryPed()
end)

RegisterCommand("testanim", function ()
    RequestAnimDict(laptopdict)
    while not HasAnimDictLoaded(laptopdict) do Wait(100) end

    local ped = PlayerPedId()
    
    TaskPlayAnim(ped, laptopdict, laptopanim, 8.0, 8.0, -1, 0, 0, false, false, false)
end)

RegisterCommand('testimage', function()
    for k, v in pairs(Config.BennysSell) do
       print(QBCore.Shared.Items[v.item]["label"])
    end
end)

RegisterCommand('testconfig', function()
    print(json.encode(carSpawned))
end)

-- NUI
RegisterNUICallback('openlaptop', function (data)
    SetDisplay(false)
end)

RegisterNUICallback('exit', function (data)
    SetDisplay(false)
end)

RegisterNUICallback('loadstore', function (data, cb)
    local storeitem = Config.BennysSell
    if storeitem then
        cb({
            storeitem = storeitem
        })
    else
        cb({
            error = 'No store item'
        })
    end
end)

RegisterNUICallback('startcontract', function (data)
    TriggerEvent('jl-carboost:client:spawnCar', data)

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
            cb({
                boostdata = result
            })
        else
            cb({
                error = 'No boost data'
            })
        end
    end, PlayerData.citizenid)
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

RegisterNetEvent('jl-carboost:client:giveContract', function ()
    SendNUIMessage({
        type="givecontract",
        data = {
            
        }
    })
end)

RegisterNetEvent('jl-carboost:client:setupBoostingApp', function (config)
    print(json.encode(config))
    SendNUIMessage({
        type="setupboostingapp",
        config = config
    })
end)

RegisterNetEvent('jl-carboost:client:newContract', function ()
    TriggerServerEvent('jl-carboost:server:newContract', PlayerData.citizenid)
end)

RegisterNetEvent('jl-carboost:client:addContract', function (data)
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
        local data = {
            {
                header = "| Post OP |",
                isMenuHeader = true
            },
        }
        for _, v in pairs(Config.BennysItems) do
            local item = v.item
            data[#data+1] = {
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
        data[#data+1] = {
            header = "Take all",
            id = "take all",
            txt = "Take all the items",
            params = {
                event = "jl-carboost:client:takeAll"
            }

        }
        exports['qb-menu']:openMenu(data)
    else
        QBCore.Functions.Notify("You don't have anything in here...", "error")
    end
end)

local function createRadiusBlips(x, y, z)
    local blip = AddBlipForRadius(x,y, z, 100.0)
    SetBlipHighDetail(blip, true)
    SetBlipColour(blip, 44)
    SetBlipAsShortRange(blip, true)
    blipDisplay = blip
end


RegisterNetEvent('jl-carboost:client:spawnCar', function(data)
    QBCore.Functions.TriggerCallback('jl-carboost:server:spawnCar', function(result)
        if result then
            local zone = GetNameOfZone(result.coords.x, result.coords.y, result.coords.z)
            local streetlabel = GetLabelText(zone)
            Wait(5000)
            createRadiusBlips(result.coords.x, result.coords.y, result.coords.z)
            carID = result.networkID
            TriggerServerEvent('qb-phone:server:sendNewMail', {
                sender = "Unknown",
                subject = "Car Location",
                message = "Hey this is the car location, its in near "..streetlabel,
                button = {
                    enabled = true,
                }
             })
        else
            print('no result')
        end
    end, data)
end)

RegisterNetEvent('jl-carboost:client:startBoosting', function ()
    CreateThread(function ()
        while true do
            Wait(100)
            if inZone then
                if carSpawned ~= nil then        
                    local player = GetEntityCoords(PlayerPedId())
                    local carcoords = GetEntityCoords(carSpawned)
                    local dist = #(player - carcoords)
                    if dist >= 30.0 then
                        TriggerEvent('jl-carboost:client:finishBoosting')
                        break
                    end
                end
            end
        end
    end)
end)

RegisterNetEvent('jl-carboost:client:bringtoPlace', function ()
    TriggerServerEvent('qb-phone:server:sendNewMail', {
        sender = "Unknown",
        subject = "Drop point",
        message = "Hey this is the drop point, you can drop your car here, I'm sending you the coord on gps",
    })
    SetNewWaypoint(1564.08, -2164.13)
    Wait(100)
    zone = BoxZone:Create(vector3(1564.08, -2164.13, 77.58), 5, 7, {
        name="deliverypoint1",
        heading=260,
        debugPoly=true,
        minZ=74.98,
        maxZ=78.98
    })
    zone:onPointInOut(function ()
        return GetEntityCoords(carSpawned)
    end, function (isPointInside, point)
        inZone = isPointInside
        if inZone then
            QBCore.Functions.Notify("Okay, leave the car there, I'll pay you later", "success")
        end
    end)

    TriggerEvent('jl-carboost:client:startBoosting')
end)

RegisterNetEvent('jl-carboost:client:finishBoosting', function ()
    DeleteEntity(carSpawned)
    carSpawned = nil
    zone:destroy()
    zone = nil
    TriggerServerEvent('jl-carboost:server:finishBoosting')
end)

RegisterNetEvent('jl-carboost:client:openLaptop', function ()
    SetDisplay(not display)
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
    while carInzone do
        Wait(100)
        print("CAR INZONE")
    end
end)

CreateThread(function ()
    while true do
        Wait(100)
        if carID ~= nil then
            carSpawned = NetworkGetEntityFromNetworkId(carID)
            if carSpawned ~= 0 or carSpawned ~= nil then
                local carcoords = GetEntityCoords(carSpawned)
                local playerCoords = GetEntityCoords(PlayerPedId())
                local dist = #(playerCoords - carcoords)
                if dist <= 5.0 then
                    if blipDisplay ~= nil then
                        RemoveBlip(blipDisplay)
                        break
                    end
                end
            end 
        end
    end
end)

CreateThread(function ()
    while true do
        Wait(100)
        if carSpawned ~= nil then
            if IsPedInVehicle(PlayerPedId(), carSpawned, true) then
                -- This just wait time..
                Wait(5000)
                TriggerEvent('jl-carboost:client:bringtoPlace')
                break
            end
        end
    end
end)

CreateThread(function ()
    if LocalPlayer.state['isLoggedIn'] then
        TriggerServerEvent('jl-carboost:server:getItem')
        TriggerServerEvent('jl-carboost:server:getBoostData')
    end
    CreateBlip(vector3(1185.2, -3303.92, 6.92), "Post OP", 473)
end)

-- exports
exports['qb-target']:AddBoxZone("carboost:takeItem", vector3(1185.14, -3304.01, 7.1), 2, 2, {
	name = "BennysTakePoint",
    heading=0,
    minZ=5.1,
    maxZ=9.1,
	-- debugPoly = true,
    scale= {1.0, 1.0,1.0},
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

