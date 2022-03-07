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
        ['not_enough_money'] = "You have not enough %{money} in your account"
    },
    success = {
        ['disable_tracker'] = 'You have successfully disable the tracker',
        ['tracker_off'] = 'You turn off the tracker for %{time} seconds, %{tracker_left} left',
        ['sell_contract'] = 'You just sell this contract for %{amount} %{payment}',
        ['buy_contract'] = 'You just bought this contract for %{amount} %{payment}'
    },
    info = {
        ['car_inzone'] = "Okay, leave the car there, I'll pay you later",
        ['contract_buyed'] = "Someone just bought your contract for %{amount}"
    },
    menu = {
        
    }
}
Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})