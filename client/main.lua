local QBCore = exports['qb-core']:GetCoreObject()
local isPoliceCalled = false
local isCarSpawned

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