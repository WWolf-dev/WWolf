if FrameworkUse == "ESX" then 

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

Perms = {}

RegisterNetEvent('ww-adminmenu:Client:searchInventory', function(target)
    if GetInvokingResource() ~= GetCurrentResourceName() then return end
    OpenPlayerInventory(target)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    local OpenMenu = lib.getOpenContextMenu()
    lib.hideContext(OpenMenu)
end)

local function openAdminMenu()
    local perms = lib.callback.await('ww-adminMenu:Server:checkPerms', 100)
    if not perms or not perms?.open then return end
    AdminMenu(perms)
end


RegisterCommand('++adminmenu', openAdminMenu)

TriggerEvent('chat:removeSuggestion', '/++adminmenu')
RegisterKeyMapping('++adminmenu', Strings.keymapping_desc, 'keyboard', openKey)








-- If using QBCore, this script is currently not supported
elseif FrameworkUse == "QBCore" then
    return nil
end