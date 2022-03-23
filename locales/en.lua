local Translations = {
    error = {
        ['already_started'] = 'You already start the contract',
        ['error_occured'] = 'An error occurred, contact your developer',
        ['buy_yourcontract'] = 'You can\'t buy your own contract',
        ['player_not_found'] = "Player not found",
        ['cannot_use'] = 'You can\'t use this device for now',
        ['not_on_vehicle'] = 'You need to be in a vehicle',
        ['disable_fail'] = "You failed to disable the tracker",
        ['no_tracker'] = "This vehicle doesn't have a tracker",
        ['empty_post'] = "You don't have anything in here",
        ['not_enough_money'] = "You have not enough %{money} in your account",
        ['invalid_tier'] = 'Invalid tier',
        ['invalid_player'] = 'Invalid player',
        ['not_seat'] = 'You need to be in front seat passenger to do this',
        ['not_owner'] = 'You need to be the owner of the vehicle to do this',
        ['not_plate'] = 'You need to be in the front or back of the vehicle to do this',
        ['no_car'] = 'Your car is gone...'
    },
    success = {
        ['disable_tracker'] = 'You have successfully disable the tracker',
        ['tracker_off'] = 'You turn off the tracker for %{time} seconds, %{tracker_left} left',
        ['sell_contract'] = 'You just sell this contract for %{amount} %{payment}',
        ['buy_contract'] = 'You just bought this contract for %{amount} %{payment}',
        ['contract_transfer'] = 'Successfully transfered contract to %{player}',
        ['contract_give'] = 'Successfully gave contract to %{player}',
        ['set_tier'] = "Successfully set the tier to %{tier}",
        ['take_all'] = 'Successfully received all items',
        ['plate_changed'] = "Successfully change the plate to %{plate}"
    },
    info = {
        ['car_inzone'] = "Okay, leave the car there, I'll pay you later",
        ['contract_buyed'] = "Someone just bought your contract for %{amount}",
        ['receive_transfer'] = 'You got new contract from %{player}',
        ['new_contract'] = "You just got a new contract",
        ['payment_crypto'] = 'You just got %{amount} crypto',
        ['get_rep'] = 'You get more reputation: %{rep}',
        ['boosting'] = '10-81 car boosting reported!',
        ['in_scratch'] = 'You can scratch your VIN here',
        ['not_in_scratch'] = 'You leave the zone',
    },
    menu = {
        
    },

    vehicle_class = {
        ['compact'] = 'Compact',
        ['sedan'] = 'Sedan',
        ['suv'] = 'Suv',
        ['coupe'] = 'Coupe',
        ['muscle'] = 'Muscle',
        ['sport_classic'] = 'Sport classic',
        ['sports'] = 'Sports',
        ['super'] = 'Super',
        ['motorcycle'] = 'Motorcycle',
        ['offroad'] = 'Offroad',
        ['industrial'] = 'Industrial',
        ['utulity'] = 'Utulity',
        ['van'] = 'Van',
        ['service'] = 'Service',
        ['military'] = 'Military',
        ['truck'] = 'Truck'
    },

    vehicle_info = {
        -- door count
        ['two_door'] = "Two doors",
        ['three_door'] = "Three doors",
        ['four_door'] = "Four doors",
    }
}
Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})