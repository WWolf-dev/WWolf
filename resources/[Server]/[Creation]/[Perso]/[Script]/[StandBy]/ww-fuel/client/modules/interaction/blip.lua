function FuelStationBlip()
    for _, pos in pairs(FuelStationPositions) do
        local blip = AddBlipForCoord(pos.x, pos.y, pos.z)
        SetBlipSprite(blip, 361)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.9)
        SetBlipColour(blip, 4)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Gas Station")
        EndTextCommandSetBlipName(blip)
    end
end