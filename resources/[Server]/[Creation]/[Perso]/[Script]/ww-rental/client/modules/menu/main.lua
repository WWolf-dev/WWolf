function RentalMenu()
    lib.registerContext({
        id = "ww-rental:ox_lib:mainMenu",
        title = "Rental Menu",
        options = {
            {
                title = "Rent a Vehicle",
                description = "Rent a vehicle from the rental company",
                icon = "fas fa-car",
                onSelect = function()
                    lib.print.info("Renting a Vehicle")
                    RetalCategoriesMenu()
                end
            },
            {
                title = "Return a Vehicle",
                description = "Return a vehicle to the rental company",
                icon = "fas fa-car",
                onSelect = function()
                    lib.print.info("Returning a Vehicle")
                end
            },
            {
                title = "Réserver un véhicule",
                description = "SOON...",
                icon = "fa-solid fa-card",
                disabled = true
            },
            {
                title = "Historique de location",
                description = "SOON...",
                icon = "fa-solid fa-card",
                disabled = true
            },
            {
                title = "Point de fidélité",
                description = "SOON...",
                icon = "fa-solid fa-card",
                disabled = true
            },
            {
                title = "Informations",
                description = "SOON...",
                icon = "fa-solid fa-card",
                disabled = true
            },
        }
    })

    lib.showContext("ww-rental:ox_lib:mainMenu")
end