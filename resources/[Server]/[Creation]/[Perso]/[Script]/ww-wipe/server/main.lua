if FrameworkUse == "ESX" then
    if versionESX == "older" then
        ESX = nil
        TriggerEvent(getSharedObjectEvent, function(obj) ESX = obj end)
    elseif versionESX == "newer" then
        FrameworkExport()
    end

    -- ESX.RegisterCommand(CommandName, AllowedGradeToWipe, function(xPlayer, args, showError)
    --     -- Par défaut, utilise l'ID du joueur qui a exécuté la commande
    --     local targetID = xPlayer.source

    --     -- Si un argument a été fourni, utilise cet argument comme ID du joueur cible
    --     if args[1] then
    --         targetID = tonumber(args[1])
    --     end

    --     -- Vérifie si le joueur est en ligne
    --     local targetPlayer = ESX.GetPlayerFromId(targetID)
    --     if targetPlayer then
    --         local identifier = targetPlayer.getIdentifier()

    --         sendDiscordLog(xPlayer, targetPlayer) -- Envoie le log avant de déconnecter le joueur

    --         -- Déconnecte le joueur
    --         DropPlayer(targetID, TranslateCap("player_dropped"))

    --         for i, table in ipairs(TableToWype) do
    --             local query = string.format("DELETE FROM %s WHERE identifier = @identifier", table)

    --             if table == "addon_account_data" or table == "addon_inventory_items" or table == "datastore_data" or table == "owned_vehicles" or table == "user_licenses" then
    --                 query = string.format("DELETE FROM %s WHERE owner = @identifier", table)
    --             end

    --             if GetResourceState("ox_inventory") ~= "missing" then
    --                 if table == "ox_inventory" then
    --                     query = string.format("DELETE FROM %s WHERE owner = @identifier", table)
    --                 end
    --             end

    --             if GetResourceState("illenium-appearance") ~= "missing" then
    --                 if table == "playerskins" or table == "player_outfits" then
    --                     query = string.format("DELETE FROM %s WHERE citizenid = @identifier", table)
    --                 end
    --             end

    --             MySQL.Async.execute(query, { ['@identifier'] = identifier }, function(rowsChanged)
    --                 if rowsChanged == 0 then
    --                     print(TranslateCap("no_data_found") .. identifier .. TranslateCap("inside_table") .. table .. "\".")
    --                 else
    --                     print(TranslateCap("user_data") .. identifier .. TranslateCap("erase_from_table") .. table .. '".')
    --                 end
    --             end,

    --             function(err)
    --                 print(TranslateCap("error_during_request") .. err)
    --             end)

    --         end

    --     else
    --         showError(TranslateCap("player_not_found"))
    --     end
    -- end, false, {help = TranslateCap("help_command"), validate = false,arguments = {{ name = 'targetID', help = TranslateCap("help_args") }}})

    ESX.RegisterCommand(CommandName, AllowedGradeToWipe, function(xPlayer, args, showError)
        -- Par défaut, utilise l'ID du joueur qui a exécuté la commande
        local targetID = xPlayer.source

        -- Si un argument a été fourni, utilise cet argument comme ID du joueur cible
        if args[1] then
            targetID = tonumber(args[1])
        end

        -- Vérifie si le joueur est en ligne
        local targetPlayer = ESX.GetPlayerFromId(targetID)
        if targetPlayer then
            local identifier = targetPlayer.getIdentifier()

            sendDiscordLog(xPlayer, targetPlayer) -- Envoie le log avant de déconnecter le joueur

            -- Déconnecte le joueur
            DropPlayer(targetID, TranslateCap("player_dropped"))

            for _, entry in ipairs(TableToWype) do
                local tableName = entry.table
                local column = entry.IdentifierColumn

                local query = string.format("DELETE FROM %s WHERE %s = @identifier", tableName, column)

                MySQL.Async.execute(query, { ['@identifier'] = identifier }, function(rowsChanged)
                    if rowsChanged == 0 then
                        if EnableDebug then
                            print(TranslateCap("no_data_found") .. identifier .. TranslateCap("inside_table") .. tableName .. "\".")
                        end
                    else
                        if EnableDebug then
                            print(TranslateCap("user_data") .. identifier .. TranslateCap("erase_from_table") .. tableName .. '".')
                        end
                    end
                end,

                function(err)
                    print(TranslateCap("error_during_request") .. err)
                end)
            end

        else
            showError(TranslateCap("player_not_found"))
        end
    end, false, {help = TranslateCap("help_command"), validate = false,arguments = {{ name = 'targetID', help = TranslateCap("help_args") }}})



    -- Soon QBCore support
elseif FrameworkUse == "QBCore" then
    return nil
end
