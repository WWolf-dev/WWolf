local luxePrice = 1000
local sportPrice = 500
lib.callback.register("ww-rental:Server:CheckMoneyLuxe", function(source)
    local hasEnoughMoney = false
    local xPlayer = ESX.GetPlayerFromId(source)
    local money = xPlayer.getMoney()
    if money >= luxePrice then
        xPlayer.removeMoney(luxePrice)
        hasEnoughMoney = true
        return hasEnoughMoney
    else
        lib.print.info("You don't have enough money to rent a Luxe Vehicle")
    end
end)

lib.callback.register("ww-rental:Server:CheckMoneySports", function(source)
    local hasEnoughMoney = false
    local xPlayer = ESX.GetPlayerFromId(source)
    local money = xPlayer.getMoney()
    if money >= sportPrice then
        xPlayer.removeMoney(sportPrice)
        hasEnoughMoney = true
        return hasEnoughMoney
    else
        lib.print.info("You don't have enough money to rent a Sport Vehicle")
    end
end)