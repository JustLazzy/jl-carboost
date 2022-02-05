Config = Config or {}

Config.UseLindenAlert = true -- If u use linden_outlawalert

Config.Minimum = 5 -- Minimum police

Config.Tier = {
    --[[
        Don't touch the tier name, just configure the location and car
    --]]
    ['C'] = {
        location = {
            vector4(-333.41, -1268.04, 31.3, 84.32),
            vector4(1005.4, -1483.02, 31.15, 178.8)
        },
        car = {
            'issi3',

        },
        priceminimum = 30000,
        pricemaximum = 60000
    },
    ['B'] = {
        location = {
            vector4(219.2, -2845.79, 6.01, 264.57)
        },
        car = {
            'issi2',
        },
        priceminimum = 30000,
        pricemaximum = 60000
    },
    ['A'] = {
        location = {
            vector4(263.14, -2847.59, 6.0, 33.77)
        },
        car = {
             'italigto',
        },
        priceminimum = 30000,
        pricemaximum = 60000
    },
    ['A+'] = {
        location = {
            vector4(215.76, 758.29, 204.66, 42.63)
        },
        car = {
            'jester2',
        },
        priceminimum = 30000,
        pricemaximum = 60000
    },
    ['S'] = {
        location = {
            vector4(-1993.36, 294.09, 91.29, 340.95)
        },
        car = {
            'reaper'
        },
        priceminimum = 30000,
        pricemaximum = 60000
    },
    ['S+'] = {
        location = {
            [1] = {
                coords = vector4(-1795.3, 396.12, 112.79, 84.99),
                npc = {
                    vector4(-1795.3, 396.12, 112.79, 84.99)
                }
            }
        },
        car = {
            'zentorno',
        },
        priceminimum = 30000,
        pricemaximum = 60000
    }
}

Config.SellLocation = {

}