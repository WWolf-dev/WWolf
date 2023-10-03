-- Determine the framework in use (ESX or QBCore)
if FrameworkUse == "ESX" then 

    -- Check the ESX Version and initialize the framework
    if versionESX == "older" then 
        ESX = nil
        CreateThread(function()
            -- Wait for ESX to be initialized
            while ESX == nil do
                TriggerEvent(getSharedObjectEvent, function(obj) ESX = obj end)
                Wait(0)
            end
        end)
    elseif versionESX == "newer" then 
        FrameworkExport()  -- Export new ESX functionalities
    end

    CreateThread(function()
        AmmuBlips()
        AmmuNPC()

        ClearPrivateAmmuNPC()
        PrivateAmmuNPC()

        AccessAccueilAmmuNPC()
        AccesPrivateAmmuNPC()
    end)
    -- Register an event when the player is loaded
    RegisterNetEvent(playerLoadedEvent)
    AddEventHandler(playerLoadedEvent, function(xPlayer)
        ESX.PlayerData = xPlayer  -- Store player data locally
        PlayerLoaded = true
    end)

    -- Event when a player is setjob
    RegisterNetEvent(setJobEvent)
    AddEventHandler(setJobEvent, function(job)
        ESX.PlayerData.job = job

        ClearPrivateAmmuBlip()
        PrivateAmmuBlip()
    end)

    function AmmuBlips()
        for _, ammunation in pairs(AmmuZone) do
            local ammublip = ammunation["Blip"]
            local blip = AddBlipForCoord(ammublip["Coords"])
            SetBlipSprite(blip, ammublip["Sprite"])
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, ammublip["Scale"])
            SetBlipColour(blip, ammublip["Color"])
            SetBlipAlpha(blip, ammublip["Opacity"])
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(ammublip["Name"])
            EndTextCommandSetBlipName(blip)
        end
    end

    local workBlip = {}

    function PrivateAmmuBlip()
        if ESX.PlayerData.job and ESX.PlayerData.job.name == "ammunation" then
            for _, ammunation in pairs(AmmuZone) do
                for _, workblip in pairs(ammunation["WorkBlip"]) do
                    local blip = AddBlipForCoord(workblip["Coords"])
                    SetBlipSprite(blip, workblip["Sprite"])
                    SetBlipDisplay(blip, 4)
                    SetBlipScale(blip, workblip["Scale"])
                    SetBlipColour(blip, workblip["Color"])
                    SetBlipAlpha(blip, workblip["Opacity"])
                    SetBlipAsShortRange(blip, true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString(workblip["Name"])
                    EndTextCommandSetBlipName(blip)
                    table.insert(workBlip, blip)
                    print("Blip added")
                    print(json.encode(workBlip))
                end
            end
        end
    end

    function ClearPrivateAmmuBlip()
        for _, blip in pairs(workBlip) do
            RemoveBlip(blip)
        end
        workBlip = {}
        print("Blip removed")
        print(json.encode(workBlip))
    end

    function AmmuNPC()
        for _, ammunation in pairs(AmmuZone) do
            local ammunpc = ammunation["NPC"]
            lib.requestModel(ammunpc["Model"])
            local npc = CreatePed(4, ammunpc["Model"], ammunpc["Coords"].x, ammunpc["Coords"].y, ammunpc["Coords"].z, ammunpc["Coords"].w, true, true)
            FreezeEntityPosition(npc, ammunpc["IsPedFrozen"])
            SetEntityInvincible(npc, ammunpc["IsPedInvincible"])
            SetBlockingOfNonTemporaryEvents(npc, true)
            TaskStartScenarioInPlace(npc, ammunpc["Scenario"], 0, true)
            SetModelAsNoLongerNeeded(ammunpc["Model"])
        end
    end

    local workNPC = {}

    function PrivateAmmuNPC()
        for _, ammunation in pairs(AmmuZone) do
            for _, workblip in pairs(ammunation["WorkNPC"]) do
                lib.requestModel(workblip["Model"])
                local npc = CreatePed(4, workblip["Model"], workblip["Coords"].x, workblip["Coords"].y, workblip["Coords"].z, workblip["Coords"].w, true, true)
                FreezeEntityPosition(npc, workblip["IsPedFrozen"])
                SetEntityInvincible(npc, workblip["IsPedInvincible"])
                SetBlockingOfNonTemporaryEvents(npc, true)
                TaskStartScenarioInPlace(npc, workblip["Scenario"], 0, true)
                SetModelAsNoLongerNeeded(workblip["Model"])
                table.insert(workNPC, npc)
                print("NPC added")
                print(json.encode(workNPC))
            end
        end
    end

    function ClearPrivateAmmuNPC()
        for _, npc in pairs(workNPC) do
            DeletePed(npc)
        end
        workNPC = {}
        print("NPC removed")
        print(json.encode(workNPC))
    end

    function AccessAccueilAmmuNPC()
        for region, ammunation in pairs(AmmuZone) do
            local ammunpc = ammunation["NPC"]
            exports.ox_target:addBoxZone(
                {
                    coords = vec3(ammunpc["Coords"].x, ammunpc["Coords"].y, ammunpc["Coords"].z + 1),
                    size = vec3(0.75, 0.75, 1.5),
                    rotation = 0,
                    debug = true,
                    options = {
                        {
                            name = "amunation_target_menu_" .. region,
                            label = "Armurier " .. region,
                            icon = "fas fa-shopping-cart",
                            iconColor = "#ffffff",
                            onSelect = function()
                                AccueilAmmuNPC(region)
                            end
                        }
                    }
                }
            )
        end
    end

    function AccueilAmmuNPC(region)
        if region == "Sud" then
            lib.registerContext({
                id = "main_menu_accueil_ammunation_south",
                title = "Récéption",
                options = {
                    {
                        title = "Prendre un RDV",
                        description = "Si vous souhaitez prendre un RDV",
                        icon = "fa-solid fa-card",
                        onSelect = function()
                            lib.showContext("rdv_choice_menu_ammunation")
                        end
                    },
                    -- {
                    --     title = "Prévenir un Armurier",
                    --     description = "Si vous souhaitez signaler votre présence à l'armurerie",
                    --     icon = "fa-solid fa-card",
                    --     onSelect = function()
                    --         TriggerServerEvent("ww-ammunation:Server:CallAmmu")
                    --     end
                    -- }
                }
            })
            lib.registerContext({
                id = "rdv_choice_menu_ammunation",
                title = "Prise de RDV",
                options = {
                    {
                        title = "Rendez-vous PPA ",
                        description = "Prendre un rendez-vous pour passez les tests médicaux du PPA",
                        icon = "fa-solid fa-card",
                        onSelect = function()
                            local input = lib.inputDialog("Information", {
                                {type = "input", label = "Nom", description = "Entrez votre nom", required = true, min = 4, max = 16},
                                {type = "input", label = "Prénom", description = "Entrez votre Prénom", required = true, min = 4, max = 16},
                                {type = "number", label = "Numéro de téléphone", description = "Entrez votre Numéro de téléphone", required = true},
                                {type = "input", label = "Jour Souhaité", description = "Entrez votre jour idéal pour le rendez-vous", required = true, min = 4, max = 16},
                                {type = "input", label = "Heure Souhaité", description = "Entrez votre heure idéal pour le rendez-vous", required = true, min = 4, max = 16},
                                {type = "input", label = "Motif", description = "Entrez le motif exact de votre demande de rendez-vous", required = true, min = 4, max = 16}
                            })
                            local payload = {
                                embeds = {
                                    {
                                        title = "__**Informations du RDV**__",
                                        fields = {
                                            { name = "__**JOUEUR**__", value = " "},
                                            { name = "Nom : ", value = input[1]},
                                            { name = "Prénom : ", value = input[2]},
                                            { name = "Numéro de téléphone : ", value = input[3]},
                                            { name = "**―――――――――――――――**", value = " "},
                                            { name = "__**DATE**__", value = " "},
                                            { name = "Jour Souhaité : ", value = input[4]},
                                            { name = "Heure Souhaitée : ", value = input[5]},
                                            { name = "**―――――――――――――――**", value = " "},
                                            { name = "__**RAISON**__", value = " "},
                                            { name = "Motif : ", value = input[6]}
                                        }
                                    }
                                },
                                avatar_url = "https://zupimages.net/up/23/31/qpud.png",
                                username = "Rendez-vous PPA"
                            }
                            if not input then return end
                            TriggerServerEvent("ww-ammunation:Server:SendWebhooksPPA_sud", payload)
                        end
                    }
                }
            })
            lib.showContext("main_menu_accueil_ammunation_south")
        elseif region == "Nord" then
            lib.registerContext({
                id = "main_menu_accueil_ammunation_north",
                title = "Récéption",
                options = {
                    -- {
                    --     title = "Prendre un RDV",
                    --     description = "Si vous souhaitez prendre un RDV",
                    --     icon = "fa-solid fa-card",
                    --     onSelect = function()
                    --         lib.showContext("rdv_choice_menu_ammunation")
                    --     end
                    -- },
                    {
                        title = "Prévenir un Armurier",
                        description = "Si vous souhaitez signaler votre présence à l'armurerie",
                        icon = "fa-solid fa-card",
                        onSelect = function()
                            TriggerServerEvent("ww-ammunation:Server:CallNorthAmmu")
                        end
                    }
                }
            })
            -- lib.registerContext({
            --     id = "rdv_choice_menu_ammunation",
            --     title = "Prise de RDV",
            --     options = {
            --         {
            --             title = "Rendez-vous PPA",
            --             description = "Prendre un rendez-vous pour passez les tests médicaux du PPA",
            --             icon = "fa-solid fa-card",
            --             onSelect = function()
            --                 local input = lib.inputDialog("Information", {
            --                     {type = "input", label = "Nom", description = "Entrez votre nom", required = true, min = 4, max = 16},
            --                     {type = "input", label = "Prénom", description = "Entrez votre Prénom", required = true, min = 4, max = 16},
            --                     {type = "number", label = "Numéro de téléphone", description = "Entrez votre Numéro de téléphone", required = true},
            --                     {type = "input", label = "Jour Souhaité", description = "Entrez votre jour idéal pour le rendez-vous", required = true, min = 4, max = 16},
            --                     {type = "input", label = "Heure Souhaité", description = "Entrez votre heure idéal pour le rendez-vous", required = true, min = 4, max = 16},
            --                     {type = "input", label = "Motif", description = "Entrez le motif exact de votre demande de rendez-vous", required = true, min = 4, max = 16}
            --                 })
            --                 local payload = {
            --                     embeds = {
            --                         {
            --                             title = "__**Informations du RDV**__",
            --                             fields = {
            --                                 { name = "__**JOUEUR**__", value = " "},
            --                                 { name = "Nom : ", value = input[1]},
            --                                 { name = "Prénom : ", value = input[2]},
            --                                 { name = "Numéro de téléphone : ", value = input[3]},
            --                                 { name = "**―――――――――――――――**", value = " "},
            --                                 { name = "__**DATE**__", value = " "},
            --                                 { name = "Jour Souhaité : ", value = input[4]},
            --                                 { name = "Heure Souhaitée : ", value = input[5]},
            --                                 { name = "**―――――――――――――――**", value = " "},
            --                                 { name = "__**RAISON**__", value = " "},
            --                                 { name = "Motif : ", value = input[6]}
            --                             }
            --                         }
            --                     },
            --                     avatar_url = "https://zupimages.net/up/23/31/qpud.png",
            --                     username = "Rendez-vous PPA"
            --                 }
            --                 if not input then return end
            --                 TriggerServerEvent("ww-ammunation:Server:SendWebhooksPPA", payload)
            --             end
            --         }
            --     }
            -- })
            lib.showContext("main_menu_accueil_ammunation_north")
        end
    end

    RegisterNetEvent("ww-ammunation:Client:CallReceived")
    AddEventHandler("ww-ammunation:Client:CallReceived", function()
        lib.notify({
            title = 'ARMURIER',
            description = "Un client vous appel à l'armurerie !!",
            position = 'top',
            type = 'info',
            duration = 5000,
        })
        PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", false)
    end)

    function AccesPrivateAmmuNPC()
            exports.ox_target:addBoxZone(
                {
                    coords = vec3(AmmuZone["Sud"].WorkNPC["Farm 1 Sud"].Coords.x, AmmuZone["Sud"].WorkNPC["Farm 1 Sud"].Coords.y, AmmuZone["Sud"].WorkNPC["Farm 1 Sud"].Coords.z + 1),
                    size = vec3(0.75, 0.75, 1.5),
                    rotation = 0,
                    debug = true,
                    options = {
                        {
                            name = "amunation_target_private_menu_sud1_start",
                            label = AmmuZone["Sud"].WorkNPC["Farm 1 Sud"].TargetLabelStart,
                            icon = "fas fa-shopping-cart",
                            iconColor = "#ffffff",
                            onSelect = function()
                                if ESX.PlayerData.job and ESX.PlayerData.job.name == "ammunation" then
                                    TriggerServerEvent("ww-ammunation:Server:startRecupFarm1")
                                else
                                    lib.notify({
                                        title = 'ARMURIER',
                                        description = "Vous n'êtes pas armurier !",
                                        position = 'top',
                                        type = 'error',
                                        duration = 5000,
                                    })
                                end
                            end
                        },
                        {
                            name = "amunation_target_private_menu_sud1_stop",
                            label = AmmuZone["Sud"].WorkNPC["Farm 1 Sud"].TargetLabelStop,
                            icon = "fas fa-shopping-cart",
                            iconColor = "#ffffff",
                            onSelect = function()
                                if ESX.PlayerData.job and ESX.PlayerData.job.name == "ammunation" then
                                    TriggerServerEvent("ww-ammunation:Server:stopRecupFarm1")
                                else
                                    lib.notify({
                                        title = 'ARMURIER',
                                        description = "Vous n'êtes pas armurier !",
                                        position = 'top',
                                        type = 'error',
                                        duration = 5000,
                                    })
                                end
                            end
                        }
                    }
                }
            )

            exports.ox_target:addBoxZone(
                {
                    coords = vec3(AmmuZone["Sud"].WorkNPC["Farm 2 Sud"].Coords.x, AmmuZone["Sud"].WorkNPC["Farm 2 Sud"].Coords.y, AmmuZone["Sud"].WorkNPC["Farm 2 Sud"].Coords.z + 1),
                    size = vec3(0.75, 0.75, 1.5),
                    rotation = 0,
                    debug = true,
                    options = {
                        {
                            name = "amunation_target_private_menu_sud2_start",
                            label = AmmuZone["Sud"].WorkNPC["Farm 2 Sud"].TargetLabelStart,
                            icon = "fas fa-shopping-cart",
                            iconColor = "#ffffff",
                            onSelect = function()
                                if ESX.PlayerData.job and ESX.PlayerData.job.name == "ammunation" then
                                    TriggerServerEvent("ww-ammunation:Server:startRecupFarm2")
                                else
                                    lib.notify({
                                        title = 'ARMURIER',
                                        description = "Vous n'êtes pas armurier !",
                                        position = 'top',
                                        type = 'error',
                                        duration = 5000,
                                    })
                                end
                            end
                        },
                        {
                            name = "amunation_target_private_menu_sud2_stop",
                            label = AmmuZone["Sud"].WorkNPC["Farm 2 Sud"].TargetLabelStop,
                            icon = "fas fa-shopping-cart",
                            iconColor = "#ffffff",
                            onSelect = function()
                                if ESX.PlayerData.job and ESX.PlayerData.job.name == "ammunation" then
                                    TriggerServerEvent("ww-ammunation:Server:stopRecupFarm2")
                                else
                                    lib.notify({
                                        title = 'ARMURIER',
                                        description = "Vous n'êtes pas armurier !",
                                        position = 'top',
                                        type = 'error',
                                        duration = 5000,
                                    })
                                end
                            end
                        }
                    }
                }
            )

            exports.ox_target:addBoxZone(
                {
                    coords = vec3(AmmuZone["Nord"].WorkNPC["Farm 1 Nord"].Coords.x, AmmuZone["Nord"].WorkNPC["Farm 1 Nord"].Coords.y, AmmuZone["Nord"].WorkNPC["Farm 1 Nord"].Coords.z + 1),
                    size = vec3(0.75, 0.75, 1.5),
                    rotation = 0,
                    debug = true,
                    options = {
                        {
                            name = "amunation_target_private_menu_nord1_start",
                            label = AmmuZone["Nord"].WorkNPC["Farm 1 Nord"].TargetLabelStart,
                            icon = "fas fa-shopping-cart",
                            iconColor = "#ffffff",
                            onSelect = function()
                                if ESX.PlayerData.job and ESX.PlayerData.job.name == "ammunation" then
                                    TriggerServerEvent("ww-ammunation:Server:startRecupFarm3")
                                else
                                    lib.notify({
                                        title = 'ARMURIER',
                                        description = "Vous n'êtes pas armurier !",
                                        position = 'top',
                                        type = 'error',
                                        duration = 5000,
                                    })
                                end
                            end
                        },
                        {
                            name = "amunation_target_private_menu_nord1_stop",
                            label = AmmuZone["Nord"].WorkNPC["Farm 1 Nord"].TargetLabelStop,
                            icon = "fas fa-shopping-cart",
                            iconColor = "#ffffff",
                            onSelect = function()
                                if ESX.PlayerData.job and ESX.PlayerData.job.name == "ammunation" then
                                    TriggerServerEvent("ww-ammunation:Server:stopRecupFarm3")
                                else
                                    lib.notify({
                                        title = 'ARMURIER',
                                        description = "Vous n'êtes pas armurier !",
                                        position = 'top',
                                        type = 'error',
                                        duration = 5000,
                                    })
                                end
                            end
                        }
                    }
                }
            )

            exports.ox_target:addBoxZone(
                {
                    coords = vec3(AmmuZone["Nord"].WorkNPC["Farm 2 Nord"].Coords.x, AmmuZone["Nord"].WorkNPC["Farm 2 Nord"].Coords.y, AmmuZone["Nord"].WorkNPC["Farm 2 Nord"].Coords.z + 1),
                    size = vec3(0.75, 0.75, 1.5),
                    rotation = 0,
                    debug = true,
                    options = {
                        {
                            name = "amunation_target_private_menu_nord2_start",
                            label = AmmuZone["Nord"].WorkNPC["Farm 2 Nord"].TargetLabelStart,
                            icon = "fas fa-shopping-cart",
                            iconColor = "#ffffff",
                            onSelect = function()
                                if ESX.PlayerData.job and ESX.PlayerData.job.name == "ammunation" then
                                    TriggerServerEvent("ww-ammunation:Server:startRecupFarm4")
                                else
                                    lib.notify({
                                        title = 'ARMURIER',
                                        description = "Vous n'êtes pas armurier !",
                                        position = 'top',
                                        type = 'error',
                                        duration = 5000,
                                    })
                                end
                            end
                        },
                        {
                            name = "amunation_target_private_menu_nord2_stop",
                            label = AmmuZone["Nord"].WorkNPC["Farm 2 Nord"].TargetLabelStop,
                            icon = "fas fa-shopping-cart",
                            iconColor = "#ffffff",
                            onSelect = function()
                                if ESX.PlayerData.job and ESX.PlayerData.job.name == "ammunation" then
                                    TriggerServerEvent("ww-ammunation:Server:stopRecupFarm4")
                                else
                                    lib.notify({
                                        title = 'ARMURIER',
                                        description = "Vous n'êtes pas armurier !",
                                        position = 'top',
                                        type = 'error',
                                        duration = 5000,
                                    })
                                end
                            end
                        }
                    }
                }
            )
    end

    function InteractionF6()
        lib.registerContext({
            id = "interact_ammu_menu",
            title = "Interaction",
            options = {
                {
                    title = "Facture",
                    description = "Pour pouvoir faire des factures",
                    icon = "fa-solid fa-card",
                    onSelect = function()
                        TriggerEvent("okokBilling:ToggleCreateInvoice")
                    end
                },
                {
                    title = "Annonce d'ouverture",
                    description = "Annonce pour savoir quand vous etes ouvert",
                    icon = "fa-solid fa-card",
                    onSelect = function()
                        TriggerServerEvent('ww-ammunation:Server:OpenAnnounce')
                    end
                },
                {
                    title = "Annonce de fermeture",
                    description = "Annonce pour savoir quand vous etes fermé",
                    icon = "fa-solid fa-card",
                    onSelect = function()
                        TriggerServerEvent('ww-ammunation:Server:CloseAnnounce')
                    end
                },
            }
        })
        lib.showContext("interact_ammu_menu")
    end

    CreateThread(function()
        while true do
            Wait(0)

            if IsControlJustReleased(0, 167) and ESX.PlayerData.job and ESX.PlayerData.job.name == 'ammunation' then
                InteractionF6()
            end

        end
    end)











-- If using QBCore, this script is currently not supported
elseif FrameworkUse == "QBCore" then
    return nil
end