local QBCore = exports['qb-core']:GetCoreObject()
local tier = nil
local isRunning = false
local ItemConfig = {}

CreateThread(function ()
   local result = MySQL.Sync.fetchAll('SELECT * FROM `bennys_shop`', {})
   if result[1] then
      for k, v in pairs(result) do
         Config.BennysItem[v.citizenid] = {
            items = v.items
         }
      end
      
   end
   TriggerClientEvent('jl-carboost:client:setConfig', -1, Config.BennysItem)
   print(json.encode(Config.BennysItem))
end)

-- Event
RegisterNetEvent('jl-carboost:server:sendTask', function (source, data)
end)

RegisterNetEvent('jl-carboost:server:buyItem', function (data)
   local src = source 
   local pData = QBCore.Functions.GetPlayer(src)
   local cartData = {}
   pData.Functions.RemoveMoney('bank', data.price, 'bought-bennys-item')
   for k, v in pairs(data.items) do
      print(json.encode(v))
      cartData[k] = {
         item = v.item,
         quantity = v.quantity,
      }
   end
   print(json.encode(json.encode(pData.PlayerData.citizenid)))
   MySQL.Async.insert('INSERT INTO bennys_shop (citizenid, items) VALUES(?,?)', {
      pData.PlayerData.citizenid, json.encode(cartData)
   })

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

QBCore.Functions.CreateCallback('jl-carboost:server:canBuy', function(source, cb, data)
   local src = source
   local pData = QBCore.Functions.GetPlayer(src)
   local bankAccount = pData.PlayerData.money["bank"]
   if bankAccount >= data then
      cb(true)
   else
      cb(false)
   end
   return cb
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


QBCore.Functions.CreateUseableItem('laptop' , function(source, item)
   TriggerClientEvent('jl-carboost:client:openLaptop', source)
end)