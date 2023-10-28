local ServerSlots = GetConvarInt('sv_maxclients', 48)

lib.callback.register('ww-adminMenu:Server:slotCount', function(source)
    return ServerSlots
end)

lib.callback.register('ww-adminMenu:Server:checkPerms', function(source)
    if not ESX.GetPlayerFromId(source) then return false end
    return AdminPerms(source)
end)

local function GetIdentifier(source)
    local player = ESX.GetPlayerFromId(source)
    if not player then return false end
    return player.identifier
end

lib.callback.register('ww-adminMenu:Server:players', function(source)
    local players = GetPlayers()
    local SentPlayers = {}
    for i=1, #players do
        local player = tonumber(players[i])
        SentPlayers[#SentPlayers + 1] = {
            Name = GetPlayerName(player),
            identifier = GetIdentifier(player),
            Id = player
        }
    end
    local data = { SentPlayers = SentPlayers, PlayerCount = #players }
    return data
end)

local function GetName(source)
    local player = ESX.GetPlayerFromId(source)
    if not player then return false end
    return player.getName()
end

local function GetPlayerAccountFunds(source, type)
    if type == 'cash' then type = 'money' end
    local player = ESX.GetPlayerFromId(source)
    if not player then return end
    return player.getAccount(type).money
end

lib.callback.register('ww-adminMenu:Server:playerdata', function(source, target)
    local adminPerms = AdminPerms(source)
    if not adminPerms or not adminPerms?.open then return false end
    local data = {
        identifier = GetPlayerIdentifier(target, 0),
        xbl = GetPlayerIdentifier(target, 1),
        live = GetPlayerIdentifier(target, 2),
        igname = GetName(target),
        steamname = GetPlayerName(target),
        cash = GetPlayerAccountFunds(target, 'cash'),
        bank = GetPlayerAccountFunds(target, 'bank')
    }
    data.black_money = GetPlayerAccountFunds(target, 'black_money')
    return data
end)

lib.callback.register('ww-adminMenu:Server:freeze', function(source, target, toggle)
    local adminPerms = AdminPerms(source)
    if not adminPerms or not adminPerms?.open then return false end
    FreezeEntityPosition(target, toggle)
    -- if Webhooks.freeze.enabled then
    --     local ids = GetPlayerInfo(source)
    --     local tIds = GetPlayerInfo(target)
    --     if toggle then
    --         TriggerEvent('wasabi_adminmenu:log', 'freeze', Strings.discord_freeze, (Strings.discord_freeze_desc):format(ids.name, source, tIds.name, target, ids.name, source, ids.identifier, ids.steam, ids.discord, ids.license, ids.license2, ids.xbl, ids.fivem, tIds.name, target, tIds.identifier, tIds.steam, tIds.discord, tIds.license, tIds.license2, tIds.xbl, tIds.fivem))
    --     else
    --         TriggerEvent('wasabi_adminmenu:log', 'freeze', Strings.discord_not_freeze, (Strings.discord_not_freeze_desc):format(ids.name, source, tIds.name, target, ids.name, source, ids.identifier, ids.steam, ids.discord, ids.license, ids.license2, ids.xbl, ids.fivem, tIds.name, target, tIds.identifier, tIds.steam, tIds.discord, tIds.license, tIds.license2, tIds.xbl, tIds.fivem))
    --     end
    -- end
end)

lib.callback.register('ww-adminMenu:Server:noclip', function(source, target, toggle)
    local adminPerms = AdminPerms(source)
    if not adminPerms or not adminPerms?.open then return false end
    TriggerClientEvent('ww-adminmenu:Client:noclip', target, toggle)
    -- if Webhooks.noclip.enabled then
    --     local ids = GetPlayerInfo(source)
    --     local tIds = GetPlayerInfo(target)
    --     if toggle then
    --         TriggerEvent('wasabi_adminmenu:log', 'noclip', Strings.discord_noclip_player, (Strings.discord_noclip_player_desc):format(ids.name, source, tIds.name, target, ids.name, source, ids.identifier, ids.steam, ids.discord, ids.license, ids.license2, ids.xbl, ids.fivem, tIds.name, target, tIds.identifier, tIds.steam, tIds.discord, tIds.license, tIds.license2, tIds.xbl, tIds.fivem))
    --     else
    --         TriggerEvent('wasabi_adminmenu:log', 'noclip', Strings.discord_no_noclip_player, (Strings.discord_no_noclip_player_desc):format(ids.name, source, tIds.name, target, ids.name, source, ids.identifier, ids.steam, ids.discord, ids.license, ids.license2, ids.xbl, ids.fivem, tIds.name, target, tIds.identifier, tIds.steam, tIds.discord, tIds.license, tIds.license2, tIds.xbl, tIds.fivem))
    --     end
    -- end
end)

local function AddMoney(source, type, amount)
    if type == 'cash' then type = 'money' end
    local player = ESX.GetPlayerFromId(source)
    if not player then return end
    player.addAccountMoney(type, amount)
end

lib.callback.register('ww-adminMenu:Server:giveMoney', function(source, target, account, amount)
    local adminPerms = AdminPerms(source)
    if not adminPerms or not adminPerms?.open or not ESX.GetPlayerFromId(target) then return false end
    AddMoney(target, account, amount)
    -- if Webhooks.money.enabled then
    --     local ids = GetPlayerInfo(source)
    --     local tIds = GetPlayerInfo(target)
    --     TriggerEvent('wasabi_adminmenu:log', 'money', Strings.discord_money, (Strings.discord_money_desc):format(ids.name, source, tIds.name, target, amount, account, ids.name, source, ids.identifier, ids.steam, ids.discord, ids.license, ids.license2, ids.xbl, ids.fivem, tIds.name, target, tIds.identifier, tIds.steam, tIds.discord, tIds.license, tIds.license2, tIds.xbl, tIds.fivem))
    -- end
    return true
end)

local function AddItem(source, item, count, slot, metadata)
    local player = ESX.GetPlayerFromId(source)
    if not player then return end
    return player.addInventoryItem(item, count, metadata, slot)
end

lib.callback.register('ww-adminMenu:Server:giveitem', function(source, target, item, amount)
    local adminPerms = AdminPerms(source)
    if not adminPerms or not adminPerms?.open then return false end
    if ESX.GetPlayerFromId(target) then
        AddItem(target, item, amount)
        -- if Webhooks.item.enabled then
        --     local ids = GetPlayerInfo(source)
        --     local tIds = GetPlayerInfo(target)
        --     TriggerEvent('wasabi_adminmenu:log', 'item', Strings.discord_giveitem, (Strings.discord_giveitem_desc):format(ids.name, source, tIds.name, target, amount, item, ids.name, source, ids.identifier, ids.steam, ids.discord, ids.license, ids.license2, ids.xbl, ids.fivem, tIds.name, target, tIds.identifier, tIds.steam, tIds.discord, tIds.license, tIds.license2, tIds.xbl, tIds.fivem))
        -- end
        return 'success'
    else
        return 'error'
    end
end)

lib.callback.register('ww-adminMenu:Server:dropPlayer', function(source, target, reason)
    local adminPerms = AdminPerms(source)
    if not adminPerms or not adminPerms?.open then return false end
    local sourcePlayer = GetName(source)
    local targetPlayer = GetName(target)
    -- local tIds = GetPlayerInfo(target)
    -- if Webhooks.kick.enabled then
    --     local ids = GetPlayerInfo(source)
    --     TriggerEvent('wasabi_adminmenu:log', 'kick', Strings.discord_kick, (Strings.discord_kick_desc):format(ids.name, source, tIds.name, target, reason, ids.name, source, ids.identifier, ids.steam, ids.discord, ids.license, ids.license2, ids.xbl, ids.fivem, tIds.name, target, tIds.identifier, tIds.steam, tIds.discord, tIds.license, tIds.license2, tIds.xbl, tIds.fivem))

    -- end
    DropPlayer(target, "You have been kicked by : ".. sourcePlayer .. "\n" .. "\n" .. "REASON  :  " .. reason)
    print(targetPlayer .. " has been kicked by : ".. sourcePlayer .. "\n" ..  "REASON  :  " .. reason)
    -- return tIds.name
end)

lib.callback.register('ww-adminMenu:Server:banPlayer', function(source, target, time, reason)
    local adminPerms = AdminPerms(source)
    if not adminPerms or not adminPerms?.open or not ESX.GetPlayerFromId(target) then return false end
    return BanPlayer(target, time, reason, source)
end)