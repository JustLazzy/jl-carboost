# JustLazzy Carboost

## THIS SCRIPT IS NOT YET STABLE! AND NOT YET READY, PLEASE REPORT IF YOU FIND BUG

| Join my discord server [here](https://discord.gg/fqUjRyhW2z) |
| ------------------------------------------------------------ |

## Dependencies

1. boostinghack from Lionh34rt [here](https://github.com/Lionh34rt/boostinghack.git)
2. Polyzone
3. qb-target
4. qb-phone

# How to install

<tr>

1. Import db.sql to your database

2. Go to your qb-core/server/player.lua, and find `QBCore.Player.CheckPlayerData function` and paste this snippets

```lua
    -- Car Boosting
    PlayerData.metadata['carboostclass'] = PlayerData.metadata['carboostclass'] or 'D'
    PlayerData.metadata['carboostrep'] = PlayerData.metadata['carboostrep'] or 0
```

3. Go to your qb-core/shared/items.lua, and add this

```lua
-- Hacking
['hacking_device']			  = {['name'] = "hacking_device",					['label'] = "Hacking device",			['weight'] = 500,		['type'] = 'item', 		['image'] = 'hacking_device.png',			['unique'] = true,		['useable']	= true,		['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = "A multi purpose hacking device"},
```

Find laptop and change unique and usage to true,

```lua
['unique'] = true, 		['useable'] = true,
```

4. Go to your `qb-radialmenu/config.lua` and add this on policejob, probably line 711

```lua
        {
            id = 'checkvin',
            title = 'Check VIN',
            icon = 'search',
            type = 'client',
            event = 'jl-carboost:client:checkvin',
            shouldClose = true
        }
```

5. Go to your `qb-vehicleshop/server.lua` find this event `qb-vehicleshop:server:buyShowroomVehicle`, replace that with

```lua
RegisterNetEvent('qb-vehicleshop:server:buyShowroomVehicle', function(vehicle)
    local src = source
    local vehicle = vehicle.buyVehicle
    local pData = QBCore.Functions.GetPlayer(src)
    local cid = pData.PlayerData.citizenid
    local cash = pData.PlayerData.money['cash']
    local bank = pData.PlayerData.money['bank']
    local vehiclePrice = QBCore.Shared.Vehicles[vehicle]['price']
    local plate = GeneratePlate()
    if cash > vehiclePrice then
        MySQL.Async.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state) VALUES (?, ?, ?, ?, ?, ?, ?)', {
            pData.PlayerData.license,
            cid,
            vehicle,
            GetHashKey(vehicle),
            '{}',
            plate,
            0
        })
        TriggerClientEvent('QBCore:Notify', src, 'Congratulations on your purchase!', 'success')
        TriggerClientEvent('qb-vehicleshop:client:buyShowroomVehicle', src, vehicle, plate)
        pData.Functions.RemoveMoney('cash', vehiclePrice, 'vehicle-bought-in-showroom')
        exports['jl-carboost']:AddVIN(plate)
    elseif bank > vehiclePrice then
        MySQL.Async.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state) VALUES (?, ?, ?, ?, ?, ?, ?)', {
            pData.PlayerData.license,
            cid,
            vehicle,
            GetHashKey(vehicle),
            '{}',
            plate,
            0
        })
        TriggerClientEvent('QBCore:Notify', src, 'Congratulations on your purchase!', 'success')
        TriggerClientEvent('qb-vehicleshop:client:buyShowroomVehicle', src, vehicle, plate)
        pData.Functions.RemoveMoney('bank', vehiclePrice, 'vehicle-bought-in-showroom')
        exports['jl-carboost']:AddVIN(plate)
    else
        TriggerClientEvent('QBCore:Notify', src, 'Not enough money', 'error')
    end
end)
```

And you're done

# Configuration

## Configuring the bennys shop

```lua
Config.BennysSell = {
    ["brake1"] = {
        item = 'brake1', --Item name on your shared/items.lua
        image = 'brake_parts_b.png', --Item image
        price = 1000, --Item price
        stock = 50 -- Item stock
    },
}
```

**MAKE SURE YOUR ITEM IS EXIST ON THE SHARED ITEM**

# Commands

| Name         | Description                        | Permission |
| ------------ | ---------------------------------- | ---------- |
| settier      | Set Boosting Tier                  | Admin      |
| giveContract | Give contract to a specific player | Admin      |

# Preview

## Bennys App

<img src="https://media.discordapp.net/attachments/943001162196611103/952890360764432394/unknown.png?width=1036&height=583" />
<img src="https://media.discordapp.net/attachments/943001162196611103/952890442217828352/unknown.png?width=1036&height=583">

## Boosting App

<img src= "https://media.discordapp.net/attachments/943001162196611103/952890617401323550/unknown.png?width=1036&height=583"/>
<img src= "https://media.discordapp.net/attachments/943001162196611103/952890668873838622/unknown.png?width=1036&height=583"/>

## Setting

<img src="https://media.discordapp.net/attachments/943001162196611103/952891497747996672/unknown.png?width=1036&height=583"/>

## Special Thanks

Thanks to [@kentainfr](https://github.com/Kentainfr) for the amazing icon!

<BR>

If you love my work, you can [buy me a coffee](https://ko-fi.com/justlazzy)
