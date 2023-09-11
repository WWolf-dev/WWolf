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
                        label = "Accéder à la location véhicule",
                        onSelect = function()
                            print("Menu access success")
                            MenuNPC()
                        end
                    }
                }
            })
        end
    end

    function MenuNPC()
        if GetResourceState("ox_lib") ~= "missing" then
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
    end

    function CategoryMenu()
        local categoryOptions = {}
        for categoryName, categoryData in pairs(VehicleCategories) do
            table.insert(categoryOptions, {
                title = categoryData.title,
                description = categoryData.description,
                icon = categoryData.icon,
                onSelect = function()
                    print(categoryName .. json.encode(categoryData) .. " " .. json.encode(categoryData.vehicle))
                    VehicleMenu(categoryName, categoryData.vehicle)
                end
            })
        end

        lib.registerContext({
            id = "category_menu_npc_rental",
            title = "Choisissez une catégorie de véhicule",
            options = categoryOptions
        })

        lib.showContext("category_menu_npc_rental")
    end
    
    -- == VARIABLES GLOBALES ==
    local available = {}
    local maintenance = {}
    local rented = {}
    local rentedVehicles = {}

    -- == FONCTIONS UTILITAIRES ==
    local function hexToRGB(hex)
        hex = hex:gsub("#", "")
        return {
            tonumber("0x" .. hex:sub(1, 2)),
            tonumber("0x" .. hex:sub(3, 4)),
            tonumber("0x" .. hex:sub(5, 6))
        }
    end

    local function distance2D(vec1, vec2)
        return math.sqrt((vec2.x - vec1.x) ^ 2 + (vec2.y - vec1.y) ^ 2)
    end

    local function isVehicleNearCoords(coords, radius)
        local vehicles = ESX.Game.GetVehiclesInArea(coords, radius)
        return #vehicles > 0
    end

    -- == FONCTIONS PRINCIPALES ==
    function initializeVehicleAvailability()
        for _, data in pairs(VehicleCategories) do
            for _, vehicleData in pairs(data.vehicle) do
                if not available[vehicleData.name] then
                    available[vehicleData.name] = vehicleData.Quantity
                end
            end
        end
    end

    local function getAvailableRentLocation(maxRadius)
        local playerCoords = GetEntityCoords(PlayerPedId())
        for radius = 5, maxRadius, 5 do
            Citizen.Wait(200)
            for locationName, locationData in pairs(RentingNPC) do
                for _, vehicleData in pairs(locationData.Vehicle) do
                    if distance2D(vehicleData.VehicleSpawnPoint, playerCoords) < radius and not isVehicleNearCoords(vehicleData.VehicleSpawnPoint, 5) then
                        return vehicleData
                    end
                end
            end
        end
        return nil
    end

    function VehicleMenu(categoryName, vehicles)
        local vehicleOptions = {}
        for _, vehicleData in pairs(vehicles) do
            table.insert(vehicleOptions, {
                title = vehicleData.label,
                description = string.format(
                    "Disponibilité du véhicule :\n- Disponible : %d\n- Loué : %d\n- En maintenance : %d",
                    available[vehicleData.name] or 0,
                    rented[vehicleData.name] or 0,
                    maintenance[vehicleData.name] or 0
                ),
                icon = "fa-solid fa-car",
                onSelect = function()
                    print("Vous avez choisi le véhicule: " .. vehicleData.label)
                    if available[vehicleData.name] and available[vehicleData.name] > 0 then
                        local colorInput = lib.inputDialog('Configuration de Votre Véhicule', {
                            {
                                type = 'color', 
                                label = 'Couleur Carrosserie Principale',
                                description = "Choisissez la couleur primaire de votre véhicule",
                                default = '#ffffff',
                            },
                            {
                                type = 'color', 
                                label = 'Couleur Carrosserie Secondaire',
                                description = "Choisissez la couleur secondaire de votre véhicule",
                                default = '#ffffff',
                            }
                        })
                        if colorInput then
                            -- Update the available and rented lists now
                            available[vehicleData.name] = available[vehicleData.name] - 1
                            rented[vehicleData.name] = (rented[vehicleData.name] or 0) + 1
    
                            local primaryColor = hexToRGB(colorInput[1]) -- RGB values for primary color
                            local secondaryColor = hexToRGB(colorInput[2]) -- RGB values for secondary color
    
                            local rentLocation = getAvailableRentLocation(30) -- Maximum radius of 30 units
                            if rentLocation then
                                ESX.Game.SpawnVehicle(vehicleData.name, rentLocation.VehicleSpawnPoint, rentLocation.VehicleHeading, function(spawnedVehicle)
                                    SetVehicleCustomPrimaryColour(spawnedVehicle, primaryColor[1], primaryColor[2], primaryColor[3])
                                    SetVehicleCustomSecondaryColour(spawnedVehicle, secondaryColor[1], secondaryColor[2], secondaryColor[3])
    
                                    TaskWarpPedIntoVehicle(PlayerPedId(), spawnedVehicle, -1)
                                    local plateNumber = GetVehicleNumberPlateText(spawnedVehicle) -- Get the vehicle's number plate
    
                                    -- Insert the number plate and player ID to the rentedVehicles table
                                    table.insert(rentedVehicles, {plate = plateNumber, playerId = ESX.GetPlayerData().identifier})
    
                                    print(json.encode(rentedVehicles))
                                end)
                            else
                                print("Désolé, aucun emplacement de location n'est disponible en ce moment.")
                                return
                            end
    
                            print("Vous avez loué le véhicule: " .. vehicleData.label)
                            print("Il reste " .. available[vehicleData.name] .. " exemplaire(s) de ce véhicule.")
                            print("La catégorie 'available' contient " .. json.encode(available))
                            print("La catégorie 'maintenance' contient " .. json.encode(maintenance))
                            print("La catégorie 'rented' contient " .. json.encode(rented))
                        else
                            -- Si le joueur annule la sélection des couleurs, les compteurs ne sont pas touchés.
                            print("Sélection des couleurs annulée.")
                        end
                    else
                        -- Si le véhicule n'est pas disponible, nous informons le joueur.
                        print("Désolé, ce véhicule n'est pas disponible pour le moment.")
                    end
                end
            })
        end
    
        lib.registerContext({
            id = "vehicle_menu_" .. categoryName,
            title = "Choisissez un véhicule",
            menu = "category_menu_npc_rental",
            options = vehicleOptions
        })
    
        lib.showContext("vehicle_menu_" .. categoryName)
    end


    function ReturnVehicleMenu()
        local playerIdentifier = ESX.GetPlayerData().identifier
        local vehicleFound = false
    
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        -- Obtenir tous les véhicules dans un rayon de 30 unités
        local vehiclesNearby = ESX.Game.GetVehiclesInArea(playerCoords, 30.0)
    
        -- Parcourir tous les véhicules à proximité
        for _, vehicle in ipairs(vehiclesNearby) do
            local plateNumber = GetVehicleNumberPlateText(vehicle)
    
            -- Vérifier si la plaque d'immatriculation du véhicule est dans la table rentedVehicles et appartient au joueur
            for index, data in ipairs(rentedVehicles) do
                if data.plate == plateNumber and data.playerId == playerIdentifier then
                    -- Rendre le véhicule (détruire/retirer et mettre à jour les compteurs)
                    ESX.Game.DeleteVehicle(vehicle)
    
                    -- Update the available and rented lists
                    for name, count in pairs(rented) do
                        if count > 0 then
                            rented[name] = rented[name] - 1
                            available[name] = (available[name] or 0) + 1
                            break
                        end

                        if rented[name] == 0 then
                            rented[name] = nil
                        end
                        
                    end
    
                    table.remove(rentedVehicles, index)
                    print("Vous avez rendu le véhicule avec la plaque: " .. plateNumber)
                    print("La catégorie 'available' contient " .. json.encode(available))
                    print("La catégorie 'maintenance' contient " .. json.encode(maintenance))
                    print("La catégorie 'rented' contient " .. json.encode(rented))
                    print(json.encode(rentedVehicles))
                    vehicleFound = true
                    break
                end
            end
    
            if vehicleFound then
                break
            end
        end
    
        if not vehicleFound then
            print("Aucun véhicule loué trouvé à proximité.")
        end
    end


































        -- Soon QBCore support
elseif FrameworkUse == "QBCore" then
    return nil
end