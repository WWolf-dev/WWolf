if FrameworkName == "ESX" then

    if VersionESX == "old" then
        ESX = nil
        TriggerEvent(getSharedObjectEvent, function(obj) ESX = obj end)
    elseif VersionESX == "new" then
        CustomFrameworkExport()
    end

















elseif FrameworkName == "QbCore" then
    return nil
end