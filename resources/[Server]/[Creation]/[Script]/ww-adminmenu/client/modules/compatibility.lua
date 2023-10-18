RegisterNetEvent("ww-adminmenu:client:reviveCompatibility", function()
    if GetResourceState("esx_ambulancejob") ~= 'missing' then
        return TriggerEvent('esx_ambulancejob:revive')
    else
        return TriggerEvent('esx_ambulancejob:revive')
    end
end)

RegisterNetEvent("ww-adminmenu:client:healCompatibility", function()
    if GetResourceState("esx_basicneeds") ~= 'missing' then
        return TriggerEvent('esx_basicneeds:healPlayer')
    else
        return SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
    end
end)

RegisterNetEvent("ww-adminmenu:client:weatherCompatibility", function()
    if GetResourceState("cd_easytime") ~= 'missing' then
        return ExecuteCommand('easytime')
    else
        return print("[wasabi_adminmenu] - WARNING: cd_easytime not found. Please install it")
    end
end)

RegisterNetEvent("ww-adminmenu:client:developmentCompatibility", function()
    if GetResourceState("dolu_tool") ~= 'missing' then
        return ExecuteCommand('dolu_tool:open')
    else
        return print("[wasabi_adminmenu] - WARNING: dolu_tool not found. Please install it")
    end
end)

RegisterNetEvent("ww-adminmenu:client:skinmenulCompatibility", function()
    if SkinMenu == 'esx_skin' then
        TriggerEvent('esx_skin:openSaveableMenu')
    elseif SkinMenu == 'fivem-appearance' then
        exports['fivem-appearance']:startPlayerCustomization()
    elseif SkinMenu == 'custom' then
        print('[wasabi_adminmenu] - WARNING: SkinMenu was defined as \'custom\' however it was never set up in modifyme.lua')
        -- Add your own event/export here.
    elseif SkinMenu == '' or SkinMenu == 'change_me' then
        print('[wasabi_adminmenu] - WARNING: SkinMenu not configured')
    end
end)

function GiveVehicleKeys(plate, model, vehicle)
    if UsingVehicleKeys == "jaksam" then
        TriggerServerEvent('vehicles_keys:selfGiveVehicleKeys', plate)
    elseif UsingVehicleKeys == "custom" then
        -- Add your own here
    end
end

function OpenPlayerInventory(target)
    if Inventory == "ox" then
        exports.ox_inventory:openInventory(target)
        -- ExecuteCommand('viewinv '..tostring(target))
    elseif Inventory == 'mf' then
        ESX.TriggerServerCallback('esx:getOtherPlayerData', function(data)
            if type(data) ~= 'table' or not data.identifier then
                return
            end
            exports['mf-inventory']:openOtherInventory(data.identifier)
        end, target)
    elseif Inventory == 'qs' then
        TriggerServerEvent('inventory:server:OpenInventory', 'otherplayer', target)
    elseif Inventory == 'cheeza' then
        TriggerEvent('inventory:openPlayerInventory', target, true)
    elseif Inventory == 'custom' then
        -- Add custom inventory logic here
    else
        print('No Inventory Found.. Check your config.lua')
    end
end

function GetFuelLevel(Vehicle)
    if FuelSystem == "legacyfuel" then
        return exports['LegacyFuel']:GetFuel(Vehicle)
    else
        return GetVehicleFuelLevel(Vehicle)
    end
end