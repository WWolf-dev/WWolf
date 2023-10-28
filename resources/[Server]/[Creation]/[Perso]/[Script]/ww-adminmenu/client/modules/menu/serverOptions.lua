local function Announcement()
    local message = lib.inputDialog(Strings.dialog_announce, {
        { type = 'input', label = Strings.dialog_announce_label, placeholder = Strings.dialog_announce_placeholder },
    })
    if not message then return end
    TriggerServerEvent('ww-adminmenu:Server:announcement', message[1])
end

local function splitTime(seconds)
    local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

    if seconds <= 0 then
        return 0, 0
    else
        local hours = string.format('%02.f', math.floor(seconds / 3600))
        local mins = string.format('%02.f', math.floor(seconds / 60 - (hours * 60)))
        local secs = string.format('%02.f', math.floor(seconds - hours * 3600 - mins * 60))

        return hours, mins
    end
end

local function banListHandle(name, license, author, reason, length, perms)
    local hours, mins = splitTime(length)
    lib.registerContext({
        id = "admin_menu_banlist_handle",
        title = Strings.ban_list_menu,
        menu = "admin_menu_banlist",
        options = {
            {
                title = Strings.ban_list_name:format(name),
                readOnly = true
            },
            {
                title = Strings.ban_list_license..' '..string.sub(license, 0, -20)..'...',
                readOnly = true
            },
            {
                title = Strings.ban_list_by:format(author),
                readOnly = true
            },
            {
                title = Strings.ban_list_reason:format(reason),
                readOnly = true
            },
            {
                title = Strings.ban_list_length:format(hours, mins),
                readOnly = true
            },
            {
                title = Strings.ban_list_unban,
                onSelect = function()
                    local confirm = lib.alertDialog({
                        header = Strings.dialog_unban,
                        content = (Strings.dialog_unban_content):format(name),
                        centered = true,
                        cancel = true
                    })
                    if confirm == 'confirm' then
                        local unban = lib.callback.await('ww-adminmenu:Server:unban', 100, license)
                        if unban then
                            -- print("Player has been unbanned")
                        end
                    end
                end
            }
        }
    })
    lib.showContext("admin_menu_banlist_handle")
end
function BanList(perms)
    local data = lib.callback.await('ww-adminmenu:Server:getBanList', 100)
    if not data or #data < 1 then
        return
    else
        local banList = {}
        for i = 1, #data do
            banList[#banList + 1] = {
                title = data[i].name,
                description = string.format("- License : %s\n- Author : %s\n- Reason : %s\n- Time Left : %s",
                    data[i].license,
                    data[i].author,
                    data[i].reason,
                    data[i].time_left
                ),
                icon = 'ban',
                onSelect = function()
                    banListHandle(data[i].name, data[i].license, data[i].author, data[i].reason, data[i].time_left)
                end
            }
        end

        lib.registerContext({
            id = "admin_menu_banlist",
            title = Strings.ban_list_menu,
            options = banList
        })

        lib.showContext("admin_menu_banlist")
    end
end

local function delObjects()
    local objectsPool = GetGamePool('CObject')
    for i=1, #objectsPool do
        if DoesEntityExist(objectsPool[i]) then
            DeleteEntity(objectsPool[i])
        end
    end
    -- TriggerEvent('wasabi_bridge:notify', Strings.notify_deleted_objects, Strings.notify_deleted_objects_desc, 'success','fa-check')
end

local function delCars()
    local vehiclePool = GetGamePool('CVehicle')
    for i = 1, #vehiclePool do
        if GetPedInVehicleSeat(vehiclePool[i], -1) == 0 then
            DeleteEntity(vehiclePool[i])
        end
    end
    -- TriggerEvent('wasabi_bridge:notify', Strings.notify_deleted_car, Strings.notify_deleted_car_desc, 'success','fa-check')
end

local function delPeds()
    local pedsPool = GetGamePool('CPed')
    for i = 1, #pedsPool do
        if DoesEntityExist(pedsPool[i]) then
            DeleteEntity(pedsPool[i])
        end
    end
    -- TriggerEvent('wasabi_bridge:notify', Strings.notify_deleted_ped, Strings.notify_deleted_ped_desc, 'success','fa-check')
end

local function entityDelHandler()
    local Handler =  lib.inputDialog(Strings.dialog_objects, {
        { type = 'select', label = Strings.objects_list_label, options = {
            { value = 'objects', label = Strings.dialog_clear_objects },
            { value = 'cars', label = Strings.dialog_clear_cars },
            { value = 'peds', label = Strings.dialog_clear_peds},
        }},
    })
    if not Handler then return end
    if Handler[1] == 'objects' then
        delObjects()
    elseif Handler[1] == 'cars' then
        delCars()
    elseif Handler[1] == 'peds' then
        delPeds()
    end
end

function ServerOptions(perms)
    local serverOptions = {
        {
            title = Strings.server_announcement,
            description = Strings.server_announcement_desc,
            icon = 'bullhorn',
            onSelect = function()
                Announcement()
            end
        }
    }
    if perms.ban or perms.allPerms then
        serverOptions[#serverOptions+1] = {
            title = Strings.ban_list,
            description = Strings.ban_list_desc,
            icon = 'ban',
            onSelect = function()
                BanList(perms)
            end
        }
    end
    serverOptions[#serverOptions+1] = {
        title = Strings.objects_list,
        description = Strings.objects_list_desc,
        icon = 'trash',
        onSelect = function()
            entityDelHandler()
        end
    }
    serverOptions[#serverOptions+1] = {
        title = Strings.weather_menu,
        description = Strings.weather_menu_desc,
        icon = 'cloud',
        onSelect = function()
            TriggerEvent("ww-adminmenu:client:weatherCompatibility")
        end
    }

    lib.registerContext({
        id = "admin_menu_serveroptions",
        title = Strings.server_management,
        menu = "admin_menu_main",
        options = serverOptions,
    })

    lib.showContext("admin_menu_serveroptions")
end