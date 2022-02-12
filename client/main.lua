local QBCore = exports['qb-core']:GetCoreObject()
local isPoliceCalled = false
local isCarSpawned
local display = false
local inZone = false

-- function
function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type="openlaptop",
        status = bool
    })
end

function CreateBlip(coords)
	local blip = AddBlipForCoord(coords)
	SetBlipSprite(blip, 473)
	SetBlipScale(blip, 0.6)
	SetBlipColour(blip, 4)
	SetBlipDisplay(blip, 4)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Pick Up")
	EndTextCommandSetBlipName(blip)
	return blip
end

RegisterCommand('testimage', function()
    for k, v in pairs(Config.BennysSell) do
       print(QBCore.Shared.Items[v.item]["image"])
    end
end)

RegisterCommand('testconfig', function()
    print(json.encode(Config.BennysItem))
end)

-- NUI
RegisterNUICallback('openlaptop', function (data)
    print(data.text)
    SetDisplay(false)
end)

RegisterNUICallback('err', function (data)
    print(data.error)
    SetDisplay(false)
end)

RegisterNUICallback('exit', function (data)
    print('EXIT')
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

RegisterNUICallback('checkout', function (data)
    
    QBCore.Functions.TriggerCallback('jl-carboost:server:canBuy', function (result)
        if result then
            print(result)
            local itemData = {
                items = data.list,
                price = data.total
            }
            TriggerServerEvent('jl-carboost:server:buyItem', itemData)
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


-- Event
RegisterNetEvent('jl-carboost:client:setConfig', function (data)
    Config.BennysItem = data
end)
RegisterNetEvent('jl-carboost:client:spawnCar', function()
    QBCore.Functions.TriggerCallback('jl-carboost:server:spawnCar', function(result)
        if result then
            local streetname = GetStreetNameFromHashKey(GetStreetNameAtCoord(result.coords.x, result.coords.y, result.coords.z))
            print(streetname)
            SetNewWaypoint(result.coords.x, result.coords.y)
            TriggerServerEvent('qb-phone:server:sendNewMail', {
                sender = "Unknown",
                subject = "Car Location",
                message = "Hey this is the car location, its in near "..streetname,
                button = {
                    enabled = true,
                }
             })
        else
            print('no result')
        end
    end)
end)

RegisterNetEvent('jl-carboost:client:startBoosting', function ()
    
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
    local Zone = BoxZone:Create(vector3(1180.81, -3306.35, 6.03), 10, 10, {
        name="jl-carboost",
        heading=0,
        debugPoly=true,
        minZ=4.83,
        maxZ=8.83
      })
      Zone:onPlayerInOut(function (isPointInside)
          if isPointInside then
            inZone = true
          else
            inZone = false
          end
      end)
      Wait(500)
      CreateBlip(vector3(1180.81, -3306.35, 6.03))
end)

CreateThread(function ()
    while true do
        Wait(500)
        if inZone then
            for k, v in pairs(Config.BennysItem) do
                print(k)
            end
        end
    end
end)


