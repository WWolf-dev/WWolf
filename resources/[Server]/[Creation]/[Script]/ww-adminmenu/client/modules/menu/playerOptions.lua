local ServerSlots = 48
local Freezed, Noclip

CreateThread(function()
    local slotCount = lib.callback.await('ww-adminMenu:Server:slotCount', 100)
    if slotCount then
        ServerSlots = slotCount
    end
end)

local function givePlayerMoney(target, name)
    local dialogOptions = {
        { value = 'money', label = Strings.givemoney_select_option1 },
        { value = 'bank', label = Strings.givemoney_select_option2 }
    }
    -- if wsb.framework == 'esx' then
        dialogOptions[#dialogOptions + 1] = {
            value = 'black_money', label = Strings.givemoney_select_option3
        }
    -- end
    local Dialog = lib.inputDialog(Strings.dialog_givemoney, {
        { type = 'input', label = Strings.givemoney_input_label, placeholder = Strings.givemoney_input_placeholder },
        { type = 'select', label = Strings.givemoney_select, options = dialogOptions }
    })
    if not Dialog then lib.showContext("admin_menu_playeroptions_handle") return end
    local success = lib.callback.await('ww-adminMenu:Server:giveMoney', 100, target, Dialog[2], tonumber(Dialog[1]))
    if success then
        -- TriggerEvent('wasabi_bridge:notify', Strings.notify_givemoney_success,(Strings.notify_givemoney_success_desc:format(name, Dialog[1], Dialog[2])), 'success', 'fa-check')
    else
        -- TriggerEvent('wasabi_bridge:notify', Strings.notify_giveitem_fail, (Strings.notify_giveitem_fail_desc:format(name)), 'error', 'fa-xmark')
    end
end

local function givePlayerItem(target, name)
    local Dialog = lib.inputDialog(Strings.dialog_giveitem, {
        { type = 'input', label = Strings.giveitem_input_label, placeholder = Strings.giveitem_input_placeholder },
        { type = 'input', label = Strings.giveitem_amount_input_label, placeholder = Strings.giveitem_amount_input_placeholder }})
    if not Dialog then return end
    local success = lib.callback.await('ww-adminMenu:Server:giveitem', 100, target, Dialog[1], tonumber(Dialog[2]))
    if success then
        -- TriggerEvent('wasabi_bridge:notify', Strings.notify_giveitem_success, (Strings.notify_giveitem_success_desc:format(name, Dialog[1], Dialog[2])), 'success', 'fa-check')
    else
        -- TriggerEvent('wasabi_bridge:notify', Strings.notify_giveitem_fail, (Strings.notify_giveitem_fail_desc:format(name)), 'error', 'fa-xmark')
    end
end

local function kickPlayer(target, name)
    local Reason = lib.inputDialog(Strings.dialog_kick:format(name), {
        { type = 'input', label = Strings.dialog_kick_reason, placeholder = Strings.dialog_kick_placeholder },
    })
    if not Reason then return end
    local dropPlayer = lib.callback.await('ww-adminMenu:Server:dropPlayer', 100, target, Reason[1] or Strings.kicked_reason_replace)
    if dropPlayer then
        -- TriggerEvent('wasabi_bridge:notify', Strings.notify_kicked_success, (Strings.notify_kicked_success_desc:format(name)), 'success', 'fa-check')
    end
end

local function banPlayer(target)
    local banOptions = {}

    for _, ban in pairs(Ban) do
        local time = ban.value
        table.insert(banOptions, {
            title = ban.label,
            description = "Ban player for ".. ban.label,
            icon = "fa-solid fa-trash",
            onSelect = function()
                local Reason = lib.inputDialog(Strings.dialog_ban:format(name), {
                    { type = 'input', label = Strings.dialog_ban_reason, placeholder = Strings.dialog_ban_placeholder },
                })
                if not Reason then return end
                local playerBanned = lib.callback.await('ww-adminMenu:Server:banPlayer', 100, target, time, Reason[1] or Strings.ban_reason_replace)
                -- if playerBanned then
                    -- TriggerEvent('wasabi_bridge:notify', Strings.notify_banned_success, (Strings.notify_banned_success_desc:format(name)), 'success', 'fa-check')
                -- end
            end
        })
    end

    lib.registerContext({
        id  = "admin_menu_ban_option",
        title = "Ban Options",
        options = banOptions
    })

    lib.showContext("admin_menu_ban_option")
end

local function openPlayerData(target, perms)
    local targetData = lib.callback.await('ww-adminMenu:Server:playerdata', 100, target)
    local options = {}

    options[#options+1] = {
        title = Strings.playerdata_license_esx:format(string.sub(targetData.identifier, 9, -20)),
        description = Strings.playerdata_license_desc,
        icon = "fa-solid fa-id-card",
        onSelect = function()
            lib.setClipboard(targetData.identifier)
        end
    }


    --- DO NOT USE THESE UNLESS YOU KNOW WHAT YOU ARE DOING, YOU CAN HAVE A BIG SECURITY ISSUE IF YOU DO NOT KNOW WHAT YOU ARE DOING

    -- options[#options+1] = {
    --     title = Strings.playerdata_xbl:format(string.sub(targetData.xbl, 5, -8)),
    --     description = Strings.playerdata_xbl_desc,
    --     icon = "fa-brands fa-xbox",
    --     readOnly = true
    -- }
    -- options[#options+1] = {
    --     title = Strings.playerdata_live:format(string.sub(targetData.live, 6, -8)),
    --     description = Strings.playerdata_live_desc,
    --     icon = "fa-solid fa-life-ring",
    --     readOnly = true
    -- }


    options[#options+1] = {
        title = Strings.playerdata_igname:format(targetData.igname),
        description = Strings.playerdata_igname_desc,
        icon = "fa-solid fa-signature",
        readOnly = true
    }
    options[#options+1] = {
        title = Strings.playerdata_steam:format(targetData.steamname),
        description = Strings.playerdata_steam_desc,
        icon = "fa-brands fa-steam",
        readOnly = true
    }

    --- COMING SOON .....

    -- options[#options+1] = {
    --     title = Strings.playerdata_gender:format(targetData.sex),
    --     description = Strings.playerdata_gender_desc,
    --     icon = "fa-solid fa-users",
    --     readOnly = true
    -- }

    options[#options+1] = {
        title = Strings.playerdata_cash:format(targetData.cash),
        description = Strings.playerdata_cash_desc,
        icon = "fa-solid fa-money-bill",
        readOnly = true
    }
    options[#options+1] = {
        title = Strings.playerdata_bank:format(targetData.bank),
        description = Strings.playerdata_bank_desc,
        icon = "fa-solid fa-credit-card",
        readOnly = true
    }
    options[#options+1] = {
        title = Strings.playerdata_blackmoney:format(targetData.black_money),
        description = Strings.playerdata_blackmoney_desc,
        icon = "fa-solid fa-money-bill",
        readOnly = true
    }

    lib.registerContext({
        id = "admin_menu_playerdata",
        title = Strings.playerdata_menu,
        menu = "admin_menu_playeroptions_handle",
        options = options
    })
    lib.showContext('admin_menu_playerdata')
end
local function plyOptionsMenu(Target, Name, perms)
    local BanConfig = {}
    local GetPlayerServerId = GetPlayerFromServerId(Target)
    local GetPlayerPed = GetPlayerPed(GetPlayerServerId)
    local health = GetEntityHealth((GetPlayerPed)) / 2
    local options = {
        {
            title = Strings.player_health:format(math.floor(health)),
            icon = "fa-heart-pulse",
            readOnly = true,
            progress = health,
            colorScheme = "green"
        },
        {
            title = Strings.player_freeze,
            description = Strings.player_freeze_desc,
            icon = "fa-solid fa-street-view",
            onSelect = function()
                Freezed = not Freezed
                lib.callback.await('ww-adminMenu:Server:freeze', 100, Target, Freezed)
            end
        }
    }
    if perms.noclip or perms.allPerms then
        options[#options+1] = {
            title = Strings.player_noclip,
            description = Strings.player_noclip_desc,
            icon = "fa-person-walking-dashed-line-arrow-right",
            onSelect = function()
                Noclip = not Noclip
                lib.callback.await('ww-adminMenu:Server:noclip', 100, Target, Noclip)
            end
        }
    end
    if perms.spectate or perms.allPerms then
        options[#options+1] = {
            title = "Spectate",
            description = "Spectate the player",
            icon = "fa-solid fa-eye",
            onSelect = function()
                TriggerServerEvent('start', Target)
            end
        }
    end
    options[#options+1] = {
        title = Strings.player_playerdata,
        description = Strings.player_playerdata_desc,
        icon = "fa-solid fa-database",
        onSelect = function()
            openPlayerData(Target, perms)
        end
    }
    if perms.revive or perms.allPerms then
        options[#options+1] = {
            title = Strings.player_revive,
            description = Strings.player_revive_desc,
            icon = "fa-solid fa-first-aid",
            onSelect = function()
                TriggerServerEvent('ww-adminmenu:Server:revive', Target)
            end
        }
    end
    if perms.heal or perms.allPerms then
        options[#options+1] = {
            title = Strings.player_heal,
            description = Strings.player_heal_desc,
            icon = "fa-solid fa-bandage",
            onSelect = function()
                TriggerServerEvent('ww-adminmenu:Server:heal', Target)
            end
        }
    end
    if perms.skin or perms.allPerms then
        options[#options+1] = {
            title = Strings.player_skinmenu,
            description = Strings.player_skinmenu_desc,
            icon = "fa-solid fa-shirt",
            onSelect = function()
                TriggerServerEvent('ww-adminmenu:Server:skinmenu', Target)
            end
        }
    end
    if perms.money or perms.allPerms then
        options[#options+1] = {
            title = Strings.player_money,
            description = Strings.player_money_desc,
            icon = "fa-solid fa-money-bill",
            onSelect = function()
                givePlayerMoney(Target, Name)
            end
        }
    end
    if perms.items or perms.allPerms then
        options[#options+1] = {
            title = Strings.player_item,
            description = Strings.player_item_desc,
            icon = "fa-solid fa-hand-holding-medical",
            onSelect = function()
                givePlayerItem(Target, Name)
            end
        }
    end
    if perms.inventory or perms.allPerms then
        options[#options+1] = {
            title = Strings.player_openinv,
            description = Strings.player_openinv_desc,
            icon = "fa-solid fa-box-open",
            onSelect = function()
                OpenPlayerInventory(Target)
            end
        }
        options[#options+1] = {
            title = Strings.player_clearinv,
            description = Strings.player_clearinv_desc,
            icon = "fa-solid fa-boxes-packing",
            onSelect = function()
                local Clear = lib.callback.await('ww-adminMenu:Server:clearinv', 100, Target)
                if Clear then
                    return
                end
            end
        }
    end
    if perms.teleport or perms.allPerms then
        options[#options+1] = {
            title = Strings.player_teleport_to,
            description = Strings.player_teleport_to_desc,
            icon = "fa-solid fa-person-arrow-up-from-line",
            onSelect = function()
                TriggerServerEvent('ww-adminmenu:Server:playerteleport', Target, 'tpto')
            end
        }
        options[#options+1] = {
            title = Strings.player_bring,
            description = Strings.player_bring_desc,
            icon = "fa-solid fa-person-arrow-down-to-line",
            onSelect = function()
                TriggerServerEvent('ww-adminmenu:Server:playerteleport', Target, 'bring')
            end
        }
    end
    if perms.kick or perms.allPerms then
        options[#options+1] = {
            title = Strings.player_kick,
            description = Strings.player_kick_desc,
            icon = "fa-solid fa-arrow-right-from-bracket",
            onSelect = function()
                kickPlayer(Target, Name)
            end
        }
    end
    if perms.ban or perms.allPerms then
        options[#options+1] = {
            title = Strings.player_ban,
            description = "Ban a Player",
            icon = "fa-solid fa-trash",
            onSelect = function()
                banPlayer(Target)
            end
        }
    end

    lib.registerContext({
        id = "admin_menu_playeroptions_handle",
        title = Strings.player_options:format(Name),
        menu = "admin_menu_playeroptions",
        options = options
    })

    lib.showContext("admin_menu_playeroptions_handle")
end

local searchPlayerId = function(players, perms)
    local input = lib.inputDialog(Strings.dialog_search_player, {Strings.dialog_search_player_row})
    if not input then lib.showContext("admin_menu_playeroptions") return end
    local num = tonumber(input[1])
    if not num then lib.showContext("admin_menu_playeroptions") return end
    local found
    for k,v in pairs(players) do
        if v.value == num then
            plyOptionsMenu(v.value, v.label, perms)
            found = true
            break
        end
    end
    if found then return end
    -- TriggerEvent('wasabi_bridge:notify', Strings.notify_no_player_id, (Strings.notify_no_player_id_desc):format(num), 'error')
end

function PlayerOptions(perms)
    local Players = {
        {
            title = Strings.player_search_id,
            icon = 'fa-magnifying-glass',
            onSelect = function()
                searchPlayerId(Players, perms)
            end
        }
    }

    local data = lib.callback.await('ww-adminMenu:Server:players', 250)
    local SentPlayers, PlayerCount = data.SentPlayers, data.PlayerCount

    for i = 1, #SentPlayers do
        Players[#Players + 1] = {
            title = '['..SentPlayers[i].Id..']' .. ' ' .. SentPlayers[i].Name,
            onSelect = function()
                plyOptionsMenu(SentPlayers[i].Id, SentPlayers[i].Name, perms)
            end
        }
    end

    lib.registerContext({
        id = "admin_menu_playeroptions",
        title = Strings.player_options_menu:format(PlayerCount, ServerSlots),
        menu = "admin_menu_main",
        options = Players
    })
    lib.showContext('admin_menu_playeroptions')
end