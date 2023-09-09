--████████╗██████╗░░█████╗░███╗░░██╗░██████╗██╗░░░░░░█████╗░████████╗██╗░█████╗░███╗░░██╗
--╚══██╔══╝██╔══██╗██╔══██╗████╗░██║██╔════╝██║░░░░░██╔══██╗╚══██╔══╝██║██╔══██╗████╗░██║
--░░░██║░░░██████╔╝███████║██╔██╗██║╚█████╗░██║░░░░░███████║░░░██║░░░██║██║░░██║██╔██╗██║
--░░░██║░░░██╔══██╗██╔══██║██║╚████║░╚═══██╗██║░░░░░██╔══██║░░░██║░░░██║██║░░██║██║╚████║
--░░░██║░░░██║░░██║██║░░██║██║░╚███║██████╔╝███████╗██║░░██║░░░██║░░░██║╚█████╔╝██║░╚███║
--░░░╚═╝░░░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚══╝╚═════╝░╚══════╝╚═╝░░╚═╝░░░╚═╝░░░╚═╝░╚════╝░╚═╝░░╚══╝


---@param Put "fr" for the French translation
---@param Put "en" for the English translation
Config = {
    Locale = GetConvar('esx:locale', 'en')
}



-- French Translation
Locales['fr'] = {

    -- ['player_dropped'] = "Tu as été wipe par un admin. Ton personnage a été supprimé.",
    -- ['no_data_found'] = "Aucune donnée trouvée pour l'utilisateur ",
    -- ['inside_table'] = " dans la table \"",
    -- ['user_data'] = "Les données de l\'utilisateur ",
    -- ['erase_from_table'] = " ont été effacées de la table ",
    -- ['error_during_request'] = "Erreur lors de l'exécution de la requête : ",
    -- ['player_not_found'] = "Joueur non trouvé.",
    -- ['help_command'] = "Supprimer le personnage d'un joueur",
    -- ['help_args'] = "ID du joueur à wipe (optionnel)"

}





-- English Translation
Locales['en'] = {

    -- ['player_dropped'] = "You have been wiped by an admin. Your character has been deleted.",
    -- ['no_data_found'] = "No data has been founded for the user ",
    -- ['inside_table'] = " inside table \"",
    -- ['user_data'] = "User data ",
    -- ['erase_from_table'] = " has been erased frome the table ",
    -- ['error_during_request'] = "Error during request execution : ",
    -- ['player_not_found'] = "Player not found.",
    -- ['help_command'] = "Delete player character",
    -- ['help_args'] = "Player id to wipe (optional)"

}
