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

    -- Register an event when the player is loaded
    RegisterNetEvent(playerLoadedEvent)
    AddEventHandler(playerLoadedEvent, function(xPlayer)
        ESX.PlayerData = xPlayer  -- Store player data locally
        PlayerLoaded = true
    end)

    AddEventHandler("onResourceStart", function(resource)
        if resource == GetCurrentResourceName() then
            NestAccess()
        end
    end)

    function NestAccess()
        local model = "v_ind_rc_balep1"
        exports.ox_target:addModel(model, {
            label = "Accéder à la ruche",
            name = "nest_access",
            icon = "fas fa-bezier-curve",
            iconColor = "#fff",
            onSelect = function()
                print("Accéder à la ruche")
                NestMenu()
            end
        })
    end

    function NestMenu()
        lib.registerContext({
            id = "nest_access_menu",
            title = "Ruche",
            options = {
                {
                    title = "Voir la production d'abeille",
                    description = "Voir la production d'abeille",
                    icon = "fas fa-bezier-curve",
                    onSelect = function()
                        print("Voir la production d'abeille")
                    end
                },
                {
                    title = "Voir la production de miel",
                    description = "Voir la production de miel",
                    icon = "fas fa-bezier-curve",
                    onSelect = function()
                        print("Voir la production de miel")
                    end
                },
                {
                    title = "Voir la production de cire",
                    description = "Voir la production de cire",
                    icon = "fas fa-bezier-curve",
                    onSelect = function()
                        print("Voir la production de cire")
                    end
                },
            }
        })
        lib.showContext("nest_access_menu")
    end



    RegisterCommand("test", function()
        lib.requestModel()
    end)


-- If using QBCore, this script is currently not supported
elseif FrameworkUse == "QBCore" then
    return nil
end