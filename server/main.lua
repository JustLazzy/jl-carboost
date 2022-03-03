local QBCore = exports['qb-core']:GetCoreObject()
local sleep = 1 * 1000
local queueNumber = 0


AddEventHandler('onResourceStart', function (resource)
   if resource == GetCurrentResourceName() then
      Queue()
      DeleteExpiredContract()
   end
end)

-- function to get next boost class?, hit me up if you what the better way to do this
local function GetNextClass(class)
   if class == 'D' then
      return 'C' 
   elseif class == 'C' then
      return 'B'
   elseif class == 'B' then
      return 'A'
   elseif class == 'A' then
      return 'S'
   elseif class == 'S' then
      return 'S+'
   end
end

-- Event
RegisterNetEvent('jl-carboost:server:saveBoostData', function (citizenid)
   MySQL.Async.execute('UPDATE boost_data SET data = @data WHERE citizenid = @citizenid', {
      ['@citizenid'] = citizenid,
      ['@data'] = json.encode(Config.QueueList[citizenid])
   })
end)

RegisterNetEvent('jl-carboost:server:newContract', function (source)
   local src = source
   local Player = QBCore.Functions.GetPlayer(src)
   local citizenid = Player.PlayerData.citizenid
   local config = Config.QueueList[citizenid]
   local tier = config.tier
   local car = Config.Tier[tier].car[math.random(#Config.Tier[tier].car)]
   local owner = Config.RandomName[math.random(1, #Config.RandomName)]
   local randomHour = math.random(1,6)
   local contractData = {
      owner = owner,
      car = car,
      tier = tier,
      plate = RandomPlate(),
      expire = GetHoursFromNow(randomHour),
   }
  local something =  os.date('%c')
  print(something)
   if #Config.QueueList[citizenid].contract <= Config.MaxContract then     
      MySQL.Async.insert('INSERT INTO boost_contract (owner, data, started, expire) VALUES (@owner, @data, NOW(),DATE_ADD(NOW(), INTERVAL @expire HOUR))', {
         ['@owner'] = citizenid,
         ['@data'] = json.encode(contractData),
         ['@expire'] = randomHour
      }, function (id)
         contractData.id = id
         Config.QueueList[citizenid].contract[#Config.QueueList[citizenid].contract+1] = contractData
         TriggerClientEvent('jl-carboost:client:addContract', src, contractData)
      end)
   end
end)

RegisterNetEvent('jl-carboost:server:joinQueue', function (status, citizenid)
   local src = source
   local Player = QBCore.Functions.GetPlayer(src)
   if status then
      Config.QueueList[citizenid] = {
         getContract = false,
         status = true,
         tier = Player.PlayerData.metadata['carboostclass'],
         startContract = false,
         contract = {}
      }
      queueNumber = queueNumber + 1
      TriggerEvent('jl-carboost:server:log', 'Player with CID: '..citizenid..' joined the queue, queue number: '..queueNumber)
      TriggerEvent('jl-carboost:server:getContract', Player.PlayerData.citizenid)
   else
      Config.QueueList[citizenid] = {
         status =  false,
         tier = Player.PlayerData.metadata['carboostclass'],
         startContract = false,
         contract = {}
      }
      queueNumber = queueNumber - 1
      if queueNumber < 0 then
         queueNumber = 0
      end
      TriggerEvent('jl-carboost:server:log', 'Player with CID: '..citizenid..' has left the queue, queue number: '..queueNumber)
   end
end)

-- This one is only for serverside
RegisterNetEvent('jl-carboost:server:getContract', function (citizenid)
   local result = MySQL.Sync.fetchAll('SELECT * FROM boost_contract WHERE owner = @owner', {
      ['@owner'] = citizenid
   })
   if result[1] then
      for k, v in pairs(result) do
         Config.QueueList[citizenid].contract[#Config.QueueList[citizenid].contract+1] = json.decode(v.data)
      end
   end
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

RegisterNetEvent('jl-carboost:server:giveContract', function ()
   local src = source
   local pData = QBCore.Functions.GetPlayer(src)
   TriggerEvent('jl-carboost:server:newContract', src,pData.PlayerData.citizenid)
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

RegisterNetEvent('jl-carboost:server:log', function (string, type)
   if type == "discord" then
   else
      print(string)
   end
end)

RegisterNetEvent('jl-carboost:server:finishBoosting', function (data)
   local isNextLevel = false
   local src = source
   local data = data
   local pData = QBCore.Functions.GetPlayer(src)
   local amountMoney = math.random(20, 70)
   local currentRep = pData.PlayerData.metadata['carboostrep']
   local randomRep = math.random(Config.MinRep, Config.MaxRep)
   local total = currentRep + randomRep
   if total >= 100 then
      total = total - 100
      local class = GetNextClass(pData.PlayerData.metadata['carboostclass'])
      pData.Functions.SetMetaData('carboostclass', class)
      isNextLevel = true
   end
   if Config.Payment == 'crypto' then
      TriggerClientEvent('QBCore:Notify', src, 'You just got '..amountMoney..' crypto', 'success')
   end
   pData.Functions.SetMetaData("carboostrep", total)
   pData.Functions.AddMoney(Config.Payment, amountMoney, 'finished-boosting')
   TriggerClientEvent('jl-carboost:client:updateProggress', src, isNextLevel)
   TriggerClientEvent('QBCore:Notify', src, 'You get more reputation: '..randomRep, 'success')
end)

RegisterNetEvent('jl-carboost:server:deleteContract', function (contractid)
   local src = source
   local Player = QBCore.Functions.GetPlayer(src)
   MySQL.Async.execute('DELETE FROM boost_contract WHERE owner = @citizenid AND id = @id',{
      ['@citizenid'] = Player.PlayerData.citizenid,
      ['@id'] = contractid
   }, function (result)
      if result > 0 then
         TriggerEvent('jl-carboost:server:log', 'Contract '..contractid..' deleted, CID:'..Player.PlayerData.citizenid)
      end
   end)
   print("END OF THE DELETE CONTRACT")
end)

RegisterNetEvent('jl-carboost:server:updateBennysConfig', function (data)
   local src = source 
   local pData = QBCore.Functions.GetPlayer(src)
   MySQL.Async.execute('UPDATE bennys_shop SET items = @items WHERE citizenid = @citizenid', {
      ['@citizenid'] = pData.PlayerData.citizenid,
      ['@items'] = json.encode(data)
   })
end)

QBCore.Commands.Add('settier', 'Set Boosting Tier', {
   {
      name = 'tier',
      help = 'Tier of contract, D,C,B,A,S,S+'
   },
   {
      name = 'id',
      help = 'Player ID',
   },
}, false,function (source,args)
   local src = source
   if not args[1] or not type(args[1]) == "string" or Config.Tier[tostring(args[1])] == nil then
      return TriggerClientEvent('QBCore:Notify', src, "Invalid tier", "error")
   end
   local PlayerID = tonumber(args[2])
   local player
   if PlayerID then
      player = QBCore.Functions.GetPlayer(PlayerID)
      if not player or player == nil then
         return TriggerClientEvent('QBCore:Notify', src, "Invalid player", "error")
      end
   else
      player = QBCore.Functions.GetPlayer(src)
   end
   player.Functions.SetMetaData('carboostclass', tostring(args[1]))
   TriggerClientEvent('QBCore:Notify', src, "Successfully set the tier to "..args[1], "success")
end, 'admin')

QBCore.Commands.Add('giveContract', 'Give contract, admin only', {
   {
      name = 'tier',
      help = 'Tier of contract, D, C, B, A, S, S+',
   },
   {
      name = 'playerid',
      help = 'Player id',
   }
}, false, function(source, args)
   local src = source
   local PlayerID =  tonumber(args[2])
   local player
   if type(args[1]) == "number" then
      return TriggerClientEvent('QBCore:Notify', src, "Invalid tier", "error")
   end
   if PlayerID then
      player = QBCore.Functions.GetPlayer(PlayerID)
      if not player or player == nil then
         return TriggerClientEvent('QBCore:Notify', src, "Invalid player", "error")
      end
   else
      player = QBCore.Functions.GetPlayer(src)
   end
   if Config.Tier[tostring(args[1])] ~= nil then
      local config = Config.Tier[tostring(args[1])]
      local car = config.car[math.random(#config.car)]
      local owner = Config.RandomName[math.random(1, #Config.RandomName)]
      local expireTime = math.random(1, 7)
      -- local xixi = GetHoursFromNow(expireTime)
      -- print(xixi)
      local contractData = {
         owner = owner,
         car = car,
         tier = args[1],
         plate = RandomPlate(),
         expire = GetHoursFromNow(expireTime),
      }
      MySQL.Async.insert('INSERT INTO boost_contract (owner, data, started, expire) VALUES (@owner, @data, NOW(),DATE_ADD(NOW(), INTERVAL @expire HOUR))', {
         ['@owner'] = player.PlayerData.citizenid,
         ['@data'] = json.encode(contractData),
         ['@expire'] = expireTime
      }, function (id)
         contractData.id = id
         TriggerClientEvent('jl-carboost:client:addContract', player.PlayerData.source, contractData)
         TriggerClientEvent('QBCore:Notify', src, "Succesfully gave contract to "..player.PlayerData.name, "success")
      end)

   else
      return TriggerClientEvent('QBCore:Notify', src, "Invalid tier", "error")
   end
end, 'admin')

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
   TriggerClientEvent('QBCore:Notify', src, "Succesfully bought all items", "success")
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

QBCore.Functions.CreateCallback('jl-carboost:server:sellContract', function (source, cb, data)
   local data = data.data
   print(json.encode(data))
   local src = source
   local Player = QBCore.Functions.GetPlayer(src)
   local result = MySQL.Sync.fetchAll('SELECT * FROM boost_contract WHERE id = @id AND owner = @owner', {
      ['@owner'] = Player.PlayerData.citizenid,
      ['@id'] = data.id
   })
   if result[1] then
      local contractInfo = result[1]
      local contractData = json.decode(contractInfo.data)
      print(json.encode(contractData))
   end
end)

QBCore.Functions.CreateCallback('jl-carboost:server:canTake', function (source, cb, data)
   
end)

QBCore.Functions.CreateCallback('jl-carboost:server:getboostdata', function (source, cb, citizenid)
   local Player = QBCore.Functions.GetPlayerByCitizenId(citizenid)
   local contractData = {
      class = Player.PlayerData.metadata['carboostclass'],
      rep = Player.PlayerData.metadata['carboostrep'],
      contract = {}
   }
   local result = MySQL.Sync.fetchAll('SELECT * FROM boost_contract WHERE owner = @owner', {
      ['@owner'] = citizenid
   })
   if result[1] then
      for _, v in pairs(result) do
         if v.onsale == 1 then
            return
         end
         print(json.encode(v))
         local data = json.decode(v.data)
         contractData.contract[#contractData.contract+1] = {
            id = v.id,
            owner = data.owner,
            car = data.car,
            tier = data.tier or 'D',
            plate = data.plate,
            expire = v.expire
         }
      end
   end
   return cb(contractData)
end)

QBCore.Functions.CreateCallback('jl-carboost:server:getContractData', function (source, cb, data)
   local data = data.data
   -- print(json.encode(data))
   local Player = QBCore.Functions.GetPlayer(source)
   local result = MySQL.Sync.fetchAll('SELECT * FROM boost_contract WHERE id = @id AND owner = @owner', {
      ['@id'] = data.id,
      ['@owner'] = Player.PlayerData.citizenid
   })
   if result[1] then
      local res = result[1]
      local contractdata = {
         id = res.id,
         type = data.type,
         data = json.decode(res.data),
      }
      return cb(contractdata)
   end
end)

QBCore.Functions.CreateCallback('jl-carboost:server:spawnCar', function (source, cb, data)
   local cardata = data
   local boosttier = Config.Tier[cardata.data.tier]
   local coords = boosttier.location[math.random(1, #boosttier.location)]
   local npcCoords
   if boosttier.spawnnpc then
      npcCoords = coords.npc
   end
   local carhash = GetHashKey(data.data.car)
   local CreateAutomobile = GetHashKey('CREATE_AUTOMOBILE')
   local car = Citizen.InvokeNative(CreateAutomobile, carhash, coords.car, coords.car.h, true, false)
   local data
   while not DoesEntityExist(car) do
      Wait(25)
   end
   
   if DoesEntityExist(car) then
      SetVehicleDoorsLocked(car, 2) -- Lock the vehicle
      SetVehicleNumberPlateText(car, cardata.data.plate)
      local netId = NetworkGetNetworkIdFromEntity(car)
      data = {
         id = cardata.id,
         networkID = netId,
         spawnlocation = coords.car,
         npc = npcCoords,
         carmodel = car,
         type = cardata.type
      }
      cb(data)
   else
      data = {
         networkID = 0,
      }
      cb(data)
   end
end)


-- Simple Queue System
function Queue()
   if queueNumber ~= 0 then
      local num = 0
      local player = 0
      local inqueue = 0
      Wait(Config.WaitTime * 1000 * 60)
      for k, v in pairs(Config.QueueList) do
         local Player = QBCore.Functions.GetPlayerByCitizenId(k)
         if not v.getContract and v.status and Player and num <= Config.MaxQueueContract then
            TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, 'You just got a new contract', 'success')
            TriggerEvent('jl-carboost:server:newContract', Player.PlayerData.source, k)
            num = (num or 0) + 1
            v.getContract = true
         end
         if v.getContract then
            inqueue = inqueue + 1
         end
         player = player + 1
      end
      if queueNumber == inqueue then
         inqueue = 0
         queueNumber = 0
      end
   end
   SetTimeout(sleep, function ()
      Queue()
   end)
end

-- Delete expired contracts
function DeleteExpiredContract()
   MySQL.Async.execute('DELETE FROM boost_contract WHERE expire < NOW() AND started = 0',{}, function (result)
      if result > 0 then
         print(json.encode(result))
         print('Contracts deleted')
      end
   end)
   SetTimeout(sleep,function ()
      DeleteExpiredContract()
   end)
end

function RandomVIN()

end

function GenerateVIN()
   MySQL.Async.execute('UPDATE')
   SetTimeout(sleep, function ()
      GenerateVIN()
   end)
end

-- Random Plate
function RandomPlate()
	local random = tostring(QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(4)):upper()
   return random
end

function GetHoursFromNow(hours)
   local hours = tonumber(hours)
   local time = os.date("%c", os.time() + hours * 60 * 60)
   return time
end

-- make the laptop usable
QBCore.Functions.CreateUseableItem('laptop' , function(source, item)
   TriggerClientEvent('jl-carboost:client:openLaptop', source)
end)

QBCore.Functions.CreateUseableItem('hacking_device',  function (source, item)
   TriggerClientEvent('jl-carboost:client:useHackingDevice', source)
end)