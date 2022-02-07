local QBCore = exports['qb-core']:GetCoreObject()
local isPoliceCalled = false
local isCarSpawned
local display = false



RegisterCommand('carnui', function (source)
    SetDisplay(not display)
end)

RegisterCommand('loadstore', function (source)
   TriggerEvent('jl-carboost:client:loadStore')
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

RegisterNetEvent('jl-carboost:client:loadStore', function ()
    SendNUIMessage({
        type="loadStore",
        store = Config.BennysSell
    })
end)
-- Event
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
    Wait(100)
    TriggerEvent('jl-carboost:client:loadStore')
end)
