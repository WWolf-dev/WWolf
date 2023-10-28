function RentalNPC()
    local npcModel = lib.requestModel("a_m_m_farmer_01")
    local ped = CreatePed(4, npcModel, -492.0670, -679.7390, 31.9299, 176.3873, false, true)
    SetEntityAsMissionEntity(ped, true, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetModelAsNoLongerNeeded(npcModel)
end

function AccessRentalMenu()
    exports.ox_target:addBoxZone({
        coords = vec3(-492.0670, -679.7390, 32.9299),
        size = vec3(0.6, 0.6, 1.0),
        debug = true,
        options = {
            {
                name = "ww-rental:target:accessMenu",
                label = "Access Rental Menu",
                icon = "fas fa-car",
                onSelect = function()
                    lib.print.info("Accessing Rental Menu")
                    RentalMenu()
                end
            }
        }
    })
end