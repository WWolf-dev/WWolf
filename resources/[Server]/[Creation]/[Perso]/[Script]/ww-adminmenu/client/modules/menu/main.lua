function AdminMenu(perms)
    local perms = perms
    if not perms then
        perms = lib.callback.await('ww-adminMenu:Server:checkPerms', 100)
    end
    if not perms then return end
    local options = {
        {
            title = Strings.self_options,
            description = Strings.self_options_desc,
            icon = 'fa-person',
            onSelect = function()
                SelfOptions(perms)
            end
        },
        {
            title = Strings.player_options_title,
            description = Strings.player_options_desc,
            icon = 'fa-people-arrows',
            onSelect = function()
                PlayerOptions(perms)
            end
        },
    }
    if perms.vehicles or perms.allPerms then
        options[#options + 1] = {
            title = Strings.vehicle_options,
            description = Strings.vehicle_options_desc,
            icon = 'fa-car',
            onSelect = function()
                VehicleOptions(perms)
            end
        }
    end
    options[#options + 1] = {
        title = Strings.server_options,
        description = Strings.server_options_desc,
        icon = 'fa-globe',
        onSelect = function()
            ServerOptions(perms)
        end
    }
    if perms.zones or perms.allPerms then
        options[#options + 1] = {
            title = Strings.admin_zone_options,
            description = Strings.admin_zone_options_desc,
            icon = 'fa-street-view',
            onSelect = function()
                AdminZoneMenu(perms)
            end
        }
    end
    options[#options + 1] = {
        title = Strings.developer_options,
        description = Strings.developer_options_desc,
        icon = 'fa-screwdriver-wrench',
        onSelect = function()
            TriggerEvent("ww-adminmenu:client:developmentCompatibility")
        end
        -- args = {DeveloperOptions = true}
    }
    lib.registerContext({
        id = "admin_menu_main",
        title = Strings.main_title,
        options = options,
    })
    lib.showContext("admin_menu_main")
end