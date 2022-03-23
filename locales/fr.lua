local Translations = {
    error = {
        ['already_started'] = 'Vous avez déjà commencer ce contrat',
        ['error_occured'] = 'Une erreur est survenu, contacté l\'administration du serveur',
        ['buy_yourcontract'] = 'Tu ne peux pas acheter ton propre contrat',
        ['player_not_found'] = "Joueur non trouvé",
        ['cannot_use'] = 'Vous ne pouvez pas utiliser l\'appareil pour l\'instant',
        ['not_on_vehicle'] = 'Vous devez être dans un véhicule',
        ['disable_fail'] = "Vous n\'avez pas réussi à désactiver le mouchard",
        ['no_tracker'] = "Ce véhicule n\'a pas de mouchard",
        ['empty_post'] = "Vous n'avez rien ici",
        ['not_enough_money'] = "Vous n'avez pas assez %{money} dans votre compte",
        ['invalid_tier'] = 'Tier invalide',
        ['invalid_player'] = 'Joueur invalid',
        ['not_seat'] = 'Vous devez être passager à l\avant du véhicule pour pour faire ça',
        ['not_owner'] = 'Vous devez être le propriétaire du véhicule',
        ['not_plate'] = 'Vous devez être à l\'avant où l\'arriève du véhicule pour faire ça',
    },
    success = {
        ['disable_tracker'] = 'Vous avez désactiver le mouchard',
        ['tracker_off'] = 'Vous avez désactivé le mouchard pendant %{time} secondes, %{tracker_left} restant',
        ['sell_contract'] = 'Vous avez vendu ce contrat pour %{amount} %{payment}',
        ['buy_contract'] = 'Vous avez acheter ce contrat pour %{amount} %{payment}',
        ['contract_transfer'] = 'Contrat transférer avec succès à %{player}',
        ['contract_give'] = 'Vous avez donner un contrat à %{player}',
        ['set_tier'] = "Vous avez mit le tier à %{tier}",
        ['take_all'] = 'Vous avez reçu tout les objets',
        ['plate_changed'] = "Vous avez réusis à changer la plaque en %{plate}"
    },
    info = {
        ['car_inzone'] = "Laisse la voiture ici. Je te paye plus tard.",
        ['contract_buyed'] = "Quelqu\'un à acheter votre contrat pour %{amount}",
        ['receive_transfer'] = 'Vous avez un nouveau contrat de %{player}',
        ['new_contract'] = "Vous avez un nouveau contrat",
        ['payment_crypto'] = 'Vous avez reçu %{amount} crypto',
        ['get_rep'] = 'Vous avez gagné de la réputation: %{rep}',
        ['boosting'] = '10-81 Boosting signalé !',
        ['in_scratch'] = 'Vous pouvez effacer le VIN ici',
        ['not_in_scratch'] = 'Vous n\'êtes pas dans la zone',
    },
    menu = {
        
    },

    vehicle_class = {
        ['compact'] = 'Compact',
        ['sedan'] = 'Berline',
        ['suv'] = 'Suv',
        ['coupe'] = 'Coupé',
        ['muscle'] = 'Grosse cylindrée',
        ['sport_classic'] = 'Sportive Classique',
        ['sports'] = 'Sports',
        ['super'] = 'Supersportive',
        ['motorcycle'] = 'Motos',
        ['offroad'] = 'Tout terrain',
        ['industrial'] = 'Industriel',
        ['utulity'] = 'Utilitaire',
        ['van'] = 'Van',
        ['service'] = 'Service',
        ['military'] = 'Militaire',
        ['truck'] = 'Camion'
    },

    vehicle_info = {
        -- door count
        ['two_door'] = "Deux portes",
        ['three_door'] = "Trois portes",
        ['four_door'] = "Quatre portes",
    }
}
Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
