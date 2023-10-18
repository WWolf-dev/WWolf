function VehicleRentMenu()
    local mainOptions = {}
    mainOptions[#mainOptions+1] = {
        title = "Rent a Vehiole",
        description = "Acces to the renting options",
        icon = "fas fa-car",
        onSelect = function()
            RentingCategoriesMenu()
        end
    }
    mainOptions[#mainOptions+1] = {
        title = "Return Vehicle",
        description = "Return a vehicle",
        icon = "fas fa-car",
        onSelect = function()
        end
    }

    lib.registerContext({
        id = "ox_lib:renting_menu:main",
        title = "Renting Menu",
        options = mainOptions
    })

    lib.showContext("ox_lib:renting_menu:main")
end