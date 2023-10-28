local atmModel = {
    "prop_atm_01",
    "prop_atm_02",
    "prop_atm_03",
    "prop_fleeca_atm",
}

function AccessMenuATM()
    exports.ox_target:addModel(atmModel, {
        name = "atm_access_menu",
        label = "ATM Menu",
        icon = "fas fa-university",
        onSelect = function()
            lib.print.info("ATM Menu")
        end
    })
end