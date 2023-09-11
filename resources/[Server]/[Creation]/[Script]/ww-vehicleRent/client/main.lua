if FrameworkUse == "ESX" then     --𝔽ℝ𝔸𝕄𝔼𝕎𝕆ℝ𝕂 𝕋𝕐ℙ𝔼
    -- Check the ESX Version to work with the script
    if versionESX == "older" then -- Activate the old way of ESX to work with the script
        ESX = nil
        CreateThread(function()
            while ESX == nil do
                TriggerEvent(getSharedObjectEvent, function(obj) ESX = obj end)
                Wait(0)
            end
        end)
    elseif versionESX == "newer" then -- Activate the new way of ESX to work with the script
        FrameworkExport()             --Function wh-ere the export of ESX is stored
    end


    -- Event when a player is loaded
    RegisterNetEvent(playerLoadedEvent)
    AddEventHandler(playerLoadedEvent, function(xPlayer)
        ESX.PlayerData = xPlayer
        PlayerLoaded = true
    end)

    CreateThread(function()
        Blips()
        if UseNPC then
            NPC()
        end
        if UseTarget == "ox_target" then
            AccessNPC()
        end
        initializeVehicleAvailability()
    end)

    function Blips()
        for _, rent in pairs(RentingBlip) do
            local blip = AddBlipForCoord(rent["Coords"])
            SetBlipSprite(blip, rent["Sprite"])
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, rent["Scale"])
            SetBlipColour(blip, rent["Color"])
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(rent["Name"])
            EndTextCommandSetBlipName(blip)
        end
    end

    function NPC()
        for _, npc in pairs(RentingNPC) do
            lib.requestModel(npc["Name"])
            local ped = CreatePed(4, npc["Name"], npc["Coords"].x, npc["Coords"].y, npc["Coords"].z, npc["Coords"].w, false, true)
            SetEntityAsMissionEntity(ped, true, true)
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            TaskStartScenarioInPlace(ped, npc["Scenario"], 0, true)
            SetModelAsNoLongerNeeded(npc["Name"])
        end
    end

    function AccessNPC()
        for _, target in pairs(RentingNPC) do
            exports.ox_target:addBoxZone({
                coords = vec3(target["Coords"].x, target["Coords"].y, target["Coords"].z + 1),
                size = vec3(1, 1, 1),
                options = {
                    {
                        name = "target_vehicle_rental",
                        icon = "fa-solid fa-circle",
                        label = TranslateCap("target_access_menu"),
                        onSelect = function()
                            if DebugMode then
                                print("Menu access success")
                            end
                            MenuNPC()
                        end
                    }
                }
            })
        end
    end

    function MenuNPC()
        lib.registerContext({
            id = "main_menu_npc_rental",
            title = "Location de Véhicule",
            options = {
                {
                    title = "Louer un véhicule",
                    description = "Choisissez parmi une large liste de véhicule",
                    icon = "fa-solid fa-card",
                    onSelect = function()
                        CategoryMenu()
                        if DebugMode then
                            print("Access to the categories menu")
                        end
                    end
                },
                {
                    title = "Rendre un véhicule",
                    description = "Rendre un véhicule une fois la location finit",
                    icon = "fa-solid fa-card",
                    onSelect = function()
                        ReturnVehicleMenu()
                    end
                },
                {
                    title = "Réserver un véhicule",
                    description = "Reservez un véhicule à l'avance",
                    icon = "fa-solid fa-card",
                    onSelect = function()
                        print("yey")
                    end
                },
                {
                    title = "Historique de location",
                    description = "Regardez les différents véhicule que vous avez loué",
                    icon = "fa-solid fa-card",
                    onSelect = function()
                        print("yey")
                    end
                },
                {
                    title = "Point de fidélité",
                    description = "Regardez combien de points vous avez gagné",
                    icon = "fa-solid fa-card",
                    onSelect = function()
                        print("yey")
                    end
                },
                {
                    title = "Informations",
                    description = "Consultez les informations sur les locations",
                    icon = "fa-solid fa-card",
                    onSelect = function()
                        print("yey")
                    end
                },
            }
        })

        lib.showContext("main_menu_npc_rental")
    end


































        -- Soon QBCore support
elseif FrameworkUse == "QBCore" then
    return nil
end