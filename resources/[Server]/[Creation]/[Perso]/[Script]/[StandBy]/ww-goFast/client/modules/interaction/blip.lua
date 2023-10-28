function GoFastBlip()
    for _, blips in pairs(goFastZones) do
        local blip = AddBlipForCoord(blips.Position.x, blips.Position.y, blips.Position.z)
        SetBlipSprite(blip, blips.Blip.Sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, blips.Blip.Scale)
        SetBlipColour(blip, blips.Blip.Color)
        SetBlipAlpha(blip, blips.Blip.Opacity)
        SetBlipFlashes(blip, blips.Blip.isFlashing)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(blips.Blip.Name)
        EndTextCommandSetBlipName(blip)
    end
end