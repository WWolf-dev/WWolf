local IsNoClipping,PlayerPed,NoClipEntity,Camera,NoClipAlpha,PlayerIsInVehicle    = false, nil, nil, nil, nil, false

local function createEffect()
    lib.requestNamedPtfxAsset(Noclip.Particle.Fxname, 100)
    local plyCoords = GetEntityCoords(NoClipEntity)

    UseParticleFxAsset(Noclip.Particle.Fxname) -- Prepare the Particle FX for the next upcomming Particle FX call
    SetParticleFxNonLoopedColour(1.0, 0.0, 0.0) -- Setting the color to Red (R, G, B)
    StartNetworkedParticleFxNonLoopedAtCoord(Noclip.Particle.Effectname, plyCoords.x, plyCoords.y, plyCoords.z, 0.0, 0.0, 0.0, 3.0, false, false, false) -- Start the animation itself

    RemoveNamedPtfxAsset(Noclip.Particle.Fxname) -- Clean up
end


local function disabledControls()
    HudWeaponWheelIgnoreSelection()
    DisableAllControlActions(0)
    DisableAllControlActions(1)
    DisableAllControlActions(2)
    EnableControlAction(0, 220, true)
    EnableControlAction(0, 221, true)
    EnableControlAction(0, 245, true)
    EnableControlAction(0, 200, true)
end

local function isControlAlwaysPressed(inputGroup, control)
    return IsControlPressed(inputGroup, control) or IsDisabledControlPressed(inputGroup, control)
end

local function isPedDrivingVehicle(ped, veh)
    return ped == GetPedInVehicleSeat(veh, -1)
end

local function setupCam()
    local entityRot = GetEntityRotation(NoClipEntity)
    Camera = CreateCameraWithParams('DEFAULT_SCRIPTED_CAMERA', GetEntityCoords(NoClipEntity), vector3(0.0, 0.0, entityRot.z), 75.0)
    SetCamActive(Camera, true)
    RenderScriptCams(true, true, 1000, false, false)

    if PlayerIsInVehicle == 1 then
        AttachCamToEntity(Camera, NoClipEntity, 0.0, Noclip.FirstPersonWhileNoclip == true and 0.5 or -4.5, Noclip.FirstPersonWhileNoclip == true and 1.0 or 2.0, true)
    else
        AttachCamToEntity(Camera, NoClipEntity, 0.0, Noclip.FirstPersonWhileNoclip == true and 0.0 or -2.0, Noclip.FirstPersonWhileNoclip == true and 1.0 or 0.5, true)
    end

end

local function destroyCamera()
    SetGameplayCamRelativeHeading(0)
    RenderScriptCams(false, true, 1000, true, true)
    DetachEntity(NoClipEntity, true, true)
    SetCamActive(Camera, false)
    DestroyCam(Camera, true)
end

local function getGroundCoords(coords)
    local rayCast               = StartShapeTestRay(coords.x, coords.y, coords.z, coords.x, coords.y, -10000.0, 1, 0)
    local _, hit, hitCoords     = GetShapeTestResult(rayCast)
    return (hit == 1 and hitCoords) or coords
end

local function checkInputRotation()
    local rightAxisX = GetControlNormal(0, 220)
    local rightAxisY = GetControlNormal(0, 221)

    local rotation = GetCamRot(Camera, 2)
    local yValue = rightAxisY * -5
    local newX
    local newZ = rotation.z + (rightAxisX * -10)
    if (rotation.x + yValue > -89.0) and (rotation.x + yValue < 89.0) then
        newX = rotation.x + yValue
    end
    if newX ~= nil and newZ ~= nil then
        SetCamRot(Camera, vector3(newX, rotation.y, newZ), 2)
    end

    SetEntityHeading(NoClipEntity, math.max(0, (rotation.z % 360)))
end

function RunNoClipThread()
    CreateThread(function()
        while IsNoClipping do
            Wait(0)
            checkInputRotation()
            disabledControls()

            if isControlAlwaysPressed(2, Noclip.Controls.DecreaseSpeed) then
                Noclip.DefaultSpeed = Noclip.DefaultSpeed - 0.5
                if Noclip.DefaultSpeed < 0.5 then
                    Noclip.DefaultSpeed = 0.5
                end
            elseif isControlAlwaysPressed(2, Noclip.Controls.IncreaseSpeed) then
                Noclip.DefaultSpeed = Noclip.DefaultSpeed + 0.5
                if Noclip.DefaultSpeed > Noclip.MaxSpeed then
                    Noclip.DefaultSpeed = Noclip.MaxSpeed
                end
            elseif IsDisabledControlJustReleased(0, 348) then
                Noclip.DefaultSpeed = 1
            end

            local multi = 1.0
            if isControlAlwaysPressed(0, 21) then -- Left Shift
                multi = 2
            elseif isControlAlwaysPressed(0, 19) then -- Left Alt
                multi = 4
            elseif isControlAlwaysPressed(0, 36) then  -- Left Control
                multi = 0.25
            end

            if isControlAlwaysPressed(0, Noclip.Controls.MoveFoward) then
                local pitch = GetCamRot(Camera, 0)

                if pitch.x >= 0 then
                    SetEntityCoordsNoOffset(NoClipEntity, GetOffsetFromEntityInWorldCoords(NoClipEntity, 0.0, 0.5*(Noclip.DefaultSpeed * multi), (pitch.x*((Noclip.DefaultSpeed/2) * multi))/89))
                else
                    SetEntityCoordsNoOffset(NoClipEntity, GetOffsetFromEntityInWorldCoords(NoClipEntity, 0.0, 0.5*(Noclip.DefaultSpeed * multi), -1*((math.abs(pitch.x)*((Noclip.DefaultSpeed/2) * multi))/89)))
                end
            elseif isControlAlwaysPressed(0, Noclip.Controls.MoveBackward) then
                local pitch = GetCamRot(Camera, 2)

                if pitch.x >= 0 then
                    SetEntityCoordsNoOffset(NoClipEntity, GetOffsetFromEntityInWorldCoords(NoClipEntity, 0.0, -0.5*(Noclip.DefaultSpeed * multi), -1*(pitch.x*((Noclip.DefaultSpeed/2) * multi))/89))
                else
                    SetEntityCoordsNoOffset(NoClipEntity, GetOffsetFromEntityInWorldCoords(NoClipEntity, 0.0, -0.5*(Noclip.DefaultSpeed * multi), ((math.abs(pitch.x)*((Noclip.DefaultSpeed/2) * multi))/89)))
                end
            end

            if isControlAlwaysPressed(0, Noclip.Controls.MoveLeft) then
                SetEntityCoordsNoOffset(NoClipEntity, GetOffsetFromEntityInWorldCoords(NoClipEntity, -0.5*(Noclip.DefaultSpeed * multi), 0.0, 0.0))
            elseif isControlAlwaysPressed(0, Noclip.Controls.MoveRight) then
                SetEntityCoordsNoOffset(NoClipEntity, GetOffsetFromEntityInWorldCoords(NoClipEntity, 0.5*(Noclip.DefaultSpeed * multi), 0.0, 0.0))
            end

            if isControlAlwaysPressed(0, Noclip.Controls.MoveUp) then
                SetEntityCoordsNoOffset(NoClipEntity, GetOffsetFromEntityInWorldCoords(NoClipEntity, 0.0, 0.0, 0.5*(Noclip.DefaultSpeed * multi)))
            elseif isControlAlwaysPressed(0, Noclip.Controls.MoveDown) then
                SetEntityCoordsNoOffset(NoClipEntity, GetOffsetFromEntityInWorldCoords(NoClipEntity, 0.0, 0.0, -0.5*(Noclip.DefaultSpeed * multi)))
            end

            local coords = GetEntityCoords(NoClipEntity)

            RequestCollisionAtCoord(coords.x, coords.y, coords.z)

            FreezeEntityPosition(NoClipEntity, true)
            SetEntityCollision(NoClipEntity, false, false)
            SetEntityVisible(NoClipEntity, false, false)
            SetEntityInvincible(NoClipEntity, true)
            SetLocalPlayerVisibleLocally(true)
            SetEntityAlpha(NoClipEntity, NoClipAlpha, false)
            if PlayerIsInVehicle == 1 then
                SetEntityAlpha(PlayerPed, NoClipAlpha, false)
            end
            SetEveryoneIgnorePlayer(PlayerPed, true)
            SetPoliceIgnorePlayer(PlayerPed, true)
        end
        StopNoClip()
    end)
end

function StopNoClip()
    FreezeEntityPosition(NoClipEntity, false)
    SetEntityCollision(NoClipEntity, true, true)
    SetEntityVisible(NoClipEntity, true, false)
    SetLocalPlayerVisibleLocally(true)
    ResetEntityAlpha(NoClipEntity)
    ResetEntityAlpha(PlayerPed)
    SetEveryoneIgnorePlayer(PlayerPed, false)
    SetPoliceIgnorePlayer(PlayerPed, false)
    ResetEntityAlpha(NoClipEntity)
    SetPoliceIgnorePlayer(PlayerPed, true)
    createEffect()
    -- wsb.hideTextUI()

    if GetVehiclePedIsIn(PlayerPed, false) ~= 0 then
        while (not IsVehicleOnAllWheels(NoClipEntity)) and not IsNoClipping do
            Wait(0)
        end
        while not IsNoClipping do
            Wait(0)
            if IsVehicleOnAllWheels(NoClipEntity) then
                return SetEntityInvincible(NoClipEntity, false)
            end
        end
    else
        if (IsPedFalling(NoClipEntity) and math.abs(1 - GetEntityHeightAboveGround(NoClipEntity)) > 1.00) then
            while (IsPedStopped(NoClipEntity) or not IsPedFalling(NoClipEntity)) and not IsNoClipping do
                Wait(0)
            end
        end
        while not IsNoClipping do
            Wait(0)
            if (not IsPedFalling(NoClipEntity)) and (not IsPedRagdoll(NoClipEntity)) then
                return SetEntityInvincible(NoClipEntity, false)
            end
        end
    end
end

function ToggleNoClip(state)
    IsNoClipping = state or not IsNoClipping
    PlayerPed    = cache.ped
    PlayerIsInVehicle = IsPedInAnyVehicle(PlayerPed, false)
    createEffect()
    if PlayerIsInVehicle ~= 0 and isPedDrivingVehicle(PlayerPed, GetVehiclePedIsIn(PlayerPed, false)) then
        NoClipEntity = GetVehiclePedIsIn(PlayerPed, false)
        SetVehicleEngineOn(NoClipEntity, not IsNoClipping, true, IsNoClipping)
        NoClipAlpha = Noclip.FirstPersonWhileNoclip == true and 0 or 51
    else
        NoClipEntity = PlayerPed
        NoClipAlpha = Noclip.FirstPersonWhileNoclip == true and 0 or 51
    end

    if IsNoClipping then
        FreezeEntityPosition(PlayerPed)
        setupCam()
        PlaySoundFromEntity(-1, 'SELECT', PlayerPed, 'HUD_LIQUOR_STORE_SOUNDSET', 0, 0)
        -- wsb.showTextUI(Strings.textui_noclip_activated)

        if not PlayerIsInVehicle then
            ClearPedTasksImmediately(PlayerPed)
            if Noclip.FirstPersonWhileNoclip then
                Wait(1000) -- Wait for the cinematic effect of the camera transitioning into first person
            end
        else
            if Noclip.FirstPersonWhileNoclip then
                Wait(1000) -- Wait for the cinematic effect of the camera transitioning into first person
            end
        end

    else
        local groundCoords      = getGroundCoords(GetEntityCoords(NoClipEntity))
        SetEntityCoords(NoClipEntity, groundCoords.x, groundCoords.y, groundCoords.z)
        Wait(50)
        destroyCamera()
        PlaySoundFromEntity(-1, 'CANCEL', PlayerPed, 'HUD_LIQUOR_STORE_SOUNDSET', 0, 0)
    end

    SetUserRadioControlEnabled(not IsNoClipping)

    if IsNoClipping then
        RunNoClipThread()
    end
end

RegisterNetEvent('ww-adminmenu:Client:noclip',function()
    ToggleNoClip(not IsNoClipping)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        FreezeEntityPosition(NoClipEntity, false)
        FreezeEntityPosition(PlayerPed, false)
        SetEntityCollision(NoClipEntity, true, true)
        SetEntityVisible(NoClipEntity, true, false)
        SetLocalPlayerVisibleLocally(true)
        ResetEntityAlpha(NoClipEntity)
        ResetEntityAlpha(PlayerPed)
        SetEveryoneIgnorePlayer(PlayerPed, false)
        SetPoliceIgnorePlayer(PlayerPed, false)
        ResetEntityAlpha(NoClipEntity)
        SetPoliceIgnorePlayer(PlayerPed, true)
        SetEntityInvincible(NoClipEntity, false)
    end
end)