local function ScaleformButtons(keysTable)
    local scaleform = RequestScaleformMovie("instructional_buttons")
    while not HasScaleformMovieLoaded(scaleform) do
        Wait(10)
    end
    BeginScaleformMovieMethod(scaleform, "CLEAR_ALL")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_CLEAR_SPACE")
    ScaleformMovieMethodAddParamInt(200)
    EndScaleformMovieMethod()

    for btnIndex, keyData in ipairs(keysTable) do
        local btn = GetControlInstructionalButton(0, keyData[2], true)

        BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
        ScaleformMovieMethodAddParamInt(btnIndex - 1)
        ScaleformMovieMethodAddParamPlayerNameString(btn)
        BeginTextCommandScaleformString("STRING")
        AddTextComponentSubstringKeyboardDisplay(keyData[1])
        EndTextCommandScaleformString()
        EndScaleformMovieMethod()
    end

    BeginScaleformMovieMethod(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_BACKGROUND_COLOUR")
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamInt(80)
    EndScaleformMovieMethod()

    return scaleform
end

local  CONTROLS = { exit = 194, screenshot = Spectate.Screenshot.Button, revive = Spectate.Revive.Button, kick = Spectate.Kick.Button}

-- Last spectate location stored in a vec3
local spectatorReturnCoords
-- Spectate mode
local isSpectateEnabled = false
-- Whether should we lock the camera to the target ped
local isInTransitionState = false
-- Spectated ped
local storedTargetPed
-- Spectated player's client ID
local storedTargetPlayerId
-- Spectated players associated server id
local storedTargetServerId


local function calculateSpectatorCoords(coords)
    return vec3(coords.x, coords.y, coords.z - 15.0)
end

local function prepareSpectatorPed(enabled)
    local playerPed = PlayerPedId()
    FreezeEntityPosition(playerPed, enabled)
    SetEntityVisible(playerPed, not enabled, 0)

    if enabled then
        TaskLeaveAnyVehicle(playerPed, 0, 16)
    end
end


local function collisionTpCoordTransition(coords)
    -- Fade screen to black
    if not IsScreenFadedOut() then DoScreenFadeOut(500) end
    while not IsScreenFadedOut() do Wait(5) end

    -- Teleport player back
    local playerPed = PlayerPedId()
    RequestCollisionAtCoord(coords.x, coords.y, coords.z)
    SetEntityCoords(playerPed, coords.x, coords.y, coords.z)
    local attempts = 0
    while not HasCollisionLoadedAroundEntity(playerPed) do
        Wait(5)
        attempts = attempts + 1
        if attempts > 1000 then
            print('Failed to load collisions')
            error()
        end
    end
end

--- Stops spectating
local function stopSpectating()
    isSpectateEnabled = false
    isInTransitionState = true

    -- blackout screen
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do Wait(5) end

    -- reset spectator
    NetworkSetInSpectatorMode(false, nil)
     SetMinimapInSpectatorMode(false, nil)
    if spectatorReturnCoords then
        print('Returning spectator to original coords')
        if not pcall(collisionTpCoordTransition, spectatorReturnCoords) then
            print('collisionTpCoordTransition failed!')
        end
    else
        print('No spectator return coords saved')
    end
    prepareSpectatorPed(false)
  --  toggleShowPlayerIDs(false, false)

    -- resetting cache + threads
    storedTargetPed = nil
    storedTargetPlayerId = nil
    storedTargetServerId = nil
    spectatorReturnCoords = nil

    -- fading screen back & marking as done
    DoScreenFadeIn(500)
    while IsScreenFadingIn() do Wait(5) end
    isInTransitionState = false

    --logging that we stopped
    TriggerServerEvent('end')
end

local function createSpectatorTeleportThread()
    CreateThread(function()
        local initialTargetServerid = storedTargetServerId
        while isSpectateEnabled and storedTargetServerId == initialTargetServerid do
            -- If ped doesn't exist anymore try to resolve it again
            if not DoesEntityExist(storedTargetPed) then
                local newPed = GetPlayerPed(storedTargetPlayerId)
                if newPed > 0 then
                    storedTargetPed = newPed
                else
                    stopSpectating()
                    break
                end
            end
            -- Update Teleport
            local newSpectateCoords = calculateSpectatorCoords(GetEntityCoords(storedTargetPed))
            SetEntityCoords(PlayerPedId(), newSpectateCoords.x, newSpectateCoords.y, newSpectateCoords.z, 0, 0, 0, false)

            Wait(500)
        end
    end)
end


local getWebhook = function()
    local webhook = lib.callback.await('wasabi_adminmenu:screenWebhook', 300)
    return webhook
end

local screenshot = function()
    exports['screenshot-basic']:requestScreenshotUpload(getWebhook()[2], 'files[]', function(data2)
        local resp = json.decode(data2)
        if not resp or not resp?.attachments?[1]?.proxy_url then
            -- TriggerEvent('wasabi_bridge:notify', Strings.notify_error, Strings.invalid_webhook_setup_desc, 'error')
            return
        end
    end)
end

-- Instructional stuff
local keysTable = {
    {Strings.spectate_exit, CONTROLS.exit},
}

if Spectate.Screenshot.Enabled then
    keysTable[#keysTable+1] = {Strings.spectate_screenshot, CONTROLS.screenshot}
end

if Spectate.Revive.Enabled then
    keysTable[#keysTable+1] = {Strings.spectate_revive, CONTROLS.revive}
end

if  Spectate.Kick.Enabled then
    keysTable[#keysTable+1] = {Strings.spectate_kick, CONTROLS.kick}
end

local function fivemCheckControls(target)
    if Spectate.Screenshot.Enabled and IsControlJustPressed(0, CONTROLS.screenshot)  then
        screenshot()
    end
    if IsControlJustPressed(0, CONTROLS.exit) then
        stopSpectating()
    end
    if Spectate.Revive.Enabled and IsControlJustPressed(0, CONTROLS.revive) then
        TriggerServerEvent('wasabi_adminmenu:revive', target)
    end
    if Spectate.Kick.Enabled and IsControlJustPressed(0, CONTROLS.kick) then
        local dropPlayer = lib.callback.await('wasabi_adminmenu:dropPlayer', 100, target, Strings.kicked_reason_replace)
        if dropPlayer then
            -- TriggerEvent('wasabi_bridge:notify', Strings.notify_kicked_success, (Strings.notify_kicked_success_desc:format(dropPlayer)), 'success', 'fa-check')
        end
    end
end


--- Creates and draws the instructional scaleform
local function createInstructionalThreads(ped)
    CreateThread(function()
        local fivemScaleform = ScaleformButtons(keysTable)
        while isSpectateEnabled do
                DrawScaleformMovieFullscreen(fivemScaleform, 255, 255, 255, 255, 0)
            Wait(0)
        end

        SetScaleformMovieAsNoLongerNeeded()
    end)

    --controls thread for redm - disabled when menu is visible
    CreateThread(function()
        while isSpectateEnabled do
            fivemCheckControls(ped)
            Wait(5)
        end
    end)
end


-- Client-side event handler for failed cype (no next player or whatever)
RegisterNetEvent('cycleFailed', function()
    -- TriggerEvent('wasabi_bridge:notify', Strings.notify_error, Strings.spectate_error, 'error')
    print('cycleFailed')
end)

-- Client-side event handler for an authorized spectate request
RegisterNetEvent('start', function(targetServerId, targetCoords)
    if isInTransitionState then
        stopSpectating()
    end

    -- check if self-spectate
    if targetServerId == GetPlayerServerId(PlayerId()) then
        -- return  TriggerEvent('wasabi_bridge:notify', Strings.notify_error, Strings.spectate_error, 'error')
        return print('self-spectate')
    end

    -- mark transitory state - locking the init of another spectate
    isInTransitionState = true

    -- wiping any previous spectate cache
    -- maybe not needed, but just to make sure
    storedTargetPed = nil
    storedTargetPlayerId = nil
    storedTargetServerId = nil

    -- saving current player coords and preparing ped
    if spectatorReturnCoords == nil then
        local spectatorPed = PlayerPedId()
        spectatorReturnCoords = GetEntityCoords(spectatorPed)
    end
    prepareSpectatorPed(true)

    local coordsUnderTarget = calculateSpectatorCoords(targetCoords)
    if not pcall(collisionTpCoordTransition, coordsUnderTarget) then
        print('collisionTpCoordTransition failed!')
        stopSpectating()
        return
    end

    -- resolving target and saving in cache
    -- this will try for up to 15 seconds (redm is slow af)
    local targetResolveAttempts = 0
    local resolvedPlayerId = -1
    local resolvedPed = 0
    while (resolvedPlayerId <= 0 or resolvedPed <= 0) and targetResolveAttempts < 300 do
        targetResolveAttempts = targetResolveAttempts + 1
        resolvedPlayerId = GetPlayerFromServerId(targetServerId)
        resolvedPed = GetPlayerPed(resolvedPlayerId)
        Wait(50)
    end

    --If failed to resolve the targer
    if (resolvedPlayerId <= 0 or resolvedPed <= 0) then
        print('Failed to resolve target PlayerId or Ped')
        -- reset spectator
        if not pcall(collisionTpCoordTransition, spectatorReturnCoords) then
            print('collisionTpCoordTransition failed!')
        end
        prepareSpectatorPed(false)
        -- Fade screen back
        DoScreenFadeIn(500)
        while IsScreenFadedOut() do Wait(5) end
        -- mark as finished
        isInTransitionState = false
        spectatorReturnCoords = nil
        return sendSnackbarMessage('error', 'nui_menu.player_modal.actions.interaction.notifications.spectate_failed', true)
    end

    storedTargetPed = resolvedPed
    storedTargetPlayerId = resolvedPlayerId
    storedTargetServerId = targetServerId

    -- start spectating
    NetworkSetInSpectatorMode(true, resolvedPed)
        SetMinimapInSpectatorMode(true, resolvedPed)

    isSpectateEnabled = true
    isInTransitionState = false
    --toggleShowPlayerIDs(true, false)
    createSpectatorTeleportThread()
    createInstructionalThreads(targetServerId)

    -- Fade screen back
    DoScreenFadeIn(500)
    while IsScreenFadedOut() do Wait(5) end
end)

--- Thanks txadmin for hooking me up with the snippet for some of it