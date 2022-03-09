-- Don't touch it unless you knnow what you're doing

Config = Config or {}

Config.QueueList = {}

Config.PlayerContract = {}

Config.BennysItems = {}

----------------------------------------------------------

Config.Alert = 'linden_outlawalert' -- qb-dispatch / linden_outlawalert / notification, only use qb-dispatch when its on stable release

Config.Minimum = 5 -- Minimum police

Config.WaitTime = 1 -- Time to wait to get first contract, (in minutes)

Config.MaxContract = 5 -- Max contract that you can handle

Config.MaxQueueContract = 2 -- Max contract per session / per WaitTime

Config.Expire = 6 -- Expire time it'll be random, from 1 to this config

Config.MinRep = 10 -- Minimum reputation that you can get after finish contract

Config.MaxRep = 40 -- Maximum reputation that you can get after finish contract

Config.Payment = 'crypto' -- crypto / bank

Config.Attempt = 21 -- how many hacks to successfully turn off the tracker, it'll be random from 1 to this config

Config.Tier = {
    --[[
        Don't touch the tier name, just configure the location and car
    --]]
    ['D'] = {
        location = {
            [1] = {
                car = vector4(-935.1176, -1080.552,1.683342, 120.1060),
                npc = {
                    vector3(-924.21, -1088.11, 2.17),
                    vector3(-936.39, -1067.84, 2.17),
                    vector3(-932.79, -1064.2, 2.15)
                }
            },
            [2] = {
                car = vector4(-1077.27, -1143.9, 2.16, 203.94),
                npc = {
                    vector3(-1077.77, -1128.86, 2.16),
                    vector3(-1088.7, -1127.05, 2.16),
                    vector3(-1055.04, -1144.29, 2.16)
                }
            },
            [3] = {
                car = vector4(-1023.625, -890.4014, 5.202, 216.0399),
                npc = {
                    vector3(-1014.88, -898.47, 2.22),
                    vector3(-1037.91, -907.53, 3.55),
                    vector3(-1013.67, -884.11, 7.82)
                }
            },
        },
        car = {
            'rebla',
            'dilettante'
        },
        priceminimum = 5000,
        pricemaximum = 7000,
        spawnnpc = false,
    },
    ['C'] = {
        location = {
            [1] = {
                car = vector4(2.42, -1525.01, 29.35, 326.29),
                npc = {
                    vector3(0.86, -1502.77, 30.0),
                    vector3(12.44, -1532.56, 29.28),
                    vector3(19.94, -1511.37, 31.85)
                }
            },
            [2] = {
                car = vector4(-1658.969, -205.1732, 54.8448, 71.138),
                npc = {
                    vector3(-1679.17, -201.26, 57.54),
                    vector3(-1666.61, -185.91, 57.6),
                    vector3(-1649.03, -179.92, 56.39)
                }
            },
            [3] = {
                car = vector4(-60.09, -1842.84, 26.58, 317.62),
                npc = {
                    vector3(-37.36, -1835.39, 26.02),
                    vector3(-53.74, -1822.3, 26.78),
                    vector3(-62.12, -1814.4, 27.19)
                }
            },
        },
        car = {
            'issi3',
        },
        priceminimum = 30000,
        pricemaximum = 60000,
        spawnnpc = false,
    },
    ['B'] = {
        location = {
           [1] = {
               car = vector4(-111.13, 1003.88, 235.77, 106.21),
               npc = {
                vector3(-113.14, 986.3, 235.75),
                vector3(-105.28, 975.78, 235.76),
                vector3(-99.48, 1017.46, 235.83),
                vector3(-126.05, 1020.6, 235.79)
               }
            }
        },
        car = {
            'issi2',
        },
        priceminimum = 30000,
        pricemaximum = 60000,
        spawnnpc = true,
    },
    ['A'] = {
        location = {
            [1] = {
                car = vector4(215.31, 758.66, 204.65, 38.15),
                npc = {
                    vector3(228.68, 765.78, 204.98),
                    vector3(199.77, 776.69, 205.97),
                    vector3(214.39, 784.04, 204.34)
                },
            }
            
        },
        car = {
             'italigto',
        },
        priceminimum = 30000,
        pricemaximum = 60000,
        spawnnpc = true,
    },
    ['A+'] = {
        location = {
            vector4(215.76, 758.29, 204.66, 42.63)
        },
        car = {
            'jester2',
        },
        priceminimum = 30000,
        pricemaximum = 60000,
        spawnnpc = true
    },
    ['S'] = {
        location = {
            [1] = {
                car = vector4(-1801.37, 457.55, 128.3, 85.66),
                npc = {
                    vector3(-1806.3, 439.24, 128.71),
                    vector3(-1827.1, 449.58, 127.75),
                    vector3(-1789.95, 443.4, 128.31)
                }
            },
            [2] = {
                car = vector4(-1948.29, 460.76, 101.83, 101.65),
                npc = {
                    vector3(-1943.03, 449.74, 102.93),
                    vector3(-1972.41, 461.64, 102.22),
                    vector3(-1942.9, 426.15, 101.65)
                }
            }
        },
        car = {
            'reaper'
        },
        priceminimum = 30000,
        pricemaximum = 60000,
        spawnnpc = true
    },
    ['S+'] = {
        location = {
            [1] = {
                car = vector4(-1610.89, -380.59, 43.28, 227.89),
                npc = {
                    vector3(-1626.19, -391.83, 42.17),
                    vector3(-1614.89, -368.86, 43.41),
                    vector3(-1623.4, -400.16, 41.37),
                    vector3(-1600.25, -370.54, 44.36),
                }
            },
        },
        car = {
            'zentorno',
        },
        priceminimum = 30000,
        pricemaximum = 60000,
        spawnnpc = true,
    }
}

Config.DropPoint = {
    -- pz
    [1] = {
        coords = vector3(496.87, -2190.75, 5.92),
        length = 11.6,
        width = 5,
        name = "droppoint",
        heading = 331,
        minZ=4.67,
        maxZ=8.67
    },
    [2] = {
        coords = vector3(1216.25, -2947.09, 5.87),
        length = 12.05,
        width = 10,
        name = "droppoint2",
        heading = 0,
        minZ=4.87,
        maxZ=8.47
    }
}

Config.BennysSell = {
    ["brake1"] = {
        item = 'brake1',
        image = 'brake_parts_b.png',
        price = 1000,
        stock = 50
    },
    ["brake2"] = {
        item = 'brake2',
        image = 'brake_parts_c.png',
        price = 1000,
        stock = 50,
    },
    ["brake3"] = {
        item = 'brake3',
        image = 'brake_parts_d.png',
        price = 1000,
        stock = 50,
    },
    ["engine4"] = {
        item = 'engine4',
        image = 'engine_parts_s.png',
        price = 502000,
        stock = 50,
    },
    ["engine0"] = {
        item = 'engine0',
        image = 'engine_parts_a.png',
        price = 130000,
        stock = 50,
    },
    ["engine1"] = {
        item = 'engine1',
        image = 'engine_parts_b.png',
        price = 120000,
        stock = 50,
    },
    ["engine2"] = {
        item = 'engine2',
        image = 'engine_parts_c.png',
        price = 100000,
        stock = 50,
    },
    ["engine3"] = {
        item = 'engine3',
        image = 'engine_parts_d.png',
        price = 100000,
        stock = 50,
    },

}

Config.RandomName = {
    'Alfred',
    'Barry',
    'Carl',
    'Dennis',
    'Edgar',
    'Frederick',
    'George',
    'Herbert',
    'Irving',
    'John',
    'Kevin',
    'Larry',
    'Michael',
    'Norman',
    'Oscar',
    'Patricia',
    'Quinn',
    'Robert',
    'Steven',
    'Thomas',
}