lib.callback.register('ww-adminMenu:Server:clearinv', function(source, target)
    local adminPerms = AdminPerms(source)
    if not adminPerms or not adminPerms?.open then return false end
    -- if wsb.framework == 'esx' then
        local xTarget = ESX.GetPlayerFromId(target)
        if not xTarget then return false end
        xTarget.setAccountMoney('money', 0)
        xTarget.setAccountMoney('black_money', 0)
        if Inventory == 'mf' then
            exports['mf-inventory']:clearInventory(xTarget.identifier)
            exports['mf-inventory']:clearLoadout(xTarget.identifier)
        elseif Inventory == 'esx' or Inventory == 'cheeza' then
            for i = 1, #xTarget.inventory, 1 do
                if xTarget.inventory[i].count > 0 then
                    xTarget.removeInventoryItem(xTarget.inventory[i].name, xTarget.inventory[i].count)
                end
            end
        end
    -- elseif wsb.framework == 'qb' then
    --     local player = wsb.getPlayer(target)
    --     if not player then return false end
    --     player.Functions.ClearInventory()
    --     MySQL.Async.execute('UPDATE players SET inventory = ? WHERE citizenid = ?', { json.encode({}), player.PlayerData.citizenid })
    -- end
    if Inventory == 'qs' then
        exports['qs-inventory']:ClearInventory(target, {})
    elseif Inventory == 'ox' then
        exports.ox_inventory:ClearInventory(target)
    end
    return true
end)