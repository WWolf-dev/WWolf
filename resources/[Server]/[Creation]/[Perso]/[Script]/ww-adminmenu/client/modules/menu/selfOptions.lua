local Invisible, GodMode

local function InvisibleMode()
    Invisible = not Invisible
    SetEntityVisible(cache.ped, not Invisible)
    if Invisible then
        print("Invisible")
    else
        print("Visible")
    end
end

local function GodModeMode()
    GodMode = not GodMode
    SetEntityInvincible(cache.ped, not GodMode)
    if GodMode then
        print("GodMode")
        -- print(GetPlayerInvincible(cache.ped))
    else
        print("NoGodMode")
        -- print(GetPlayerInvincible(cache.ped))
    end
end

local function SetPed()
    local pedOptions = {}
    for _, npc in pairs(Peds) do
        table.insert(pedOptions, {
            title = npc.label,
            description = "Spawn ".. npc.label,
            icon = "fa-person-walking-dashed-line-arrow-right",
            onSelect = function()
                if npc.model == "restore" then
                    TriggerEvent('skinchanger:loadDefaultModel') -- Charger le modèle par défaut
                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                        TriggerEvent('skinchanger:loadSkin', skin)
                    end)
                else
                    lib.requestModel(npc.model)
                    SetPlayerModel(PlayerId(), npc.model)
                    SetModelAsNoLongerNeeded(npc.model)
                end
            end
        })
    end

    lib.registerContext({
        id  = "admin_menu_self_option_pedMenu",
        title = Strings.self_set_ped,
        menu = "admin_menu_main",
        options = pedOptions
    })

    lib.showContext("admin_menu_self_option_pedMenu")
end

function SelfOptions(perms)
    local health = GetEntityHealth(cache.ped) / 2
    local options = {
        {
            title = (Strings.self_health):format(math.floor(health)),
            icon = 'fa-heart-pulse',
            readOnly = true,
            progress = health,
            colorScheme = "green"
        }
    }
    if perms.noclip or perms.allPerms then
        options[#options + 1] = {
            title = Strings.self_noclip,
            description = Strings.self_noclip_desc,
            icon = 'fa-person-walking-dashed-line-arrow-right',
            onSelect = function()
                ToggleNoClip()
            end
        }
    end
    if perms.invisible or perms.allPerms then
        options[#options + 1] = {
            title = Strings.self_invisible,
            description = Strings.self_invisible_desc,
            icon = 'fa-eye-slash',
            onSelect = function()
                InvisibleMode()
            end
        }
    end
    if perms.godmode or perms.allPerms then
        options[#options + 1] = {
            title = Strings.self_godmode,
            description = Strings.self_godmode_desc,
            icon = 'fa-person-rays',
            onSelect = function()
                GodModeMode()
            end
        }
    end
    if perms.revive or perms.allPerms then
        options[#options + 1] = {
            title = Strings.self_revive,
            description = Strings.self_revive_desc,
            icon = 'fa-bed-pulse',
            onSelect = function()
                TriggerEvent("ww-adminmenu:client:reviveCompatibility")
            end
        }
    end
    if perms.heal or perms.allPerms then
        options[#options + 1] = {
            title = Strings.self_heal,
            description = Strings.self_heal_desc,
            icon = 'fa-bandage',
            onSelect = function()
                TriggerEvent("ww-adminmenu:client:healCompatibility")
            end
        }
    end
    if perms.skin or perms.allPerms then
        options[#options + 1] = {
            title = Strings.self_skinmenu,
            description = Strings.self_skinmenu_desc,
            icon = 'fa-shirt',
            onSelect = function()
                TriggerEvent("ww-adminmenu:client:skinmenulCompatibility")
            end
        }
    end
    if perms.setped or perms.allPerms then
        options[#options + 1] = {
            title = Strings.self_set_ped,
            description = Strings.self_setped_desc,
            icon = 'fa-user',
            onSelect = function()
                SetPed()
            end
        }
    end
    lib.registerContext({
        id = 'admin_menu_selfoptions',
        title = Strings.self_options_menu,
        menu = "admin_menu_main",
        options = options
    })
    lib.showContext('admin_menu_selfoptions')
end