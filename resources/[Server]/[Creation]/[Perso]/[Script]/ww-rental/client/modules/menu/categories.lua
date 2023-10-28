local function RentalLuxeCategory()
    local luxe1 = "virtue"
    local luxe2 = "gauntlet6"
    lib.registerContext({
        id = "ww-rental:ox_lib:luxeCategory",
        title = "Luxe Vehicles",
        menu = "ww-rental:ox_lib:categoriesMenu",
        options = {
            {
                title = "Virtue",
                description = "Rent a Virtue",
                icon = "fas fa-car",
                onSelect = function()
                    lib.print.info("Renting a Virtue")
                    ParametersVehicleLuxe(luxe1)
                end
            },
            {
                title = "gauntlet6",
                description = "Rent a gauntlet6",
                icon = "fas fa-car",
                onSelect = function()
                    lib.print.info("Renting a gauntlet6")
                    ParametersVehicleLuxe(luxe2)
                end
            }
        }
    })
    lib.showContext("ww-rental:ox_lib:luxeCategory")
end

local function RentalSportCategory()
    local sport1 = "stingertt"
    local sport2 = "coureur"
    lib.registerContext({
        id = "ww-rental:ox_lib:sportCategory",
        title = "Sports Vehicles",
        menu = "ww-rental:ox_lib:categoriesMenu",
        options = {
            {
                title = "stingertt",
                description = "Rent a stingertt",
                icon = "fas fa-car",
                onSelect = function()
                    lib.print.info("Renting a stingertt")
                    ParametersVehicleSport(sport1)
                end
            },
            {
                title = "coureur",
                description = "Rent a coureur",
                icon = "fas fa-car",
                onSelect = function()
                    lib.print.info("Renting a coureur")
                    ParametersVehicleSport(sport2)
                end
            }
        }
    })
    lib.showContext("ww-rental:ox_lib:sportCategory")
end

function RetalCategoriesMenu()
    lib.registerContext({
        id = "ww-rental:ox_lib:categoriesMenu",
        title = "Rental Categories",
        menu = "ww-rental:ox_lib:mainMenu",
        options = {
            {
                title = "Luxe Vehicles",
                description = "Rent a Luxe Vehicle",
                icon = "fas fa-car",
                onSelect = function()
                    lib.print.info("Renting a Luxe Vehicle")
                    RentalLuxeCategory()
                end
            },
            {
                title  = "Sport Vehicles",
                description = "Rent a Sport Vehicle",
                icon = "fas fa-car",
                onSelect = function()
                    lib.print.info("Renting a Sport Vehicle")
                    RentalSportCategory()
                end
            }
        }
    })

    lib.showContext("ww-rental:ox_lib:categoriesMenu")
end