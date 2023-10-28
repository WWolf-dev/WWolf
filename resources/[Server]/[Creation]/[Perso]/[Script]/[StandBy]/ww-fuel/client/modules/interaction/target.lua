function AccessFuelPump()
    exports.ox_target:addModel(FuelPumpModel, {
        {
            name = "ww-fuel:ox_target:refuelVehicle",
            label = "Refuel Vehicle",
            icon = "fas fa-gas-pump",
            onSelect = function()
                lib.print.info("Access Refuel")
            end
        },
        {
            name = "ww-fuel:ox_target:buyJerrycan",
            label = "Buy Jerrycan",
            icon = "fas fa-gas-pump",
            onSelect = function()
                lib.print.info("Access JerryCan")
            end
        }
    })
end