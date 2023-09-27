if FrameworkUse == "ESX" then
    if versionESX == "older" then
        ESX = nil
        TriggerEvent(getSharedObjectEvent, function(obj) ESX = obj end)
    elseif versionESX == "newer" then
        FrameworkExport()
    end

    ESX.RegisterUsableItem("usb_key", function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        local xItem = xPlayer.getInventoryItem("usb_key")
        print(json.encode(xItem))
        if xItem.count >= 1 then
            print("USB Key used by: " .. GetPlayerName(source))
            xPlayer.removeInventoryItem("usb_key", 1)
            TriggerClientEvent("ww-blackMarket:Client:openMenu", source)
        end
    end)




    -- Soon QBCore support
elseif FrameworkUse == "QBCore" then
    return nil
end
