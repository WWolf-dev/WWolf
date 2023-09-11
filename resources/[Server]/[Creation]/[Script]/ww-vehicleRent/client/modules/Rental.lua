function CategoryMenu()
    local categoryOptions = {}
    for categoryName, categoryData in pairs(VehicleCategories) do
        table.insert(categoryOptions, {
            title = "Catégorie : " .. categoryName,
            description = "Choisssez un véhicule parmi les : " .. categoryName,
            icon = categoryData.IconOfCategory,
            onSelect = function()
                if DebugMode then
                    print(categoryName .. json.encode(categoryData) .. " " .. json.encode(categoryData.vehicle))
                end
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
                if DebugMode then
                    print("You have chosen the vehicle: " .. vehicleData.label)
                end
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

                                if DebugMode then
                                    print(json.encode(rentedVehicles))
                                end
                            end)
                        else
                            lib.notify({
                                title = 'ERREUR',
                                description = "Sorry, no rental locations are available at this time.",
                                position = 'top',
                                type = 'error'
                            })
                            return
                        end

                        lib.notify({
                            title = 'SUCCESS',
                            description = "You rented the vehicle : " .. vehicleData.label,
                            position = 'top',
                            type = 'success'
                        })
                        if DebugMode then
                            print("There are " .. available[vehicleData.name] .. " copies left of this vehicle.")
                            print("The 'available' category contains " .. json.encode(available))
                            print("The 'maintenance' category contains " .. json.encode(maintenance))
                            print("The 'rented' category contains " .. json.encode(rented))
                        end
                    else
                        -- Si le joueur annule la sélection des couleurs, les compteurs ne sont pas touchés.
                        if DebugMode then
                            print("Color selection canceled.")
                        end
                    end
                else
                    -- Si le véhicule n'est pas disponible, nous informons le joueur.
                    lib.notify({
                        title = 'ERROR',
                        description = "Sorry, this vehicle is not available at the moment.",
                        position = 'top',
                        type = 'error'
                    })
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
                lib.notify({
                    title = 'INFO',
                    description = "You returned the vehicle with the plate : " .. plateNumber,
                    position = 'top',
                    type = 'info'
                })
                if DebugMode then
                    print("The 'available' category contains " .. json.encode(available))
                    print("The 'maintenance' category contains " .. json.encode(maintenance))
                    print("The 'rented' category contains " .. json.encode(rented))
                    print(json.encode(rentedVehicles))
                end
                vehicleFound = true
                break
            end
        end

        if vehicleFound then
            break
        end
    end

    if not vehicleFound then
        lib.notify({
            title = 'ERROR',
            description = "No rental vehicles found nearby.",
            position = 'top',
            type = 'error'
        })
    end
end