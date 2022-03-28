-- Don't touch it unless you knnow what you're doing

Config = Config or {}

Config.QueueList = {}

Config.PlayerContract = {}

Config.BennysItems = {}

----------------------------------------------------------

Config.Alert = 'qb-dispatch' -- qb-dispatch / linden_outlawalert / notification, only use qb-dispatch when its on stable release

Config.Inventory = 'qb-inventory/html/images/' -- qb-inventory/html/images/

Config.MinimumPolice = 0 -- Minimum police

Config.WaitTime = 1 -- Time to wait to get first contract, (in minutes)

Config.MaxContract = 5 -- Max contract that you can handle

Config.MaxQueueContract = 2 -- Max contract per session / per WaitTime

Config.Expire = 6 -- Expire time it'll be random, from 1 to this config

Config.MinRep = 10 -- Minimum reputation that you can get after finish contract

Config.MaxRep = 40 -- Maximum reputation that you can get after finish contract

Config.Payment = 'crypto' -- crypto / bank

Config.VINChance = 0.1 -- chance police to find out the VIN is scratched or no

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
                }
            },
            [2] = {
                car = vector4(-1077.27, -1143.9, 2.16, 203.94),
                npc = {
                    vector3(-1077.77, -1128.86, 2.16),
                }
            },
            [3] = {
                car = vector4(-1517.9, -884.14, 10.11, 47.89),
                npc = {
                    vector3(-1529.57, -885.42, 10.17),
                }
            },
            [4] = {
                car = vector4(-1144.5, -737.39, 20.21, 290.27),
                npc = {
                    vector3(-1159.14, -740.26, 19.89),
                }
            },
            [5] = {
                car = vector4(-727.06, -1061.14, 12.35, 31.44),
                npc = {
                    vector3(-738.16, -1068.43, 12.42),
                }
            },
            [6] = {
                car = vector4(-524.4, -883.63, 25.16, 156.43),
                npc = {
                    vector3(-535.84, -886.55, 25.21),
                }
            },
            [7] = {
                car = vector4(-446.69, -767.76, 30.56, 265.37),
                npc = {
                    vector3(-447.65, -789.61, 32.94),
                }
            },
            [8] = {
                car = vector4(-174.92, -156.66, 43.62, 67.47),
                npc = {
                    vector3(-194.97, -134.63, 43.98),
                }
            },
        },
        car = {
            'rebla',
            'dilettante'
        },
        priceminimum = 5,
        pricemaximum = 10,
        spawnnpc = false,
        attempt = 2,
        vinprice = 12
    },
    ['C'] = {
        location = {
            [1] = {
                car = vector4(2.42, -1525.01, 29.35, 326.29),
                npc = {
                    vector3(0.86, -1502.77, 30.0),
                    vector3(12.44, -1532.56, 29.28),
                }
            },
            [2] = {
                car = vector4(-1658.969, -205.1732, 54.8448, 71.138),
                npc = {
                    vector3(-1679.17, -201.26, 57.54),
                    vector3(-1666.61, -185.91, 57.6),
                }
            },
            [3] = {
                car = vector4(-60.09, -1842.84, 26.58, 317.62),
                npc = {
                    vector3(-37.36, -1835.39, 26.02),
                    vector3(-53.74, -1822.3, 26.78),
                }
            },
            [4] = {
                car = vector4(-1977.01, 259.98, 87.22, 287.74),
                npc = {
                    vector3(-1969.96, 247.87, 87.61),
                    vector3(-1981.06, 248.86, 87.61),
                }
            },
            [5] = {
                car = vector4(-1197.86, 349.32, 71.14, 101.93),
                npc = {
                    vector3(-1208.21, 354.13, 71.23),
                    vector3(-1211.41, 322.84, 71.03),
                }
            },
            [6] = {
                car = vector4(232.96, 385.49, 106.41, 75.35),
                npc = {
                    vector3(223.97, 381.21, 106.52),
                    vector3(255.24, 375.49, 105.53),
                }
            },
            [7] = {
                car = vector4(138.55, 317.62, 112.13, 111.85),
                npc = {
                    vector3(152.35, 304.96, 112.13),
                    vector3(134.62, 322.93, 116.63),
                }
            },
            [8] = {
                car = vector4(152.46, 163.21, 104.85, 73.96),
                npc = {
                    vector3(156.63, 153.34, 105.08),
                    vector3(141.94, 178.25, 105.43),
                }
            },
        },
        car = {
            'issi3',
        },
        priceminimum = 8,
        pricemaximum = 21,
        spawnnpc = false,
        attempt = 2,
        vinprice = 15
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
        priceminimum = 23,
        pricemaximum = 28,
        spawnnpc = true,
        attempt = 2,
        vinprice = 20
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
        priceminimum = 28,
        pricemaximum = 35,
        spawnnpc = true,
        attempt = 2,
        vinprice = 25
    },
    ['A+'] = {
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
            'jester2',
        },
        priceminimum = 30,
        pricemaximum = 41,
        spawnnpc = true,
        attempt = 2,
        vinprice = 32
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
        priceminimum = 45,
        pricemaximum = 61,
        spawnnpc = true,
        attempt = 2,
        vinprice = 35
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
        priceminimum = 61,
        pricemaximum = 24,
        spawnnpc = true,
        attempt = 2,
        vinprice = 43,
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

Config.ScratchingPoint = {
    -- pz 
    [1] = {
        coords = vector3(1430.56, 6332.89, 23.99),
        length = 10.6,
        width = 11.8,
        name = "scratchingpoint",
        heading = 0,
        minZ= 21.29,
        maxZ = 24.99
    },
    [2] = {
        coords = vector3(1637.43, 4850.97, 42.02),
        length = 9.95,
        width = 7.8,
        name = "scratchingpoint2",
        heading = 10,
        minZ= 39.42,
        maxZ = 43.42
    }
}

Config.BennysSell = {
    ["brake1"] = {
        item = 'brake1',
        price = 1000,
        stock = 50
    },
    ["brake2"] = {
        item = 'brake2',
        price = 1000,
        stock = 50,
    },
    ["brake3"] = {
        item = 'brake3',
        price = 1000,
        stock = 50,
    },
    ["engine4"] = {
        item = 'engine4',
        price = 502000,
        stock = 50,
    },
    ["engine0"] = {
        item = 'engine0',
        price = 130000,
        stock = 50,
    },
    ["engine1"] = {
        item = 'engine1',
        price = 120000,
        stock = 50,
    },
    ["engine2"] = {
        item = 'engine2',
        price = 100000,
        stock = 50,
    },
    ["engine3"] = {
        item = 'engine3',
        price = 100000,
        stock = 50,
    },
    ["fake_plate"] = {
        item = "fake_plate",
        price = 230,
        stock = 50,
    }

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