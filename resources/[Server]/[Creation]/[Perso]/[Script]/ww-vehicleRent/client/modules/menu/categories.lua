function RentingCategoriesMenu()
    for zoneName, zoneData in pairs(RentingZone) do
        local categoriesOptions = {}

        for category, _ in pairs(zoneData.Vehicles) do
            local categoryOptions = {}

            for _, vehicle in pairs(zoneData.Vehicles[category]) do
                table.insert(categoryOptions, {
                    title = vehicle.Label,
                    description = "Rent a " .. vehicle.Label .. " vehicle for $" .. vehicle.Price,
                    icon = "fas fa-car",
                    onSelect = function()
                        -- Ajoutez ici le code pour la location du véhicule
                        lib.print.info("Renting a " .. vehicle.Label .. " vehicle")
                    end
                })
            end

            table.insert(categoriesOptions, {
                title = category,
                description = "Choose a vehicle from the " .. category .. " category",
                icon = "fas fa-car",
                children = categoryOptions
            })
        end

        lib.registerContext({
            id = "ox_lib:renting_menu:" .. zoneName,
            title = "Rental Categories - " .. zoneName,
            options = categoriesOptions
        })

        lib.showContext("ox_lib:renting_menu:" .. zoneName)
    end
end
