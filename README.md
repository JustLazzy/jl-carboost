# jl-carboost

| Join my discord server [here](https://discord.gg/fqUjRyhW2z) ! or buy me a [coffe](https://ko-fi.com/justlazzy) ! |
| ----------------------------------------------------------------------------------------------------------------- |

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
3. 

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
