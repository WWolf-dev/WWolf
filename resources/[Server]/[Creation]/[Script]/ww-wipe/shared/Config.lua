--░█████╗░░█████╗░███╗░░██╗███████╗██╗░██████╗░██╗░░░██╗██████╗░░█████╗░████████╗██╗░█████╗░███╗░░██╗
--██╔══██╗██╔══██╗████╗░██║██╔════╝██║██╔════╝░██║░░░██║██╔══██╗██╔══██╗╚══██╔══╝██║██╔══██╗████╗░██║
--██║░░╚═╝██║░░██║██╔██╗██║█████╗░░██║██║░░██╗░██║░░░██║██████╔╝███████║░░░██║░░░██║██║░░██║██╔██╗██║
--██║░░██╗██║░░██║██║╚████║██╔══╝░░██║██║░░╚██╗██║░░░██║██╔══██╗██╔══██║░░░██║░░░██║██║░░██║██║╚████║
--╚█████╔╝╚█████╔╝██║░╚███║██║░░░░░██║╚██████╔╝╚██████╔╝██║░░██║██║░░██║░░░██║░░░██║╚█████╔╝██║░╚███║
--░╚════╝░░╚════╝░╚═╝░░╚══╝╚═╝░░░░░╚═╝░╚═════╝░░╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚═╝░╚════╝░╚═╝░░╚══╝


-- Enable debug message inside console
EnableDebug = true


-- the name of the command to write 
CommandName = "wipe"


-- Add any grade of your server, these grades will be allowed to use the wipe command
AllowedGradeToWipe = {
    "owner",
    "admin"
}


-- Add any table from your SQL that will be checked and wiped
-- TableToWype = {
--     "addon_account_data",
--     "addon_inventory_items",
--     "banking",
--     "billing",
--     "datastore_data",
--     "owned_vehicles",
--     "ox_inventory",
--     "playerskins",
--     "player_outfits",
--     "users",
--     "user_licenses"
-- }

TableToWype = {
    {
        table =  "addon_account_data",
        IdentifierColumn = "owner"
    },
    {
        table =  "addon_inventory_items",
        IdentifierColumn = "owner"
    },
    {
        table =  "banking",
        IdentifierColumn = "identifier"
    },
    {
        table =  "billing",
        IdentifierColumn = "identifier"
    },
    {
        table =  "datastore_data",
        IdentifierColumn = "owner"
    },
    {
        table =  "owned_vehicles",
        IdentifierColumn = "owner"
    },
    {
        table =  "ox_inventory",
        IdentifierColumn = "owner"
    },
    {
        table =  "playerskins",
        IdentifierColumn = "citizenid"
    },
    {
        table =  "player_outfits",
        IdentifierColumn = "citizenid"
    },
    {
        table =  "users",
        IdentifierColumn = "identifier"
    },
    {
        table =  "user_licenses",
        IdentifierColumn = "owner"
    },
}