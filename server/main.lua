local QBCore = exports['qb-core']:GetCoreObject()
local tier = nil
local isRunning = false
local ItemConfig = {}

-- Event
RegisterNetEvent('jl-carboost:server:sendTask', function (source, data)
end)

RegisterNetEvent('jl-carboost:server:takeItem', function (name, quantity)
   local src = source
   local Player = QBCore.Functions.GetPlayer(src)
   Player.Functions.AddItem(name, quantity)
   TriggerClientEvent('inventory:client:itemBox', src, QBCore.Shared.Items[tostring(name)], 'add')
end)

RegisterNetEvent('jl-carboost:server:getItem', function ()
   local src = source
   local pData = QBCore.Functions.GetPlayer(src)
   local result = MySQL.Sync.fetchScalar('SELECT items FROM bennys_shop WHERE citizenid = @citizenid', {
      ['@citizenid'] = pData.PlayerData.citizenid
   })
   if result then
      TriggerClientEvent('jl-carboost:client:setConfig', src, json.decode(result))
   end
end)

RegisterNetEvent('jl-carboost:server:setConfig', function ()
   TriggerClientEvent('jl-carboost:client:setConfig', -1, Config.BennysItems)
end)


RegisterNetEvent('jl-carboost:server:buyItem', function (price, config, first)
   local src = source 
   local pData = QBCore.Functions.GetPlayer(src)
   pData.Functions.RemoveMoney('bank', price, 'bought-bennys-item')
      MySQL.Async.insert('INSERT INTO bennys_shop (citizenid, items) VALUES (@citizenid, @items) ON DUPLICATE KEY UPDATE items = @items', {
         ['@citizenid'] = pData.PlayerData.citizenid,
         ['@items'] = json.encode(config)
      })
end)

RegisterNetEvent('jl-carboost:server:updateConfig', function (data)
   local src = source 
   local pData = QBCore.Functions.GetPlayer(src)
   MySQL.Async.execute('UPDATE bennys_shop SET items = @items WHERE citizenid = @citizenid', {
      ['@citizenid'] = pData.PlayerData.citizenid,
      ['@items'] = json.encode(data)
   })
end)

RegisterNetEvent('jl-carboost:server:takeAll', function (data)
   local src = source
   local Player = QBCore.Functions.GetPlayer(src)
   for k, v in pairs(data) do
      local item = v.item
      Player.Functions.AddItem(item.name, item.quantity)
      TriggerClientEvent('inventory:client:itemBox', src, QBCore.Shared.Items[tostring(item.name)], 'add')
   end
   MySQL.Async.execute('UPDATE bennys_shop SET items = @items WHERE citizenid = @citizenid', {
      ['@citizenid'] = Player.PlayerData.citizenid,
      ['@items'] = json.encode({})
   })
end)

-- Commands
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

-- Callback
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

QBCore.Functions.CreateCallback('jl-carboost:server:canTake', function (source, cb, data)
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