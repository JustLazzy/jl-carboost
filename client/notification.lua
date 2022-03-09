local QBCore = exports['qb-core']:GetCoreObject()

function AlertBoosting(netid, type)
    local car = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(netid)), false)
    local vehInfo = VehicleData(car)
    local carPos = GetEntityCoords(car)
    if type == "linden_outlawalert" then
        local data = {displayCode = '10-81', description = 'Car Boosting', isImportant = 1, recipientList = {'police'}, length = '10000', infoM = 'fa-car', 
        info = ('[%s]'):format(vehInfo.plate).. " Car boosting in progress", info2 = vehInfo.name
        , blipSprite = 326, blipColour = 1}
        local dispatchData = {dispatchData = data, caller = 'Alarm', coords = carPos}
        TriggerServerEvent('wf-alerts:svNotify', dispatchData)
    else
        TriggerServerEvent('jl-carboost:notifypolice', netid)
    end

    CreateThread(function ()
        while DoesEntityExist(car) do
            Wait(10000)
            Hacked = Entity(car).state.hacked
            if not Hacked then
                carPos = GetEntityCoords(car)
                TriggerServerEvent('jl-carboost:notifyboosting', carPos, car)
            end
        end
    end)
end

function VehicleData(vehicle)
    local data = {}
    local class = GetVehicleClass(vehicle)
    local vehicleClass = {[0] = Lang:t('vehicle_class.compact'), [1] = Lang:t('vehicle_class.sedan'), [2] = Lang:t('vehicle_class.suv'), [3] = Lang:t('vehicle_class.coupe'), [4] = Lang:t('vehicle_class.muscle'), [5] = Lang:t('vehicle_class.sport_classic'), [6] = Lang:t('vehicle_class.sports'), [7] = Lang:t('vehicle_class.super'), [8] = Lang:t('vehicle_class.motorcycle'), [9] = Lang:t('vehicle_class.offroad'), [10] = Lang:t('vehicle_class.industrial'), [11] = Lang:t('vehicle_class.utulity'), [12] = Lang:t('vehicle_class.van'), [13] = Lang:t('vehicle_class.service'), [14] = Lang:t('vehicle_class.military'), [15] = Lang:t('vehicle_class.truck')}
    local vehClass = vehicleClass[class]
    local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
    local vehInfo = {
        plate = GetVehicleNumberPlateText(vehicle),
        name = vehicleName,
        class = vehClass,
    }
    return vehInfo
end

-- From qb-dispatch
RegisterNetEvent('jl-carboost:notifyboosting', function (pos, veh)
    local Player = QBCore.Functions.GetPlayerData()
    if Player.job.name == 'police' then
        local alpha = 250
        local boostingblip = AddBlipForCoord(pos)
        SetBlipSprite(boostingblip, 326)
        SetBlipAsShortRange(boostingblip, true)
        SetBlipColour(boostingblip, 1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('10-81 Car Boosting')
        EndTextCommandSetBlipName(boostingblip)
        while alpha ~= 0 do
            Wait(120 * 4)
            alpha = alpha - 10
            SetBlipAlpha(boostingblip, alpha)
            if alpha < 50 then
                RemoveBlip(boostingblip)
            end
        end
    end
end)

RegisterNetEvent('jl-carboost:notifypolice', function (car)
    local Player = QBCore.Functions.GetPlayerData()
    if Player.job.name == 'police' then
        QBCore.Functions.Notify(Lang:t('info.boosting'), 'info')
    end
end)
