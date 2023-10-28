RegisterNetEvent('ww-adminmenu:Server:revive', function(target)
    local adminPerms = AdminPerms(source)
    if not adminPerms or not adminPerms?.open then return false end
    TriggerClientEvent('ww-adminmenu:client:reviveCompatibility', target)
    -- if Webhooks.revive.enabled then
    --     local ids = (source)
    --     local tIds = GetPlayerInfo(target)
    --     TriggerEvent('wasabi_adminmenu:log', 'revive', Strings.discord_revive, (Strings.discord_revive_desc):format(ids.name, source, tIds.name, target, ids.name, source, ids.identifier, ids.steam, ids.discord, ids.license, ids.license2, ids.xbl, ids.fivem, tIds.name, target, tIds.identifier, tIds.steam, tIds.discord, tIds.license, tIds.license2, tIds.xbl, tIds.fivem))
    -- end
end)

RegisterNetEvent('ww-adminmenu:Server:heal', function(target)
    local adminPerms = AdminPerms(source)
    if not adminPerms or not adminPerms?.open then return false end
    TriggerClientEvent('ww-adminmenu:client:healCompatibility', target)
    -- if Webhooks.heal.enabled then
    --     local ids = GetPlayerInfo(source)
    --     local tIds = GetPlayerInfo(target)
    --     TriggerEvent('wasabi_adminmenu:log', 'heal', Strings.discord_heal, (Strings.discord_heal_desc):format(ids.name, source, tIds.name, target, ids.name, source, ids.identifier, ids.steam, ids.discord, ids.license, ids.license2, ids.xbl, ids.fivem, tIds.name, target, tIds.identifier, tIds.steam, tIds.discord, tIds.license, tIds.license2, tIds.xbl, tIds.fivem))
    -- end
end)

RegisterNetEvent('ww-adminmenu:Server:skinmenu', function(target)
    local adminPerms = AdminPerms(source)
    if not adminPerms or not adminPerms?.open then return false end
    TriggerClientEvent('ww-adminmenu:client:skinmenulCompatibility', target)
    -- if Webhooks.skin.enabled then
    --     local ids = GetPlayerInfo(source)
    --     local tIds = GetPlayerInfo(target)
    --     TriggerEvent('wasabi_adminmenu:log', 'skin', Strings.discord_skin, (Strings.discord_skin_desc):format(ids.name, source, tIds.name, target, ids.name, source, ids.identifier, ids.steam, ids.discord, ids.license, ids.license2, ids.xbl, ids.fivem, tIds.name, target, tIds.identifier, tIds.steam, tIds.discord, tIds.license, tIds.license2, tIds.xbl, tIds.fivem))
    -- end
end)

RegisterNetEvent('ww-adminmenu:Server:playerteleport', function(target, action, _source)
    local source = source
    if _source then source = _source end
    local adminPerms = AdminPerms(source)
    if not adminPerms or not adminPerms?.open then return false end
    if action == 'tpto' then
        SetEntityCoords(source, GetEntityCoords(GetPlayerPed(target)))
        -- if Webhooks.teleport.enabled then
        --     local ids = GetPlayerInfo(source)
        --     local tIds = GetPlayerInfo(target)
        --     TriggerEvent('wasabi_adminmenu:log', 'teleport', Strings.discord_teleport, (Strings.discord_goto_desc):format(ids.name, source, tIds.name, target, ids.name, source, ids.identifier, ids.steam, ids.discord, ids.license, ids.license2, ids.xbl, ids.fivem, tIds.name, target, tIds.identifier, tIds.steam, tIds.discord, tIds.license, tIds.license2, tIds.xbl, tIds.fivem))
        -- end
    elseif action == 'bring' then
        SetEntityCoords(target, GetEntityCoords(GetPlayerPed(source)))
        -- if Webhooks.teleport.enabled then
        --     local ids = GetPlayerInfo(source)
        --     local tIds = GetPlayerInfo(target)
        --     TriggerEvent('wasabi_adminmenu:log', 'teleport', Strings.discord_teleport, (Strings.discord_bring_desc):format(ids.name, source, tIds.name, target, ids.name, source, ids.identifier, ids.steam, ids.discord, ids.license, ids.license2, ids.xbl, ids.fivem, tIds.name, target, tIds.identifier, tIds.steam, tIds.discord, tIds.license, tIds.license2, tIds.xbl, tIds.fivem))
        -- end
    end
end)

RegisterNetEvent('ww-adminmenu:Server:announcement', function(message)
    TriggerClientEvent('chat:addMessage', -1, {
        color = { 255, 0, 0 },
        args = { 'Admin Announcement', message }
    })
end)