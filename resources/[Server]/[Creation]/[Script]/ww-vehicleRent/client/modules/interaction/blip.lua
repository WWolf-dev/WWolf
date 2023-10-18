function RentingBlips()
    for _, blips in pairs(RentingZone) do
        local rentBlip = AddBlipForCoord(blips.Position.x, blips.Position.y, blips.Position.z)
        SetBlipSprite(rentBlip, blips.Blip.Sprite)
        SetBlipDisplay(rentBlip, 4)
        SetBlipScale(rentBlip, blips.Blip.Scale)
        SetBlipColour(rentBlip, blips.Blip.Color)
        SetBlipAsShortRange(rentBlip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(blips.Blip.Name)
        EndTextCommandSetBlipName(rentBlip)
    end
end