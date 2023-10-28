AddEventHandler("onResourceStart", function(resource)
    if resource == GetCurrentResourceName() then
        test()
    end
end)

function test()
    ww.blip({
        options = {
            {
                id = "testBlip",
                coords = vec3(100.0, 100.0, 100.0),
                sprite = 1,
                display = 4,
                scale = 1.0,
                color = 1,
                range = true,
                label = "Default Blip Label"
            },
            {
                id = "testBlip2",
                coords = vec3(150.0, 150.0, 150.0),
                display = 4,
                scale = 1.0,
                color = 0,
                range = true,
                label = "Default Blip"
            },
        }
    })

    ww.blipRadius({
        options = {
            {
                id = "test_blip_radius_1",
                coords = vec4(100.0, 100.0, 100.0, 100.0),
                display = 4,
                opacity = 120,
                rotation = 0,
                colour = 1,
                range = true
            },
            {
                id = "test_blip_radius_2",
                coords = vec4(10.0, 10.0, 10.0, 100.0),
                display = 4,
                opacity = 120,
                rotation = 0,
                colour = 12,
                range = true
            },
        }
    })

    ww.blipArea({
        options = {
            {
                id = "test_blip_area_1",
                coords = vec3(100.0, 100.0, 100.0),
                width = 100.0,
                height = 200.0,
                display = 4,
                opacity = 120,
                rotation = 0,
                colour = 1,
                range = true
            },
            {
                id = "test_blip_area_2",
                coords = vec3(10.0, 10.0, 10.0),
                width = 200.0,
                height = 100.0,
                display = 4,
                opacity = 120,
                rotation = 0,
                colour = 12,
                range = true
            },
        }
    })

    ww.spawnNPC({
        options ={
            {
                id = "testNPC",
                coords = vec4(-5.6002, 4.5003, 70.0912, 0.0000),
                model = "IG_Pernell_Moss",
                type = 4,
                isNetwork = true,
                isScriptHosted = false,
                isFrozen = true,
                isInvincible = true,
                isTemporaryEventBlocked = true,
                isSetAsMissionEntity = true,
                -- animation = {
                --     dict = "anim@scripted@charlie_missions@mission_5@ig1_avi_hacking@",
                --     name = "hack",
                -- },
                -- scenario = {
                --     name = "WORLD_HUMAN_AA_SMOKE",
                -- },
                isModelNoLongerNeeded = true,
            },
        }
    })

    ww.spawnTrain({
        switchTrainTrack = {
            {
                trackID = 0,
                state = true,
            },
            {
                trackID = 3,
                state = true,
            },
        },
        trainTrackSpawnFrequency = {
            {
                trackID = 0,
                frequency = 100,
            },
            {
                trackID = 3,
                frequency = 100,
            },
        },
        randomTrain = true,
    })
end

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        ww.clearNPC()
    end
end)