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

    local jobBlips = {}

    	-- Event when a player is loaded
        RegisterNetEvent(playerLoadedEvent)
        AddEventHandler(playerLoadedEvent, function(xPlayer)
            ESX.PlayerData = xPlayer
            PlayerLoaded = true
        end)
    
    
    
        -- Event when a player is setjob
        RegisterNetEvent(setJobEvent)
        AddEventHandler(setJobEvent, function(job)
            ESX.PlayerData.job = job
            ClearJobBlips()
            PrivateBlip()
        end)

        function ClearJobBlips()
            for _, blip in ipairs(jobBlips) do
                RemoveBlip(blip.Blip)
            end
            jobBlips = {}
        end

        function PublicBlip()
            local isPublicBlipCreated = false
            if isPublicBlipCreated == false then
                local publicBlip = AddBlipForCoord(BlipEMSPublic.Coords)
                SetBlipSprite(publicBlip, BlipEMSPublic.Sprite)
                SetBlipDisplay(publicBlip, 4)
                SetBlipScale(publicBlip, BlipEMSPublic.Scale)
                SetBlipColour(publicBlip, BlipEMSPublic.Color)
                SetBlipAsShortRange(publicBlip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(BlipEMSPublic.Name)
                EndTextCommandSetBlipName(publicBlip)
                isPublicBlipCreated = true
            end
        end

        function PrivateBlip()
            if ESX.PlayerData.job and ESX.PlayerData.job.name == "ambulance" then
                for _, privateBlip in pairs(BlipsEMSWork) do
                    local blipPrivate = AddBlipForCoord(privateBlip["Coords"])
                    SetBlipSprite(blipPrivate, privateBlip["Sprite"])
                    SetBlipDisplay(blipPrivate, 4)
                    SetBlipScale(blipPrivate, privateBlip["Scale"])
                    SetBlipColour(blipPrivate, privateBlip["Color"])
                    SetBlipAsShortRange(blipPrivate, true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString(privateBlip["Name"])
                    EndTextCommandSetBlipName(blipPrivate)

                    table.insert(jobBlips, {Blip = blipPrivate, Name = privateBlip["Name"]})
                end
            end
        end

        function SpawnPed()
            for _, npcJob in pairs(SpawnNPCs) do
                lib.requestModel(npcJob["Name"])
                local npcPed = CreatePed(4, npcJob["Name"], npcJob["Coords"].x, npcJob["Coords"].y, npcJob["Coords"].z, npcJob["Coords"].w, false, true)
                SetEntityAsMissionEntity(npcPed, true, true)
                FreezeEntityPosition(npcPed, true)
                SetEntityInvincible(npcPed, true)
                SetBlockingOfNonTemporaryEvents(npcPed, true)
                TaskStartScenarioInPlace(npcPed, npcJob["Scenario"], 0, true)
                SetModelAsNoLongerNeeded(npcJob["Name"])
            end
        end

        function BossAccess()
            if UseTarget == "ox_target" then
                exports.ox_target:addBoxZone({
                    coords = vec3(SpawnNPCs["Boss"].Coords.x, SpawnNPCs["Boss"].Coords.y, SpawnNPCs["Boss"].Coords.z + 1),
                    size = vec3(1, 1, 1),
                    rotation = 45,
                    options = {
                        {
                            name = 'interact_EMS',
                            icon = "fa-solid fa-rectangle-list",
                            label = "Gérer l'entreprise",
                            onSelect = function()
                                if ESX.PlayerData.job and ESX.PlayerData.job.name == "ambulance" and ESX.PlayerData.job.grade_name == "boss" or ESX.PlayerData.job.grade_name == "second" then
                                    TriggerEvent('esx_society:openBossMenu', 'ambulance', function()
                                    end, { wash = false })
                                else
                                    lib.notify({
                                        title = 'ERREUR',
                                        description = "Vous n'avez pas la permission de faire cela",
                                        position = 'top',
                                        type = 'error'
                                    })
                                end
                            end
                        }
                    }
                })
            end
        end

        function FarmAccess()
            if UseTarget == "ox_target" then
                exports.ox_target:addBoxZone({
                    coords = vec3(FarmPharmacy["Coton"].TargetCoord.x, FarmPharmacy["Coton"].TargetCoord.y, FarmPharmacy["Coton"].TargetCoord.z + 1),
                    size = vec3(2, 2, 1.5),
                    options = {
                        {
                            name = 'start_recup_coton_ems',
                            icon = "fa-solid fa-rectangle-list",
                            label = "Récuperer du Coton",
                            onSelect = function()
                                if ESX.PlayerData.job and ESX.PlayerData.job.name == "ambulance" then
                                    TriggerServerEvent("Lys_EMS:Server:startRecupCoton")
                                else
                                    lib.notify({
                                        title = 'EMS',
                                        description = "Rien ne vous interesse dans cette étagère",
                                        position = 'top',
                                        type = 'info'
                                    })
                                end
                            end
                        },
                        {
                            name = 'stop_recup_coton_ems',
                            icon = "fa-solid fa-rectangle-list",
                            label = "Arreter de récupérer du Coton",
                            onSelect = function()
                                if ESX.PlayerData.job and ESX.PlayerData.job.name == "ambulance" then
                                    TriggerServerEvent("Lys_EMS:Server:stopRecupCoton")
                                else
                                    lib.notify({
                                        title = 'EMS',
                                        description = "Rien ne vous interesse dans cette étagère",
                                        position = 'top',
                                        type = 'info'
                                    })
                                end
                            end
                        },
                    }
                })



                exports.ox_target:addBoxZone({
                    coords = vec3(FarmPharmacy["Alcool"].TargetCoord.x, FarmPharmacy["Alcool"].TargetCoord.y, FarmPharmacy["Alcool"].TargetCoord.z + 1),
                    size = vec3(1.8, 2, 1.5),
                    options = {
                        {
                            name = 'start_recup_alcool_ems',
                            icon = "fa-solid fa-rectangle-list",
                            label = "Récuperer de l'alcool",
                            onSelect = function()
                                if ESX.PlayerData.job and ESX.PlayerData.job.name == "ambulance" then
                                    TriggerServerEvent("Lys_EMS:Server:startRecupAlcool")
                                else
                                    lib.notify({
                                        title = 'EMS',
                                        description = "Rien ne vous interesse dans cette étagère",
                                        position = 'top',
                                        type = 'info'
                                    })
                                end
                            end
                        },
                        {
                            name = 'stop_recup_alcool_ems',
                            icon = "fa-solid fa-rectangle-list",
                            label = "Arreter de récupérer de l'alcool",
                            onSelect = function()
                                if ESX.PlayerData.job and ESX.PlayerData.job.name == "ambulance" then
                                    TriggerServerEvent("Lys_EMS:Server:stopRecupAlcool")
                                else
                                    lib.notify({
                                        title = 'EMS',
                                        description = "Rien ne vous interesse dans cette étagère",
                                        position = 'top',
                                        type = 'info'
                                    })
                                end
                            end
                        },
                    }
                })



                exports.ox_target:addBoxZone({
                    coords = vec3(FarmPharmacy["Sparadrap"].TargetCoord.x, FarmPharmacy["Sparadrap"].TargetCoord.y, FarmPharmacy["Sparadrap"].TargetCoord.z + 1),
                    size = vec3(1, 2.2, 2),
                    options = {
                        {
                            name = 'start_recup_sparadrap_ems',
                            icon = "fa-solid fa-rectangle-list",
                            label = "Récuperer du sparadrap",
                            onSelect = function()
                                if ESX.PlayerData.job and ESX.PlayerData.job.name == "ambulance" then
                                    TriggerServerEvent("Lys_EMS:Server:startRecupSparadrap")
                                else
                                    lib.notify({
                                        title = 'EMS',
                                        description = "Rien ne vous interesse dans cette étagère",
                                        position = 'top',
                                        type = 'info'
                                    })
                                end
                            end
                        },
                        {
                            name = 'stop_recup_sparadrapsparadrap_ems',
                            icon = "fa-solid fa-rectangle-list",
                            label = "Arreter de récupérer du sparadrap",
                            onSelect = function()
                                if ESX.PlayerData.job and ESX.PlayerData.job.name == "ambulance" then
                                    TriggerServerEvent("Lys_EMS:Server:stopRecupSparadrap")
                                else
                                    lib.notify({
                                        title = 'EMS',
                                        description = "Rien ne vous interesse dans cette étagère",
                                        position = 'top',
                                        type = 'info'
                                    })
                                end
                            end
                        },
                    }
                })



                exports.ox_target:addBoxZone({
                    coords = vec3(FarmPharmacy["Plastique"].TargetCoord.x, FarmPharmacy["Plastique"].TargetCoord.y, FarmPharmacy["Plastique"].TargetCoord.z + 1),
                    size = vec3(1, 2.2, 2),
                    options = {
                        {
                            name = 'start_recup_plastic_ems',
                            icon = "fa-solid fa-rectangle-list",
                            label = "Récuperer du plastique",
                            onSelect = function()
                                if ESX.PlayerData.job and ESX.PlayerData.job.name == "ambulance" then
                                    TriggerServerEvent("Lys_EMS:Server:startRecupPlastique")
                                else
                                    lib.notify({
                                        title = 'EMS',
                                        description = "Rien ne vous interesse dans cette étagère",
                                        position = 'top',
                                        type = 'info'
                                    })
                                end
                            end
                        },
                        {
                            name = 'stop_recup_plastic_ems',
                            icon = "fa-solid fa-rectangle-list",
                            label = "Arreter de récupérer du plastique",
                            onSelect = function()
                                if ESX.PlayerData.job and ESX.PlayerData.job.name == "ambulance" then
                                    TriggerServerEvent("Lys_EMS:Server:stopRecupPlastique")
                                else
                                    lib.notify({
                                        title = 'EMS',
                                        description = "Rien ne vous interesse dans cette étagère",
                                        position = 'top',
                                        type = 'info'
                                    })
                                end
                            end
                        },
                    }
                })



                exports.ox_target:addBoxZone({
                    coords = vec3(FarmPharmacy["MedicalMask"].TargetCoord.x, FarmPharmacy["MedicalMask"].TargetCoord.y, FarmPharmacy["MedicalMask"].TargetCoord.z + 1),
                    size = vec3(2, 1.4, 1.8),
                    options = {
                        {
                            name = 'start_recup_medi_mask_ems',
                            icon = "fa-solid fa-rectangle-list",
                            label = "Récuperer un masque medicale",
                            onSelect = function()
                                if ESX.PlayerData.job and ESX.PlayerData.job.name == "ambulance" then
                                    TriggerServerEvent("Lys_EMS:Server:startRecupMedicalMask")
                                else
                                    lib.notify({
                                        title = 'EMS',
                                        description = "Rien ne vous interesse dans cette étagère",
                                        position = 'top',
                                        type = 'info'
                                    })
                                end
                            end
                        },
                        {
                            name = 'stop_recup_medi_mask_ems',
                            icon = "fa-solid fa-rectangle-list",
                            label = "Arreter de récupérer un masque medicale",
                            onSelect = function()
                                if ESX.PlayerData.job and ESX.PlayerData.job.name == "ambulance" then
                                    TriggerServerEvent("Lys_EMS:Server:stopRecupMedicalMask")
                                else
                                    lib.notify({
                                        title = 'EMS',
                                        description = "Rien ne vous interesse dans cette étagère",
                                        position = 'top',
                                        type = 'info'
                                    })
                                end
                            end
                        },
                    }
                })



                exports.ox_target:addBoxZone({
                    coords = vec3(FarmPharmacy["Oxygene"].TargetCoord.x, FarmPharmacy["Oxygene"].TargetCoord.y, FarmPharmacy["Oxygene"].TargetCoord.z + 1),
                    size = vec3(2, 1.6, 1.8),
                    options = {
                        {
                            name = 'start_recup_oxygen_ems',
                            icon = "fa-solid fa-rectangle-list",
                            label = "Récuperer des capsules d'oxygène",
                            onSelect = function()
                                if ESX.PlayerData.job and ESX.PlayerData.job.name == "ambulance" then
                                    TriggerServerEvent("Lys_EMS:Server:startRecupOxygene")
                                else
                                    lib.notify({
                                        title = 'EMS',
                                        description = "Rien ne vous interesse dans cette étagère",
                                        position = 'top',
                                        type = 'info'
                                    })
                                end
                            end
                        },
                        {
                            name = 'stop_recup_oxygen_ems',
                            icon = "fa-solid fa-rectangle-list",
                            label = "Arreter de récupérer des capsules d'oxygène",
                            onSelect = function()
                                if ESX.PlayerData.job and ESX.PlayerData.job.name == "ambulance" then
                                    TriggerServerEvent("Lys_EMS:Server:stopRecupOxygene")
                                else
                                    lib.notify({
                                        title = 'EMS',
                                        description = "Rien ne vous interesse dans cette étagère",
                                        position = 'top',
                                        type = 'info'
                                    })
                                end
                            end
                        },
                    }
                })



                exports.ox_target:addBoxZone({
                    coords = vec3(FarmPharmacy["Defibrilateur"].TargetCoord.x, FarmPharmacy["Defibrilateur"].TargetCoord.y, FarmPharmacy["Defibrilateur"].TargetCoord.z + 1),
                    size = vec3(1, 2.2, 2),
                    options = {
                        {
                            name = 'start_recup_defibrilateur_ems',
                            icon = "fa-solid fa-rectangle-list",
                            label = "Récuperer un defibrilateur",
                            onSelect = function()
                                if ESX.PlayerData.job and ESX.PlayerData.job.name == "ambulance" then
                                    TriggerServerEvent("Lys_EMS:Server:startRecupDefibrilateur")
                                else
                                    lib.notify({
                                        title = 'EMS',
                                        description = "Rien ne vous interesse dans cette étagère",
                                        position = 'top',
                                        type = 'info'
                                    })
                                end
                            end
                        },
                        {
                            name = 'stop_recup_defibrilateur_ems',
                            icon = "fa-solid fa-rectangle-list",
                            label = "Arreter de récupérer un defibrilateur",
                            onSelect = function()
                                if ESX.PlayerData.job and ESX.PlayerData.job.name == "ambulance" then
                                    TriggerServerEvent("Lys_EMS:Server:stopRecupDefibrilateur")
                                else
                                    lib.notify({
                                        title = 'EMS',
                                        description = "Rien ne vous interesse dans cette étagère",
                                        position = 'top',
                                        type = 'info'
                                    })
                                end
                            end
                        },
                    }
                })
            end
        end


        local function AccueilMenu()
            lib.registerContext({
                id = "main_menu_accueil_ems",
                title = "Récéption",
                options = {
                    {
                        title = "Prendre un RDV",
                        description = "Si vous souhaitez prendre un RDV",
                        icon = "fa-solid fa-card",
                        onSelect = function()
                            lib.showContext("rdv_choice_menu_ems")
                        end
                    },
                    {
                        title = "Prévenir un Médecin",
                        description = "Si vous souhaitez signaler votre présence à l'hopital",
                        icon = "fa-solid fa-card",
                        onSelect = function()
                            TriggerServerEvent("Lys_EMS:Server!CallDoc")
                        end
                    }
                }
            })

            lib.registerContext({
                id = "rdv_choice_menu_ems",
                title = "Prise de RDV",
                options = {
                    {
                        title = "Rendez-vous PPA",
                        description = "Prendre un rendez-vous pour passez les tests médicaux du PPA",
                        icon = "fa-solid fa-card",
                        onSelect = function()
                            local input = lib.inputDialog("Information", {
                                {type = "input", label = "Nom", description = "Entrez votre nom", required = true, min = 4, max = 16},
                                {type = "input", label = "Prénom", description = "Entrez votre Prénom", required = true, min = 4, max = 16},
                                {type = "number", label = "Numéro de téléphone", description = "Entrez votre Numéro de téléphone", required = true},
                                {type = "input", label = "Jour Souhaité", description = "Entrez votre jour idéal pour le rendez-vous", required = true, min = 4, max = 16},
                                {type = "input", label = "Heure Souhaité", description = "Entrez votre heure idéal pour le rendez-vous", required = true, min = 4, max = 16},
                                {type = "input", label = "Motif", description = "Entrez le motif exacat de votre demande de rendez-vous", required = true, min = 4, max = 16}
                            })
                            local payload = {
                                embeds = {
                                    {
                                        title = "__Informations__",
                                        fields = {
                                            { name = "Nom : ", value = input[1]},
                                            { name = "Prénom : ", value = input[2]},
                                            { name = "Numéro de téléphone : ", value = input[3]},
                                            { name = "Jour Souhaité : ", value = input[4]},
                                            { name = "Heure Souhaitée : ", value = input[5]},
                                            { name = "Motif : ", value = input[6]}
                                        }
                                    }
                                },
                                avatar_url = "https://banner2.cleanpng.com/20180704/qrt/kisspng-logo-military-tactics-tactical-emergency-medical-s-rebel-armed-forces-5b3c63811db339.2078892615306842891217.jpg",
                                username = "Rendez-vous PPA"
                            }
                            if not input then return end
                            TriggerServerEvent("Lys_EMS:Server:SendWebhooksPPA", payload)
                        end
                    },
                    {
                        title = "Rendez-vous Check Up",
                        description = "Prendre un rendez-vous pour faire un check up complet",
                        icon = "fa-solid fa-card",
                        onSelect = function()
                            local input = lib.inputDialog("Information", {
                                {type = "input", label = "Nom", description = "Entrez votre nom", required = true, min = 4, max = 16},
                                {type = "input", label = "Prénom", description = "Entrez votre Prénom", required = true, min = 4, max = 16},
                                {type = "number", label = "Numéro de téléphone", description = "Entrez votre Numéro de téléphone", required = true},
                                {type = "input", label = "Jour Souhaité", description = "Entrez votre jour idéal pour le rendez-vous", required = true, min = 4, max = 16},
                                {type = "input", label = "Heure Souhaité", description = "Entrez votre heure idéal pour le rendez-vous", required = true, min = 4, max = 16},
                                {type = "input", label = "Motif", description = "Entrez le motif exacat de votre demande de rendez-vous", required = true, min = 4, max = 16}
                            })
                            local payload = {
                                embeds = {
                                    {
                                        title = "__Informations__",
                                        fields = {
                                            { name = "Nom : ", value = input[1]},
                                            { name = "Prénom : ", value = input[2]},
                                            { name = "Numéro de téléphone : ", value = input[3]},
                                            { name = "Jour Souhaité : ", value = input[4]},
                                            { name = "Heure Souhaitée : ", value = input[5]},
                                            { name = "Motif : ", value = input[6]}
                                        }
                                    }
                                },
                                avatar_url = "https://www.freepnglogos.com/uploads/medicine-logo-png-1.png",
                                username = "Rendez-vous Check up Complet"
                            }
                            if not input then return end
                            TriggerServerEvent("Lys_EMS:Server:SendWebhooksCheckup", payload)
                        end
                    },
                    {
                        title = "Rendez-vous Recrutement",
                        description = "Prendre un rendez-vous pour passez les recrutements chez les EMS",
                        icon = "fa-solid fa-card",
                        onSelect = function()
                            local input = lib.inputDialog("Information", {
                                {type = "input", label = "Nom", description = "Entrez votre nom", required = true, min = 4, max = 16},
                                {type = "input", label = "Prénom", description = "Entrez votre Prénom", required = true, min = 3, max = 15},
                                {type = "number", label = "Numéro de téléphone", description = "Entrez votre Numéro de téléphone", required = true},
                                {type = "input", label = "Jour Souhaité", description = "Entrez votre jour idéal pour le rendez-vous", required = true, min = 4, max = 16},
                                {type = "input", label = "Heure Souhaité", description = "Entrez votre heure idéal pour le rendez-vous", required = true, min = 4, max = 16},
                                {type = "input", label = "Motif", description = "Entrez le motif exacat de votre demande de rendez-vous", required = true, min = 4, max = 16}
                            })
                            local payload = {
                                embeds = {
                                    {
                                        title = "__Informations__",
                                        fields = {
                                            { name = "Nom : ", value = input[1]},
                                            { name = "Prénom : ", value = input[2]},
                                            { name = "Numéro de téléphone : ", value = input[3]},
                                            { name = "Jour Souhaité : ", value = input[4]},
                                            { name = "Heure Souhaitée : ", value = input[5]},
                                            { name = "Motif : ", value = input[6]}
                                        }
                                    }
                                },
                                avatar_url = "https://cdn-icons-png.flaticon.com/512/942/942830.png",
                                username = "Rendez-vous Recrutement"
                            }
                            if not input then return end
                            TriggerServerEvent("Lys_EMS:Server:SendWebhooksRecruit", payload)
                        end
                    }
                }
            })

            lib.showContext("main_menu_accueil_ems")
        end

        RegisterNetEvent("Lys_EMS:Client!ReceiveCall")
        AddEventHandler("Lys_EMS:Client!ReceiveCall", function()
            lib.notify({
                title = 'EMS',
                description = "Un patient vous appel à l'hopital !!",
                position = 'top',
                type = 'info',
                duration = 5000,
            })

            -- Jouer un son pour alerter le joueur
            PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", false)

            -- Ajouter d'autres actions que tu souhaites effectuer lors de la réception de l'appel
        end)

        function AccueilAccess()
            if UseTarget == "ox_target" then
                exports.ox_target:addBoxZone({
                    coords = vec3(SpawnNPCs["Accueil"].Coords.x, SpawnNPCs["Accueil"].Coords.y, SpawnNPCs["Accueil"].Coords.z + 1),
                    size = vec3(1, 1, 1.6),
                    options = {
                        {
                            name = 'interact_EMS_accueil',
                            icon = "fa-solid fa-rectangle-list",
                            label = "Parler au récéptionniste",
                            onSelect = function()
                                AccueilMenu()
                            end
                        }
                    }
                })
            end
        end

        function AscenseurAcces()
            if UseTarget == "ox_target" then
                for _, targett in ipairs(Ascenseur1Target) do
                    exports.ox_target:addBoxZone({
                        coords = vec3(targett.TargetCoords.x, targett.TargetCoords.y, targett.TargetCoords.z),
                        size = vec3(0.3, 0.3, 0.4),
                        rotation = -5,
                        debug = true,
                        options = {
                            {
                                name = 'interact_EMS_elevator',
                                icon = "fa-solid fa-rectangle-list",
                                label = "Accéder à un autre étage",
                                onSelect = function()
                                    local input = lib.inputDialog("Choisir un Etage", {
                                        {type = 'number', label = 'Etage', description = "Choisissez l'etage ou vous souhaitez aller",  min = -1, max = 3},
                                    })
                                    print(json.encode(input))
                                    if input[1] == -1 or 0 or 1 or 2 or 3 then
                                        local player = PlayerPedId()
                                        DoScreenFadeOut(2500)
                                        Wait(5000)
                                        SetEntityInvincible(player, true)
                                        FreezeEntityPosition(player, true)
                                        ESX.Game.Teleport(player, targett.TpCoords, function()
                                            Wait(5000)
                                            FreezeEntityPosition(player, false)
                                            SetEntityInvincible(player, false)
                                            Wait(2500)
                                            DoScreenFadeIn(2500)
                                        end)
                                    end
                                end
                            }
                        }
                    })
                end
            end
        end
        

        CreateThread(function()
            PublicBlip()
            SpawnPed()
            BossAccess()
            AccueilAccess()
            FarmAccess()
            AscenseurAcces()
        end)


        -- Soon QBCore support
elseif FrameworkUse == "QBCore" then
    return nil
end