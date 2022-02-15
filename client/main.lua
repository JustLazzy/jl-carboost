local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData()
local isPoliceCalled = false
local isCarSpawned
local display = false
local inZone = false

local laptopdict = "amb@code_human_in_bus_passenger_idles@female@tablet@base"
local laptopanim = "base"

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    PlayerData = val
end)

-- function
function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type="openlaptop",
        status = bool
    })
end

function CreateBlip(coords, name, sprite)
	local blip = AddBlipForCoord(coords)
	SetBlipSprite(blip, sprite)
	SetBlipScale(blip, 0.6)
	SetBlipColour(blip, 4)
	SetBlipDisplay(blip, 4)
	SetBlipAsShortRange(blip, false)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(name)
	EndTextCommandSetBlipName(blip)
	return blip
end

RegisterCommand("testanim", function ()
    RequestAnimDict(laptopdict)
    while not HasAnimDictLoaded(laptopdict) do Wait(100) end

    local ped = PlayerPedId()
    
    TaskPlayAnim(ped, laptopdict, laptopanim, 8.0, 8.0, -1, 0, 0, false, false, false)
end)

RegisterCommand('testimage', function()
    for k, v in pairs(Config.BennysSell) do
       print(QBCore.Shared.Items[v.item]["label"])
    end
end)

RegisterCommand('testconfig', function()
    print(json.encode(Config.BennysItems))
end)

-- NUI
RegisterNUICallback('openlaptop', function (data)
    SetDisplay(false)
end)

RegisterNUICallback('exit', function (data)
    SetDisplay(false)
end)

RegisterNUICallback('loadstore', function (data, cb)
    local storeitem = Config.BennysSell
    if storeitem then
        cb({
            storeitem = storeitem
        })
    else
        cb({
            error = 'No store item'
        })
    end
end)

RegisterNUICallback('checkout', function (data)
    QBCore.Functions.TriggerCallback('jl-carboost:server:canBuy', function (result)
        if result then
            local firstTime = false
            if not Config.BennysItems[1] then
                firstTime = true
            end
            local itemData = {
                items = data.list,
                price = data.total
            }
            for k, v in pairs(itemData.items) do
                -- local itemquantity = v.quantity
                -- local itemname = v.item
                -- for k, v in pairs(Config.BennysItems) do
                --     local itemname2 = v.item
                --     if itemname2.name == itemname then
                --         local quantityTotal = itemquantity + Config.BennysItems[k].item.quantity
                --         Config.BennysItems[k].item.quantity = quantityTotal
                --     else
                --         local test = {
                --             item = {
                --                 itemname,
                --                 itemquantity
                --             }
                --         }
                --         table.insert(Config.BennysItems, test)
                --     end
                -- end
                Config.BennysItems[#Config.BennysItems+1] = {
                    item = {
                        name = v.item,
                        quantity = v.quantity
                    }
                }
            end
            TriggerServerEvent('jl-carboost:server:buyItem', itemData.price, Config.BennysItems, firstTime)
            SendNUIMessage({
                type="checkout",
                success = result
            })
        else
            SendNUIMessage({
                type="checkout",
                success = result
            })
        end
    end, data.total)
end)

-- Event


RegisterNetEvent('jl-carboost:client:setConfig', function (data)
    Config.BennysItems = data
end)

RegisterNetEvent('jl-carboost:client:takeAll', function ()
    TriggerServerEvent('jl-carboost:server:takeAll', Config.BennysItems)
    Config.BennysItems = {}
end)

RegisterNetEvent('jl-carboost:client:takeItem', function (data)
    TriggerServerEvent('jl-carboost:server:takeItem', data.item, data.quantity)
    for k, v in pairs(Config.BennysItems) do
        if v.item.name == data.item then
           table.remove(Config.BennysItems, k)
        end
    end
    if Config.BennysItems[1] == nil then
        Config.BennysItems = {}
    end
    TriggerServerEvent('jl-carboost:server:updateConfig', Config.BennysItems)
end)

RegisterNetEvent('jl-carboost:client:openMenu', function ()
    if Config.BennysItems[1] then
        local data = {
            {
                header = "| Post OP |",
                isMenuHeader = true
            },
        }
        for _, v in pairs(Config.BennysItems) do
            local item = v.item
            data[#data+1] = {
                header = QBCore.Shared.Items[item.name]["label"],
                id = item.name,
                txt = "You have: "..item.quantity,
                params = {
                    event = "jl-carboost:client:takeItem",
                    args = {
                            item = item.name,
                            quantity = item.quantity
                    }
                }
            }
        end
        data[#data+1] = {
            header = "Take all",
            id = "take all",
            txt = "Take all the items",
            params = {
                event = "jl-carboost:client:takeAll"
            }

        }
        exports['qb-menu']:openMenu(data)
    else
        QBCore.Functions.Notify("You don't have anything in here...", "error")
    end
end)

RegisterNetEvent('jl-carboost:client:spawnCar', function()
    QBCore.Functions.TriggerCallback('jl-carboost:server:spawnCar', function(result)
        if result then
            local streetname = GetStreetNameFromHashKey(GetStreetNameAtCoord(result.coords.x, result.coords.y, result.coords.z))
            print(streetname)
            SetNewWaypoint(result.coords.x, result.coords.y)
            TriggerServerEvent('qb-phone:server:sendNewMail', {
                sender = "Unknown",
                subject = "Car Location",
                message = "Hey this is the car location, its in near "..streetname,
                button = {
                    enabled = true,
                }
             })
        else
            print('no result')
        end
    end)
end)

RegisterNetEvent('jl-carboost:client:startBoosting', function ()
    
end)



RegisterNetEvent('jl-carboost:client:openLaptop', function ()
    SetDisplay(not display)
end)

-- Threads

CreateThread(function ()
    while display do
        Wait(0)
        DisableControlAction(0, 1, display)
        DisableControlAction(0, 2, display)
        DisableControlAction(0, 142, display)
        DisableControlAction(0, 18, display)
        DisableControlAction(0, 322, display)
        DisableControlAction(0, 106, display)
    end
end)

CreateThread(function ()
    Wait(100)
     if LocalPlayer.state['isLoggedIn'] then      
        TriggerServerEvent('jl-carboost:server:getItem')
        CreateBlip(vector3(1185.2, -3303.92, 6.92), "Post OP", 473)
     end
end)

-- exports

exports['qb-target']:AddBoxZone("carboost:takeItem", vector3(1185.14, -3304.01, 7.1), 2, 2, {
	name = "MissionRowDutyClipboard",
    heading=0,
    minZ=5.1,
    maxZ=9.1,
	-- debugPoly = true,
    scale= {1.0, 1.0,1.0},
}, {
	options = {
		{
            type = "client",
            event = "jl-carboost:client:openMenu",
			icon = "fas fa-solid fa-box",
			label = "Take item",
		},
	},
	distance = 3.0
})