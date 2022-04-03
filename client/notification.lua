local QBCore = exports['qb-core']:GetCoreObject()

function AlertBoosting(netid, type)
    local car = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(netid)), false)
    local vehInfo = VehicleData(car)
    local carPos = GetEntityCoords(car)
    if type == "linden_outlawalert" then
        local data = {displayCode = '10-50', description = 'Car Boosting', isImportant = 1, recipientList = {'police'}, length = '10000', infoM = 'fa-car', 
        info = ('[%s]'):format(vehInfo.plate).. " Car boosting in progress", info2 = vehInfo.name
        , blipSprite = 326, blipColour = 1}
        local dispatchData = {dispatchData = data, caller = 'Alarm', coords = carPos}
        TriggerServerEvent('wf-alerts:svNotify', dispatchData)
    elseif type == "qb-dispatch" then
        exports['qb-dispatch']:CarBoosting(car)
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
    local class = GetVehicleClass(vehicle)
    local vehicleClass = {[0] = Lang:t('vehicle_class.compact'), [1] = Lang:t('vehicle_class.sedan'), [2] = Lang:t('vehicle_class.suv'), [3] = Lang:t('vehicle_class.coupe'), [4] = Lang:t('vehicle_class.muscle'), [5] = Lang:t('vehicle_class.sport_classic'), [6] = Lang:t('vehicle_class.sports'), [7] = Lang:t('vehicle_class.super'), [8] = Lang:t('vehicle_class.motorcycle'), [9] = Lang:t('vehicle_class.offroad'), [10] = Lang:t('vehicle_class.industrial'), [11] = Lang:t('vehicle_class.utulity'), [12] = Lang:t('vehicle_class.van'), [13] = Lang:t('vehicle_class.service'), [14] = Lang:t('vehicle_class.military'), [15] = Lang:t('vehicle_class.truck')}
    local vehClass = vehicleClass[class]
    local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
    local doorCount = 0
    local vehicleColour
    if GetEntityBoneIndexByName(vehicle, 'door_pside_f') ~= -1 then doorCount = doorCount + 1 end
	if GetEntityBoneIndexByName(vehicle, 'door_pside_r') ~= -1 then doorCount = doorCount + 1 end
	if GetEntityBoneIndexByName(vehicle, 'door_dside_f') ~= -1 then doorCount = doorCount + 1 end
	if GetEntityBoneIndexByName(vehicle, 'door_dside_r') ~= -1 then doorCount = doorCount + 1 end
    if doorCount == 2 then doorCount = Lang:t('vehicle_info.two_door') elseif doorCount == 3 then doorCount = Lang:t('vehicle_info.three_door') elseif doorCount == 4 then doorCount = Lang:t('vehicle_info.four_door') else doorCount = '' end
    local vehColour1, vehColour2 = GetVehicleColours(vehicle)
    if vehColour1 then
        if Colours[tostring(vehColour2)] and Colours[tostring(vehColour1)] then
            vehicleColour = Colours[tostring(vehColour1)]..'on'..Colours[tostring(vehColour2)]
        elseif Colours[tostring(vehColour1)] then
            vehicleColour = Colours[tostring(vehColour1)]
        elseif Colours[tostring(vehColour2)] then
            vehicleColour = Colours[tostring(vehColour2)]
        end
    end
    local vehInfo = {
        plate = QBCore.Functions.GetPlate(vehicle),
        name = vehicleName,
        class = vehClass,
        colour = vehicleColour,
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
        AddTextComponentString('10-50 Car Boosting')
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

Colours = {
    ['0'] = "Metallic Black",
    ['1'] = "Metallic Graphite Black",
    ['2'] = "Metallic Black Steel",
    ['3'] = "Metallic Dark Silver",
    ['4'] = "Metallic Silver",
    ['5'] = "Metallic Blue Silver",
    ['6'] = "Metallic Steel Gray",
    ['7'] = "Metallic Shadow Silver",
    ['8'] = "Metallic Stone Silver",
    ['9'] = "Metallic Midnight Silver",
    ['10'] = "Metallic Gun Metal",
    ['11'] = "Metallic Anthracite Grey",
    ['12'] = "Matte Black",
    ['13'] = "Matte Gray",
    ['14'] = "Matte Light Grey",
    ['15'] = "Util Black",
    ['16'] = "Util Black Poly",
    ['17'] = "Util Dark silver",
    ['18'] = "Util Silver",
    ['19'] = "Util Gun Metal",
    ['20'] = "Util Shadow Silver",
    ['21'] = "Worn Black",
    ['22'] = "Worn Graphite",
    ['23'] = "Worn Silver Grey",
    ['24'] = "Worn Silver",
    ['25'] = "Worn Blue Silver",
    ['26'] = "Worn Shadow Silver",
    ['27'] = "Metallic Red",
    ['28'] = "Metallic Torino Red",
    ['29'] = "Metallic Formula Red",
    ['30'] = "Metallic Blaze Red",
    ['31'] = "Metallic Graceful Red",
    ['32'] = "Metallic Garnet Red",
    ['33'] = "Metallic Desert Red",
    ['34'] = "Metallic Cabernet Red",
    ['35'] = "Metallic Candy Red",
    ['36'] = "Metallic Sunrise Orange",
    ['37'] = "Metallic Classic Gold",
    ['38'] = "Metallic Orange",
    ['39'] = "Matte Red",
    ['40'] = "Matte Dark Red",
    ['41'] = "Matte Orange",
    ['42'] = "Matte Yellow",
    ['43'] = "Util Red",
    ['44'] = "Util Bright Red",
    ['45'] = "Util Garnet Red",
    ['46'] = "Worn Red",
    ['47'] = "Worn Golden Red",
    ['48'] = "Worn Dark Red",
    ['49'] = "Metallic Dark Green",
    ['50'] = "Metallic Racing Green",
    ['51'] = "Metallic Sea Green",
    ['52'] = "Metallic Olive Green",
    ['53'] = "Metallic Green",
    ['54'] = "Metallic Gasoline Blue Green",
    ['55'] = "Matte Lime Green",
    ['56'] = "Util Dark Green",
    ['57'] = "Util Green",
    ['58'] = "Worn Dark Green",
    ['59'] = "Worn Green",
    ['60'] = "Worn Sea Wash",
    ['61'] = "Metallic Midnight Blue",
    ['62'] = "Metallic Dark Blue",
    ['63'] = "Metallic Saxony Blue",
    ['64'] = "Metallic Blue",
    ['65'] = "Metallic Mariner Blue",
    ['66'] = "Metallic Harbor Blue",
    ['67'] = "Metallic Diamond Blue",
    ['68'] = "Metallic Surf Blue",
    ['69'] = "Metallic Nautical Blue",
    ['70'] = "Metallic Bright Blue",
    ['71'] = "Metallic Purple Blue",
    ['72'] = "Metallic Spinnaker Blue",
    ['73'] = "Metallic Ultra Blue",
    ['74'] = "Metallic Bright Blue",
    ['75'] = "Util Dark Blue",
    ['76'] = "Util Midnight Blue",
    ['77'] = "Util Blue",
    ['78'] = "Util Sea Foam Blue",
    ['79'] = "Uil Lightning blue",
    ['80'] = "Util Maui Blue Poly",
    ['81'] = "Util Bright Blue",
    ['82'] = "Matte Dark Blue",
    ['83'] = "Matte Blue",
    ['84'] = "Matte Midnight Blue",
    ['85'] = "Worn Dark blue",
    ['86'] = "Worn Blue",
    ['87'] = "Worn Light blue",
    ['88'] = "Metallic Taxi Yellow",
    ['89'] = "Metallic Race Yellow",
    ['90'] = "Metallic Bronze",
    ['91'] = "Metallic Yellow Bird",
    ['92'] = "Metallic Lime",
    ['93'] = "Metallic Champagne",
    ['94'] = "Metallic Pueblo Beige",
    ['95'] = "Metallic Dark Ivory",
    ['96'] = "Metallic Choco Brown",
    ['97'] = "Metallic Golden Brown",
    ['98'] = "Metallic Light Brown",
    ['99'] = "Metallic Straw Beige",
    ['100'] = "Metallic Moss Brown",
    ['101'] = "Metallic Biston Brown",
    ['102'] = "Metallic Beechwood",
    ['103'] = "Metallic Dark Beechwood",
    ['104'] = "Metallic Choco Orange",
    ['105'] = "Metallic Beach Sand",
    ['106'] = "Metallic Sun Bleeched Sand",
    ['107'] = "Metallic Cream",
    ['108'] = "Util Brown",
    ['109'] = "Util Medium Brown",
    ['110'] = "Util Light Brown",
    ['111'] = "Metallic White",
    ['112'] = "Metallic Frost White",
    ['113'] = "Worn Honey Beige",
    ['114'] = "Worn Brown",
    ['115'] = "Worn Dark Brown",
    ['116'] = "Worn straw beige",
    ['117'] = "Brushed Steel",
    ['118'] = "Brushed Black Steel",
    ['119'] = "Brushed Aluminium",
    ['120'] = "Chrome",
    ['121'] = "Worn Off White",
    ['122'] = "Util Off White",
    ['123'] = "Worn Orange",
    ['124'] = "Worn Light Orange",
    ['125'] = "Metallic Securicor Green",
    ['126'] = "Worn Taxi Yellow",
    ['127'] = "Police Car Blue",
    ['128'] = "Matte Green",
    ['129'] = "Matte Brown",
    ['130'] = "Worn Orange",
    ['131'] = "Matte White",
    ['132'] = "Worn White",
    ['133'] = "Worn Olive Army Green",
    ['134'] = "Pure White",
    ['135'] = "Hot Pink",
    ['136'] = "Salmon pink",
    ['137'] = "Metallic Vermillion Pink",
    ['138'] = "Orange",
    ['139'] = "Green",
    ['140'] = "Blue",
    ['141'] = "Mettalic Black Blue",
    ['142'] = "Metallic Black Purple",
    ['143'] = "Metallic Black Red",
    ['144'] = "hunter green",
    ['145'] = "Metallic Purple",
    ['146'] = "Metallic Dark Blue",
    ['147'] = "Black",
    ['148'] = "Matte Purple",
    ['149'] = "Matte Dark Purple",
    ['150'] = "Metallic Lava Red",
    ['151'] = "Matte Forest Green",
    ['152'] = "Matte Olive Drab",
    ['153'] = "Matte Desert Brown",
    ['154'] = "Matte Desert Tan",
    ['155'] = "Matte Foilage Green",
    ['156'] = "Default Alloy Color",
    ['157'] = "Epsilon Blue",
    ['158'] = "Pure Gold",
    ['159'] = "Brushed Gold",
    ['160'] = "MP100"
}
