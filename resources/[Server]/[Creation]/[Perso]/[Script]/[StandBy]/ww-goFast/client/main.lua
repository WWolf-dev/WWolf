-- Check the ESX Version and initialize the framework
if versionESX == "older" then
    ESX = nil
    CreateThread(function()
        -- Wait for ESX to be initialized
        while ESX == nil do
            TriggerEvent(getSharedObjectEvent, function(obj) ESX = obj end)
            Wait(0)
        end
    end)
elseif versionESX == "newer" then
    FrameworkExport()  -- Export new ESX functionalities
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    local OpenMenu = lib.getOpenContextMenu()
    lib.hideContext(OpenMenu)
end)

CreateThread(function()
    GoFastBlip()
    GoFastNPC()
    AccessGofastNPCs()
end)