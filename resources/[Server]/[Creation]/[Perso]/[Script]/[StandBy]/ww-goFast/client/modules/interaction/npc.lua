function GoFastNPC()
    for _, npcs in pairs(goFastZones) do
        local npcModel = lib.RequestModel(npcs.NPC.Model)
        local ped = CreatePed(4, npcModel, npcs.Position.x, npcs.Position.y, npcs.Position.z, npcs.Position.w, false, true)
        SetEntityAsMissionEntity(ped, true, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        TaskStartScenarioInPlace(ped, npcs.NPC.Scenario, 0, true)
        SetModelAsNoLongerNeeded(npcModel)
    end
end

function AccessGofastNPCs()
    for _, target in pairs(goFastZones) do
        local targetPosition = target.Position
        exports.ox_target:addBoxZone({
            coords = vec3(targetPosition.x, targetPosition.y, targetPosition.z + 1),
            size = vec3(0.6, 0.6, 1.0),
            debug = true,
            options = {
                {
                    name = "ww-goFast:ox_target:accessGoFast",
                    label = "Access Go Fast",
                    icon = "fas fa-cannabis",
                    onSelect = function()
                        lib.print.info("Accessing Go Fast")
                    end
                }
            }
        })
    end
end