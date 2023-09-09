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

































        -- Soon QBCore support
elseif FrameworkUse == "QBCore" then
    return nil
end