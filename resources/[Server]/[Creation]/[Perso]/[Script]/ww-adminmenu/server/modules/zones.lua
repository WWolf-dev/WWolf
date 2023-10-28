local zones = {}

RegisterNetEvent('ww-adminmenu:server:createZone', function(zone)
    local adminPerms = AdminPerms(source)
    if not adminPerms or not adminPerms?.open then return false end
    zones[#zones + 1] = zone
    TriggerClientEvent('ww-adminmenu:client:refreshZones', -1, zones)
    -- if Webhooks.zones.enabled then
    --     local ids = GetPlayerInfo(source)
    --     TriggerEvent('wasabi_adminmenu:log', 'zones', Strings.discord_create_zone, (Strings.discord_create_zone_desc):format(ids.name, source, zone.name, ids.name, source, ids.identifier, ids.steam, ids.discord, ids.license, ids.license2, ids.xbl, ids.fivem))
    -- end
end)

lib.callback.register('ww-adminmenu:server:deleteZone', function(source, zone)
    local adminPerms = AdminPerms(source)
    if not adminPerms or not adminPerms?.open then return false end
    local success
    for k,v in pairs(zones) do
        if (v.name == zone.name and v.coords == zone.coords) then zones[k] = nil success = true break end
    end
    if not success then return success end
    local oldZones = zones
    zones = {}
    for k,v in pairs(oldZones) do
        if v and v?.name then zones[#zones + 1] = v end
    end
    TriggerClientEvent('ww-adminmenu:client:refreshZones', -1, zones)
    -- if Webhooks.zones.enabled then
    --     local ids = GetPlayerInfo(source)
    --     TriggerEvent('wasabi_adminmenu:log', 'zones', Strings.discord_delete_zone, (Strings.discord_delete_zone_desc):format(ids.name, source, zone.name, ids.name, source, ids.identifier, ids.steam, ids.discord, ids.license, ids.license2, ids.xbl, ids.fivem))
    -- end
    return success
end)

lib.callback.register('ww-adminmenu:server:editZone', function(source, oldData, newData)
    local success
    for k,v in pairs(zones) do
        if (v.name == oldData.name) and (v.coords == oldData.coords) then zones[k] = newData success = true break end
    end
    if not success then return success end
    TriggerClientEvent('ww-adminmenu:client:refreshZones', -1, zones)
    -- if Webhooks.zones.enabled then
    --     local ids = GetPlayerInfo(source)
    --     TriggerEvent('wasabi_adminmenu:log', 'zones', Strings.discord_edit_zone, (Strings.discord_edit_zone_desc):format(ids.name, source, oldData.name, ids.name, source, ids.identifier, ids.steam, ids.discord, ids.license, ids.license2, ids.xbl, ids.fivem))
    -- end
    return success
end)

lib.callback.register('ww-adminmenu:server:refreshZones', function(source)
    return zones
end)