function RentingNPCs()
    for _, npcs in pairs(RentingZone) do
        local npcModel = lib.requestModel(npcs.NPC.Model)
        local npc = CreatePed(4, npcModel, npcs.Position.x, npcs.Position.y, npcs.Position.z, npcs.Position.w, false, true)
        SetEntityAsMissionEntity(npc, true, true)
        FreezeEntityPosition(npc, true)
        SetEntityInvincible(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
        TaskStartScenarioInPlace(npc, npcs.NPC.Sceanrio, 0, true)
    end
end

function AccesRentingMenu()
    for data, target in pairs(RentingZone) do
        exports.ox_target:addBoxZone({
            coords = vec3(target.Position.x, target.Position.y, target.Position.z + 1),
            size = vec3(0.6, 0.6, 1.0),
            debug = true,
            options = {
                {
                    name = "ox_target:RentingMenu",
                    label = "Renting Menu",
                    icon = "fas fa-car",
                    onSelect = function()
                        lib.print.info("Access to renting menu : " .. data)
                        VehicleRentMenu()
                    end
                }
            }
        })
    end
end