if versionESX == "older" then
    ESX = nil
    TriggerEvent(getSharedObjectEvent, function(obj) ESX = obj end)
elseif versionESX == "newer" then
    FrameworkExport()
end