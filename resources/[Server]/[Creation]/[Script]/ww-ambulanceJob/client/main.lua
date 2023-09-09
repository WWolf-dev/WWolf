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

    	-- Event when a player is setjob
	RegisterNetEvent(setJobEvent)
	AddEventHandler(setJobEvent, function(job)
		ESX.PlayerData.job = job
	end)
















elseif FrameworkName == "QbCore" then
    return nil
end