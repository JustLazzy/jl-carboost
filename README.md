# JustLazzy Carboost

## THIS SCRIPT IS NOT YET STABLE! AND NOT YET READY, PLEASE REPORT IF YOU FIND BUG

| Join my discord server [here](https://discord.gg/fqUjRyhW2z) |
| ------------------------------------------------------------ |

## Dependencies
### boostinghack from Lionh34rt [here](https://github.com/Lionh34rt/boostinghack.git)
### Polyzone
### qb-target

<BR>

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

And you're done

# Configuration

## Configuring the bennys shop

```lua
Config.BennysSell = {
    ["brake1"] = {
        item = 'brake1', --Item name
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
