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

    function UseKey()
        lib.registerContext({
            id = "BlackMarket_main_menu",
            title = "Black Market",
            icon = "fas fa-shopping-cart",
            options = {
                {
                    title = "Buy",
                    description = "Buy items from the black market",
                    icon = "fas fa-shopping-cart",
                    onSelected = function()
                        print("Buy selected")
                    end
                }
            }
        })

        lib.showContext("BlackMarket_main_menu")
    end

    RegisterNetEvent("ww-blackMarket:Client:openMenu")
    AddEventHandler("ww-blackMarket:Client:openMenu", function()
        UseKey()
    end)







-- If using QBCore, this script is currently not supported
elseif FrameworkUse == "QBCore" then
    return nil
end