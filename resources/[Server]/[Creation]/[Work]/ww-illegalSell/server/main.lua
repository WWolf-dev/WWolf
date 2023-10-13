if FrameworkUse == "ESX" then
    if versionESX == "older" then
        ESX = nil
        TriggerEvent(getSharedObjectEvent, function(obj) ESX = obj end)
    elseif versionESX == "newer" then
        FrameworkExport()
    end

    TriggerEvent('esx_society:registerSociety', "ammunation", "Armurier", "society_ammunation", "society_ammunation", "society_ammunation", {type = 'private'})





    -- Soon QBCore support
elseif FrameworkUse == "QBCore" then
    return nil
end