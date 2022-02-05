local QBCore = exports['qb-core']:GetCoreObject()
local tier = nil
local isRunning = false
AddEventHandler('onResourceStart', function(resource)
   if resource == GetCurrentResourceName() then
      Wait(100)
      print('Start')
   end
end)

AddEventHandler('onResourceStop', function(resource)
   if resource == GetCurrentResourceName() then
      print('Stop')
   end
end)

QBCore.Commands.Add('carboost', 'Start carboost', {{
   name = 'tier',
   help = 'Tier'
}
}, false, function(source, args)
   tier = Config.Tier[args[1]]
   if tier ~= nil and not isRunning then
      TriggerClientEvent('jl-carboost:client:spawnCar', source)
   else
      print('IS RUNNING or INVALID')
   end
end)

QBCore.Functions.CreateCallback('jl-carboost:server:spawnCar', function (source, cb, coords)
   local boosttier = tier
   local coords = boosttier.location[math.random(#boosttier.location)]
   local cars = boosttier.car[math.random(#boosttier.car)]
   local carhash = GetHashKey(cars)
   local carprices = math.random(boosttier.priceminimum, boosttier.pricemaximum)
   local CreateAutomobile = GetHashKey('CREATE_AUTOMOBILE')
   local car = Citizen.InvokeNative(CreateAutomobile, carhash, coords, coords.w, true, false)
   local data
   while not DoesEntityExist(car) do
      Wait(25)
   end
   if DoesEntityExist(car) then
      local netId = NetworkGetNetworkIdFromEntity(car)
      data = {
         networkID = netId,
         coords = coords
      }
      isRunning = true
      cb(data)
   else
      data = {
         networkID = 0,
      }
      cb(data)
   end
end)