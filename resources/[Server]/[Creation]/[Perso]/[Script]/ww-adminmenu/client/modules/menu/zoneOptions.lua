local zones, points, blips, currentZone, safetyLoop, loopActive, breakLoop = {}, {}, nil, nil, nil, nil, nil

local function createBlip(coords, sprite, color, text, scale, flash)
    local x,y,z = table.unpack(coords)
    local blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, scale)
    SetBlipColour(blip, color)
    if flash then
		SetBlipFlashes(blip, true)
	end
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
    return blip
end

local function createRadiusBlip(coords, radius, color)
    local blip = AddBlipForRadius(coords, radius)
    SetBlipColour(blip, color or 1)
    SetBlipAlpha(blip, 80)
    return blip
end

local function enterZoneLoop()
    if not currentZone then return end
    if loopActive then
        breakLoop = true
        while loopActive do Wait(500) end
    end
    CreateThread(function()
        loopActive = true
        local cacheZone = currentZone
        local invincible
        local speedSet
        -- local textUI
        while true do
            local sleep = 1500
            if breakLoop or not currentZone or currentZone ~= cacheZone then
                breakLoop = nil
                loopActive = nil
                if invincible then
                    SetEntityInvincible(cache.ped, false)
                    invincible = nil
                end
                if speedSet and cache.vehicle then
                    SetVehicleMaxSpeed(cache.vehicle, 1000.00)
                    speedSet = nil
                end
                -- if textUI then
                    -- wsb.hideTextUI()
                    -- textUI = nil
                -- end
                break
            end
            -- if currentZone.text and not textUI then
                -- wsb.showTextUI(currentZone.text)
                -- textUI = true
            -- end
            if currentZone.disarm and (IsPedArmed(cache.ped, 1) or IsPedArmed(cache.ped, 2) or IsPedArmed(cache.ped, 4)) then
                -- TriggerEvent('wasabi_bridge:notify', Strings.notify_zone_no_weapons, Strings.notify_zone_no_weapons_desc, 'error', 'fa-gun')
                SetCurrentPedWeapon(cache.ped, `WEAPON_UNARMED`)
            end
            -- if currentZone.revive and IsPlayerDead() then
            --     TriggerEvent('wasabi_adminmenu:revive')
            -- end
            -- if currentZone.invincible and not invincible then
            --     SetEntityInvincible(cache.ped, true)
            --     invincible = true
            -- end
            if currentZone.speed and (cache.vehicle and cache.seat == -1) then
                local units = { mph = 2.236936, kmh = 3.6 }
                SetVehicleMaxSpeed(cache.vehicle, (currentZone.speed / units[SpeedMeasurement]))
                speedSet = true
            end
            Wait(sleep)
        end
    end)
end

local function refreshBlips()
    if blips and #blips > 0 then
        for i=1, #blips do
            RemoveBlip(blips[i])
        end
    end
    blips = {}
    if zones and #zones > 0 then
        for i=1, #zones do
            blips[#blips + 1] = createBlip(zones[i].coords, zones[i].blip.sprite, zones[i].blip.color, zones[i].name, 1.0, zones[i].blip.flashing)
            blips[#blips + 1] = createRadiusBlip(zones[i].coords, zones[i].size, zones[i].blip.color)
        end
    end
end

local function refreshPoints()
    if points and #points > 0 then
        for i=1, #points do
            local point = points[i]
            point:remove()
        end
    end
    if loopActive then
        breakLoop = true
        while loopActive do Wait(500) end
        safetyLoop = nil
    end
    points = {}
    if zones and #zones > 0 then
        for k,v in pairs(zones) do
            local i = #points + 1
            points[i] = lib.points.new({
                coords = v.coords,
                distance = v.size
            })
            local point = points[i]
            function point:nearby()
                if self.currentDistance > v.size then return end
                currentZone = zones[k]
                if not safetyLoop then
                    enterZoneLoop()
                    safetyLoop = true
                end
            end
            function point:onExit()
                if currentZone then currentZone = nil end
                if safetyLoop then safetyLoop = nil end
            end
        end
    end
end

local function deleteAdminZone(zone)
    local zone = zone or currentZone
    if not zone then return end
    local confirmed = lib.alertDialog({
        header = Strings.dialog_zone_delete_confirm,
        content = (Strings.dialog_zone_delete_confirm_desc):format(zone.name),
        centered = true,
        cancel = true
    })
    if confirmed == 'confirm' then
        local deleted = lib.callback.await('ww-adminmenu:server:deleteZone', 100, zone)
        if deleted then
            -- TriggerEvent('wasabi_bridge:notify', Strings.notify_zone_deleted, (Strings.notify_zone_deleted_desc:format(zone.name)), 'success', 'fa-check')
        else
            -- TriggerEvent('wasabi_bridge:notify', Strings.notify_error, (Strings.notify_zone_not_deleted_desc:format(zone.name)), 'error')
        end
    else
        -- TriggerEvent('wasabi_bridge:notify', Strings.notify_zone_action_cancelled, (Strings.notify_zone_delete_cancel:format(zone.name)), 'error')
    end
end

local function editAdminZone(_perms, zone)
    local zone = zone or currentZone
    if not zone then return end
    local options = {
        { type = 'input', label = Strings.dialog_zone_name, description = Strings.dialog_zone_name_desc, placeholder = Strings.dialog_zone_name_holder, default = zone.name, required = true },
        -- { type = 'input', label = Strings.dialog_zone_text, description = Strings.dialog_zone_text_desc, placeholder = Strings.dialog_zone_text_holder, default = (zone.text or false), required = false },
        { type = 'slider', label = Strings.dialog_zone_size,  default = (math.floor(zone.size / 5)), min = 1, max = 10, step = 1, required = true },
        { type = 'checkbox', label = Strings.dialog_zone_disarm, checked = zone.disarm },
        -- { type = 'checkbox', label = Strings.dialog_zone_revive, checked = zone.revive },
        -- { type = 'checkbox', label = Strings.dialog_zone_invincible, checked = zone.invincible },
        { type = 'slider', label = Strings.dialog_zone_speed..' ('..Strings[SpeedMeasurement]..')',  default = zone.speed, min = 1, max = 100, step = 15, required = true },
        { type = 'number', label = Strings.dialog_zone_blip_id, placeholder = Strings.dialog_zone_placeholder, default = zone.blip.sprite, min = 0, max = 826, required = true },
        { type = 'number', label = Strings.dialog_zone_blip_color, placeholder = Strings.dialog_zone_color_placeholder, default = zone.blip.color, min = 0, max = 85, required = true },
        { type = 'checkbox', label = Strings.dialog_zone_blip_flashing, checked = zone.blip.flashing },
    }
    local dialog = lib.inputDialog(((Strings.dialog_zone_edit):format(zone.name)), options)
    if not dialog then return end
    local newZone = {
        name = dialog[1] or Strings.dialog_zone_name_holder,
        -- text = dialog[2] or false,
        size = (dialog[2] or 5) * 5.0,
        coords = zone.coords,
        disarm = dialog[3] or false,
        -- revive = dialog[5] or false,
        -- invincible = dialog[6] or false,
        speed = dialog[4] or 15,
        blip = {
            sprite = dialog[5] or 487,
            color = dialog[6] or 1,
            flashing = dialog[7] or false
        }
    }
    local edited = lib.callback.await('ww-adminmenu:server:editZone', 100, zone, newZone)
    if edited then
        -- TriggerEvent('wasabi_bridge:notify', Strings.notify_zone_edited, (Strings.notify_zone_edited_desc:format(zone.name)), 'success', 'fa-check')
    else
        -- TriggerEvent('wasabi_bridge:notify', Strings.notify_error, (Strings.notify_zone_not_edited_desc:format(zone.name)), 'error')
    end
end

local function createAdminZone()
    local options = {
        { type = 'input', label = Strings.dialog_zone_name, description = Strings.dialog_zone_name_desc, placeholder = Strings.dialog_zone_name_holder, default = Strings.dialog_zone_name_holder, required = true },
        -- { type = 'input', label = Strings.dialog_zone_text, description = Strings.dialog_zone_text_desc, placeholder = Strings.dialog_zone_text_holder, default = Strings.dialog_zone_text_holder, required = false },
        { type = 'slider', label = Strings.dialog_zone_size,  default = 1, min = 1, max = 10, step = 1, required = true },
        { type = 'checkbox', label = Strings.dialog_zone_disarm, checked = false },
        -- { type = 'checkbox', label = Strings.dialog_zone_revive, checked = false },
        -- { type = 'checkbox', label = Strings.dialog_zone_invincible, checked = false },
        { type = 'slider', label = Strings.dialog_zone_speed..' ('..Strings[SpeedMeasurement]..')',  default = 15, min = 1, max = 100, step = 15, required = true },
        { type = 'number', label = Strings.dialog_zone_blip_id, placeholder = Strings.dialog_zone_placeholder, default = 487, min = 0, max = 826, required = true },
        { type = 'number', label = Strings.dialog_zone_blip_color, placeholder = Strings.dialog_zone_color_placeholder, default = 1, min = 0, max = 85, required = true },
        { type = 'checkbox', label = Strings.dialog_zone_blip_flashing, checked = false },
    }
    local dialog = lib.inputDialog(Strings.dialog_zone_create, options)
    if not dialog then return end
    local coords = GetEntityCoords(cache.ped)
    local zone = {
        name = dialog[1] or Strings.dialog_zone_name_holder,
        -- text = dialog[2] or false,
        size = (dialog[2] or 5) * 5.0,
        coords = coords,
        disarm = dialog[3] or false,
        -- revive = dialog[5] or false,
        -- invincible = dialog[6] or false,
        speed = dialog[4] or 15,
        blip = {
            sprite = dialog[5] or 487,
            color = dialog[6] or 1,
            flashing = dialog[7] or false
        }
    }
    TriggerServerEvent('ww-adminmenu:server:createZone', zone)
end

local function teleportToZone(t)
    local coords = t.coords
    DoScreenFadeOut(800)
	while not IsScreenFadedOut() do Wait() end
	RequestCollisionAtCoord(coords.x, coords.y, coords.z)
	while not HasCollisionLoadedAroundEntity(cache.ped) do Wait() end
	SetEntityCoords(cache.ped, coords.x, coords.y, coords.z, false, false, false, false)
	DoScreenFadeIn(800)
    -- TriggerEvent('wasabi_bridge:notify', Strings.notify_zones_teleport, ((Strings.notify_zones_teleport_desc):format(t.name)), 'success')
end

local function adminZoneOptions(t)
    local Options = {
        {
            title = Strings.zone_edit,
            description = ((Strings.zone_edit_desc):format(t.name)),
            icon = 'fa-pen-to-square',
            onSelect = function()
                editAdminZone(t)
            end
        },
        {
            title = Strings.zone_delete,
            description = ((Strings.zone_delete_desc):format(t.name)),
            icon = 'fa-trash',
            onSelect = function()
                deleteAdminZone(t)
            end
        },
        {
            title = Strings.zone_teleport,
            description = ((Strings.zone_teleport_desc):format(t.name)),
            icon = 'fa-person-arrow-up-from-line',
            onSelect = function()
                teleportToZone(t)
            end
        }
    }

    lib.registerContext({
        id = 'admin_zone_manage_menu',
        title = (Strings.zone_manage_menu):format(t.name),
        menu = "admin_manage_zones",
        options = Options,
    })

    lib.showContext('admin_zone_manage_menu')
end

local function manageAdminZones(perms)
    if not zones or #zones < 1 then
        -- return TriggerEvent('wasabi_bridge:notify', Strings.notify_zones_not_found, Strings.notify_zones_not_found_desc, 'error')
        return print('No zones found')
    else
        local Options = {}
        for i=1, #zones do
            Options[#Options + 1] = {
                title = zones[i].name,
                icon = 'fa-pen-to-square',
                onSelect = function()
                    adminZoneOptions(zones[i], perms)
                end
            }
        end
        lib.registerContext({
            id = 'admin_manage_zones',
            title = Strings.self_options_menu,
            menu = "admin_zone_menu",
            options = Options,
        })

        lib.showContext('admin_manage_zones')
    end
end

function AdminZoneMenu(perms)
    local zoneOptions = {
        {
            title = Strings.zones_create,
            description = Strings.zones_create_desc,
            icon = "fa-plus",
            onSelect = function()
                createAdminZone(perms)
            end
        },
        {
            title = Strings.zones_manage,
            description = Strings.zones_manage_desc,
            icon = "fa-file-pen",
            onSelect = function()
                manageAdminZones(perms)
            end
        }
    }
    if currentZone then
        zoneOptions[#zoneOptions+1] = {
            title = Strings.zone_edit_current,
            description = Strings.zone_edit_current_desc,
            icon = "fa-street-view",
            onSelect = function()
                editAdminZone(perms)
            end
        }
        zoneOptions[#zoneOptions+1] = {
            title = Strings.zone_delete_current,
            description = Strings.zone_delete_current_desc,
            icon = "fa-trash-can",
            onSelect = function()
                deleteAdminZone()
            end
        }
    end

    lib.registerContext({
        id = 'admin_zone_menu',
        title = Strings.admin_zone_options,
        menu = "admin_menu_main",
        options = zoneOptions,
    })

    lib.showContext('admin_zone_menu')
end
-- Event when a player is loaded
RegisterNetEvent(playerLoadedEvent)
AddEventHandler(playerLoadedEvent, function(xPlayer)
    ESX.PlayerData = xPlayer  -- Store player data locally
    PlayerLoaded = true

    zones = lib.callback.await('ww-adminmenu:server:refreshZones', 100)
    refreshBlips()
    refreshPoints()
end)

RegisterNetEvent('ww-adminmenu:client:refreshZones', function(newZones)
    zones = newZones
    refreshBlips()
    refreshPoints()
end)


AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        if safetyLoop and currentZone then
            -- if currentZone.invincible then
            --     SetEntityInvincible(cache.ped, false)
            --     invincible = nil
            -- end
            if currentZone.speed and cache.vehicle then
                SetVehicleMaxSpeed(cache.vehicle, 1000.00)
                speedSet = nil
            end
            -- if currentZone.text then
                -- wsb.hideTextUI()
            -- end
        end
    end
end)