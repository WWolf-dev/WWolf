if FrameworkName == "ESX" then

    if VersionESX == "old" then
        ESX = nil
        CreateThread(function()
            while ESX == nil do
                TriggerEvent(getSharedObjectEvent, function(obj) ESX = obj end)
                Wait(0)
            end
        end)
    elseif VersionESX == "new" then
        CustomFrameworkExport()
    end

    	-- Event when a player is loaded
	RegisterNetEvent(playerLoadedEvent)
	AddEventHandler(playerLoadedEvent, function(xPlayer)
		ESX.PlayerData = xPlayer
		PlayerLoaded = true
	end)

    CreateThread(function()
        Blip()
    end)

    function Blip()
        for _, blips in pairs(RentingLocation) do
            local blip = AddBlipForCoord(blips["Coords"])
            SetBlipSprite(blip, blips["Sprite"])
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, blips["Scale"])
            SetBlipColour(blip, blips["Color"])
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(blips["Name"])
            EndTextCommandSetBlipName(blip)
        end
    end

















elseif FrameworkName == "QbCore" then
    return nil
end