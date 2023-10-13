local function HasPermission(source, group)
    local player = ESX.GetPlayerFromId(source)
    if not player then return end
    if player.getGroup() ~= group then return false else return true end
end

function AdminPerms(source)
    local authorized
    if adminPerms.UserGroups.enabled then
        for k,v in pairs(adminPerms.UserGroups.groups) do
            if not authorized then authorized = {} end
            if HasPermission(source, k) then
                authorized = v
                authorized.open = true
                break
            end
        end
    end
    if adminPerms.AcePerms.enabled and not authorized?.allPerms then
        if IsPlayerAceAllowed(source, adminPerms.AcePerms.allPerms) then
            if not authorized then authorized = {} end
            authorized.allPerms = true
            authorized.open = true
        elseif not authorized then
            authorized = {}
            if IsPlayerAceAllowed(source, adminPerms.AcePerms.allPerms) then
                authorized.allPerms = true
                authorized.open = true
            else
                for k,v in pairs(adminPerms.AcePerms) do
                    if k ~= 'enabled' then
                        if IsPlayerAceAllowed(source, v) then
                            authorized[k] = true
                            if not authorized.open then authorized.open = true end
                        end
                    end
                end
            end
        elseif not authorized?.allPerms then
            for k,v in pairs(adminPerms.AcePerms) do
                if k ~= 'enabled' and not authorized?[k] then
                    if IsPlayerAceAllowed(source, v) then
                        authorized[k] = true
                        if not authorized.open then authorized.open = true end
                    end
                end
            end
        end
    end
    while not authorized do Wait(0) end
    return authorized
end