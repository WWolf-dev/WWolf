if FrameworkUse == "ESX" then
    if versionESX == "older" then
        ESX = nil
        TriggerEvent(getSharedObjectEvent, function(obj) ESX = obj end)
    elseif versionESX == "newer" then
        FrameworkExport()
    end

    TriggerEvent('esx_society:registerSociety', "ammunation", "Armurier", "society_ammunation", "society_ammunation", "society_ammunation", {type = 'private'})

	RegisterServerEvent("ww-ammunation:Server:SendWebhooksPPA_sud")
	AddEventHandler("ww-ammunation:Server:SendWebhooksPPA_sud", function(payload)
        sendDiscordLog(payload)
	end)

    RegisterServerEvent("ww-ammunation:Server:CallNorthAmmu")
    AddEventHandler("ww-ammunation:Server:CallNorthAmmu", function()
        local ammu = ESX.GetExtendedPlayers("job", "ammunation")
        if #ammu > 0 then
            for _, amu in pairs(ammu) do
                TriggerClientEvent("ww-ammunation:Client:CallReceived", amu.source)
                TriggerClientEvent('ox_lib:notify', source, {
					title = 'ARMURIER',
					description = "Votre appel a été envoyé aux armuriers en ville",
					position = 'top',
					type = 'info',
					duration = 5000,
				})
            end
        else
            TriggerClientEvent('ox_lib:notify', source, {
				title = 'ARMURIER',
				description = "Aucun Armurier en ville actuellement ",
				position = "top",
				type = 'inform',
				duration = 3500,
			})
        end
    end)



    local PlayersHarvesting = {}
    local function Farm1(source)
        if PlayersHarvesting[source] == true then
            local xPlayer = ESX.GetPlayerFromId(source)
            -- local itemQuantity = exports['qs-inventory']:GetItemTotalAmount(source, AmmuZone["Sud"].WorkNPC["Farm 1 Sud"].ItemToFarm)
            local itemQuantity = xPlayer.getInventoryItem(AmmuZone["Sud"].WorkNPC["Farm 1 Sud"].ItemToFarm).count

            if itemQuantity >= AmmuZone["Sud"].WorkNPC["Farm 1 Sud"].MaxItemToFarm then
                TriggerClientEvent('ox_lib:notify', source, {
                    title = 'ERREUR',
                    description = "Vous ne pouvez pas récupérer plus de " .. AmmuZone["Sud"].WorkNPC["Farm 1 Sud"].ItemToFarm,
                    position = "top",
                    type = 'error',
                    duration = 4000,
                })
                return
            end

            SetTimeout(AmmuZone["Sud"].WorkNPC["Farm 1 Sud"].TimeBetweenItem, function()
                xPlayer.addInventoryItem(AmmuZone["Sud"].WorkNPC["Farm 1 Sud"].ItemToFarm, 1)
                TriggerClientEvent('ox_lib:notify',  source, {
                    title = 'ARMURIER',
                    description = "Vous avez récupéré 1 " .. AmmuZone["Sud"].WorkNPC["Farm 1 Sud"].ItemToFarm,
                    position = "top",
                    type = 'inform',
                    duration = 5500,
                })
                Farm1(source)
            end)
        end
    end

    RegisterServerEvent('ww-ammunation:Server:startRecupFarm1')
	AddEventHandler('ww-ammunation:Server:startRecupFarm1', function()
		local _source = source
		PlayersHarvesting[_source] = true
	
		TriggerClientEvent('ox_lib:notify', _source, {
			title = 'ARMURIER',
			description = "Vous commencez à récupérer du " .. AmmuZone["Sud"].WorkNPC["Farm 1 Sud"].ItemToFarm,
			position = "top",
			type = 'inform',
			duration = 3500,
		})
	
		Farm1(source)
	end)

    RegisterServerEvent('ww-ammunation:Server:stopRecupFarm1')
	AddEventHandler('ww-ammunation:Server:stopRecupFarm1', function()
		local _source = source
		PlayersHarvesting[_source] = false
	
		TriggerClientEvent('ox_lib:notify', _source, {
			title = 'ARMURIER',
			description = "Vous arrêtez de récupérer du " .. AmmuZone["Sud"].WorkNPC["Farm 1 Sud"].ItemToFarm,
			position = "top",
			type = 'inform',
			duration = 3500,
		})
	end)


    local function Farm2(source)
        if PlayersHarvesting[source] == true then
            local xPlayer = ESX.GetPlayerFromId(source)
            -- local itemQuantity = exports['qs-inventory']:GetItemTotalAmount(source, AmmuZone["Sud"].WorkNPC["Farm 1 Sud"].ItemToFarm)
            local itemQuantity = xPlayer.getInventoryItem(AmmuZone["Sud"].WorkNPC["Farm 2 Sud"].ItemToFarm).count

            if itemQuantity >= AmmuZone["Sud"].WorkNPC["Farm 2 Sud"].MaxItemToFarm then
                TriggerClientEvent('ox_lib:notify', source, {
                    title = 'ERREUR',
                    description = "Vous ne pouvez pas récupérer plus de " .. AmmuZone["Sud"].WorkNPC["Farm 2 Sud"].ItemToFarm,
                    position = "top",
                    type = 'error',
                    duration = 4000,
                })
                return
            end

            SetTimeout(AmmuZone["Sud"].WorkNPC["Farm 2 Sud"].TimeBetweenItem, function()
                xPlayer.addInventoryItem(AmmuZone["Sud"].WorkNPC["Farm 2 Sud"].ItemToFarm, 1)
                TriggerClientEvent('ox_lib:notify',  source, {
                    title = 'ARMURIER',
                    description = "Vous avez récupéré 1 " .. AmmuZone["Sud"].WorkNPC["Farm 2 Sud"].ItemToFarm,
                    position = "top",
                    type = 'inform',
                    duration = 5500,
                })
                Farm2(source)
            end)
        end
    end

    RegisterServerEvent('ww-ammunation:Server:startRecupFarm2')
	AddEventHandler('ww-ammunation:Server:startRecupFarm2', function()
		local _source = source
		PlayersHarvesting[_source] = true
	
		TriggerClientEvent('ox_lib:notify', _source, {
			title = 'ARMURIER',
			description = "Vous commencez à récupérer du " ..AmmuZone["Sud"].WorkNPC["Farm 2 Sud"].ItemToFarm,
			position = "top",
			type = 'inform',
			duration = 3500,
		})
	
		Farm2(source)
	end)

    RegisterServerEvent('ww-ammunation:Server:stopRecupFarm2')
	AddEventHandler('ww-ammunation:Server:stopRecupFarm2', function()
		local _source = source
		PlayersHarvesting[_source] = false
	
		TriggerClientEvent('ox_lib:notify', _source, {
			title = 'ARMURIER',
			description = "Vous arrêtez de récupérer du " .. AmmuZone["Sud"].WorkNPC["Farm 2 Sud"].ItemToFarm,
			position = "top",
			type = 'inform',
			duration = 3500,
		})
	end)

    local function Farm3(source)
        if PlayersHarvesting[source] == true then
            local xPlayer = ESX.GetPlayerFromId(source)
            -- local itemQuantity = exports['qs-inventory']:GetItemTotalAmount(source, AmmuZone["Sud"].WorkNPC["Farm 1 Sud"].ItemToFarm)
            local itemQuantity = xPlayer.getInventoryItem(AmmuZone["Nord"].WorkNPC["Farm 1 Nord"].ItemToFarm).count

            if itemQuantity >= AmmuZone["Nord"].WorkNPC["Farm 1 Nord"].MaxItemToFarm then
                TriggerClientEvent('ox_lib:notify', source, {
                    title = 'ERREUR',
                    description = "Vous ne pouvez pas récupérer plus de " .. AmmuZone["Nord"].WorkNPC["Farm 1 Nord"].ItemToFarm,
                    position = "top",
                    type = 'error',
                    duration = 4000,
                })
                return
            end

            SetTimeout(AmmuZone["Nord"].WorkNPC["Farm 1 Nord"].TimeBetweenItem, function()
                xPlayer.addInventoryItem(AmmuZone["Nord"].WorkNPC["Farm 1 Nord"].ItemToFarm, 1)
                TriggerClientEvent('ox_lib:notify',  source, {
                    title = 'ARMURIER',
                    description = "Vous avez récupéré 1 " .. AmmuZone["Nord"].WorkNPC["Farm 1 Nord"].ItemToFarm,
                    position = "top",
                    type = 'inform',
                    duration = 5500,
                })
                Farm3(source)
            end)
        end
    end

    RegisterServerEvent('ww-ammunation:Server:startRecupFarm3')
	AddEventHandler('ww-ammunation:Server:startRecupFarm3', function()
		local _source = source
		PlayersHarvesting[_source] = true
	
		TriggerClientEvent('ox_lib:notify', _source, {
			title = 'ARMURIER',
			description = "Vous commencez à récupérer du " .. AmmuZone["Nord"].WorkNPC["Farm 1 Nord"].ItemToFarm,
			position = "top",
			type = 'inform',
			duration = 3500,
		})
	
		Farm3(source)
	end)

    RegisterServerEvent('ww-ammunation:Server:stopRecupFarm3')
	AddEventHandler('ww-ammunation:Server:stopRecupFarm3', function()
		local _source = source
		PlayersHarvesting[_source] = false
	
		TriggerClientEvent('ox_lib:notify', _source, {
			title = 'ARMURIER',
			description = "Vous arrêtez de récupérer du " .. AmmuZone["Nord"].WorkNPC["Farm 1 Nord"].ItemToFarm,
			position = "top",
			type = 'inform',
			duration = 3500,
		})
	end)

    local function Farm4(source)
        if PlayersHarvesting[source] == true then
            local xPlayer = ESX.GetPlayerFromId(source)
            -- local itemQuantity = exports['qs-inventory']:GetItemTotalAmount(source, AmmuZone["Sud"].WorkNPC["Farm 1 Sud"].ItemToFarm)
            local itemQuantity = xPlayer.getInventoryItem(AmmuZone["Nord"].WorkNPC["Farm 2 Nord"].ItemToFarm).count

            if itemQuantity >= AmmuZone["Nord"].WorkNPC["Farm 2 Nord"].MaxItemToFarm then
                TriggerClientEvent('ox_lib:notify', source, {
                    title = 'ERREUR',
                    description = "Vous ne pouvez pas récupérer plus de " .. AmmuZone["Nord"].WorkNPC["Farm 2 Nord"].ItemToFarm,
                    position = "top",
                    type = 'error',
                    duration = 4000,
                })
                return
            end

            SetTimeout(AmmuZone["Nord"].WorkNPC["Farm 2 Nord"].TimeBetweenItem, function()
                xPlayer.addInventoryItem(AmmuZone["Nord"].WorkNPC["Farm 2 Nord"].ItemToFarm, 1)
                TriggerClientEvent('ox_lib:notify',  source, {
                    title = 'ARMURIER',
                    description = "Vous avez récupéré 1 " .. AmmuZone["Nord"].WorkNPC["Farm 2 Nord"].ItemToFarm,
                    position = "top",
                    type = 'inform',
                    duration = 5500,
                })
                Farm4(source)
            end)
        end
    end

    RegisterServerEvent('ww-ammunation:Server:startRecupFarm4')
	AddEventHandler('ww-ammunation:Server:startRecupFarm4', function()
		local _source = source
		PlayersHarvesting[_source] = true
	
		TriggerClientEvent('ox_lib:notify', _source, {
			title = 'ARMURIER',
			description = "Vous commencez à récupérer du " .. AmmuZone["Nord"].WorkNPC["Farm 2 Nord"].ItemToFarm,
			position = "top",
			type = 'inform',
			duration = 3500,
		})
	
		Farm4(source)
	end)

    RegisterServerEvent('ww-ammunation:Server:stopRecupFarm4')
	AddEventHandler('ww-ammunation:Server:stopRecupFarm4', function()
		local _source = source
		PlayersHarvesting[_source] = false
	
		TriggerClientEvent('ox_lib:notify', _source, {
			title = 'ARMURIER',
			description = "Vous arrêtez de récupérer du " .. AmmuZone["Nord"].WorkNPC["Farm 2 Nord"].ItemToFarm,
			position = "top",
			type = 'inform',
			duration = 3500,
		})
	end)

    RegisterServerEvent('ww-ammunation:Server:OpenAnnounce')
	AddEventHandler('ww-ammunation:Server:OpenAnnounce', function()
		local _source = source
		local xPlayer = ESX.GetPlayerFromId(_source)
		local xPlayers	= ESX.GetPlayers()

		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

			-- if NotifServer == "ESX" then
				TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], "ARMURIER", "~g~OUVERTURE~s~", "Nous somme actuellement ouvert, passez au plus vite", "CHAR_ARTHUR", 8)
			-- elseif NotifServer == "OkOk" then
			-- 	TriggerClientEvent('okokNotify:Alert', xPlayers[i], "ARMURIER", "Nous somme actuellement fermé, repassez plus tard", 5000, "info")
			-- end

		end

	end)

	RegisterServerEvent('ww-ammunation:Server:CloseAnnounce')
	AddEventHandler('ww-ammunation:Server:CloseAnnounce', function()
		local _source = source
		local xPlayer = ESX.GetPlayerFromId(_source)
		local xPlayers	= ESX.GetPlayers()

		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

			-- if NotifServer == "ESX" then
				TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], "ARMURIER", "~r~FERMETURE~s~", "Nous somme actuellement fermé, repassez plus tard", "CHAR_ARTHUR", 8)
			-- elseif NotifServer == "OkOk" then
			-- 	TriggerClientEvent('okokNotify:Alert', xPlayers[i], "ARMURIER", "Nous somme actuellement fermé, repassez plus tard", 5000, "info")
			-- end

		end

	end)




    -- Soon QBCore support
elseif FrameworkUse == "QBCore" then
    return nil
end