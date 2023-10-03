AmmuZone = {
    ["Sud"] = {
        Blip = {
            Coords = vector3(22.3131, -1109.0369, 42.3580),
            Sprite = 1,
            Scale = 0.8,
            Color = 1,
            Opacity = 254,
            Name = "Ammu-Nation Sud",
        },
        WorkBlip = {
            {
                Coords = vector3(17.3324, -1126.8365, 28.8402),
                Sprite = 1,
                Scale = 0.8,
                Color = 1,
                Opacity = 254,
                Name = "Farm 1 Sud",
            },
            {
                Coords = vector3(43.1319, -1127.2145, 29.3467),
                Sprite = 1,
                Scale = 0.8,
                Color = 1,
                Opacity = 254,
                Name = "Farm 2 Sud",
            },
        },
        NPC = {
            Coords = vector4(23.5065, -1108.8601, 28.7970, 95.3389),
            Model = "IG_Charlie_Reed",
            Scenario = "WORLD_HUMAN_CLIPBOARD",
            IsPedFrozen = true,
            IsPedInvincible = true,
        },
        WorkNPC = {
            ["Farm 1 Sud"] = {
                Coords = vector4(16.5970, -1123.2217, 27.8699, 4.4563),
                Model = "IG_Charlie_Reed",
                Scenario = "WORLD_HUMAN_CLIPBOARD",
                IsPedFrozen = true,
                IsPedInvincible = true,

                TargetLabelStart = "Recup Item",
                TargetLabelStop = "Stop Recup Item",

                ItemToFarm = "usb_key",
                MaxItemToFarm = 50,
                TimeBetweenItem = 1000


            },
            ["Farm 2 Sud"] = {
                Coords = vector4(14.6495, -1121.8096, 27.7921, 261.7418),
                Model = "IG_Charlie_Reed",
                Scenario = "WORLD_HUMAN_CLIPBOARD",
                IsPedFrozen = true,
                IsPedInvincible = true,

                TargetLabelStart = "Recup Item",
                TargetLabelStop = "Stop Recup Item",

                ItemToFarm = "usb_key",
                MaxItemToFarm = 50,
                TimeBetweenItem = 1000
            },
        },
    },
    ["Nord"] = {
        Blip = {
            Coords = vector3(-324.6002, 6075.7002, 31.2456),
            Sprite = 1,
            Scale = 0.8,
            Color = 1,
            Opacity = 254,
            Name = "Ammu-Nation Nord",
        },
        WorkBlip = {
            {
                Coords = vector3(-315.6196, 6081.8242, 31.2425),
                Sprite = 1,
                Scale = 0.8,
                Color = 1,
                Opacity = 254,
                Name = "Farm 1 Nord",
            },
            {
                Coords = vector3(-317.2724, 6086.2051, 31.4029),
                Sprite = 1,
                Scale = 0.8,
                Color = 1,
                Opacity = 254,
                Name = "Farm 2 Nord",
            },
        },
        NPC = {
            Coords = vector4(-327.8362, 6084.3931, 30.4548, 178.9105),
            Model = "IG_Charlie_Reed",
            Scenario = "WORLD_HUMAN_CLIPBOARD",
            IsPedFrozen = true,
            IsPedInvincible = true,
        },
        WorkNPC = {
            ["Farm 1 Nord"] = {
                Coords = vector4(-315.6196, 6081.8242, 30.2425, 323.7218),
                Model = "IG_Charlie_Reed",
                Scenario = "WORLD_HUMAN_CLIPBOARD",
                IsPedFrozen = true,
                IsPedInvincible = true,

                TargetLabelStart = "Recup Item",
                TargetLabelStop = "Stop Recup Item",

                ItemToFarm = "usb_key",
                MaxItemToFarm = 50,
                TimeBetweenItem = 1000
            },
            ["Farm 2 Nord"] = {
                Coords = vector4(-314.8183, 6086.8950, 30.3575, 40.2332),
                Model = "IG_Charlie_Reed",
                Scenario = "WORLD_HUMAN_CLIPBOARD",
                IsPedFrozen = true,
                IsPedInvincible = true,

                TargetLabelStart = "Recup Item",
                TargetLabelStop = "Stop Recup Item",

                ItemToFarm = "usb_key",
                MaxItemToFarm = 50,
                TimeBetweenItem = 1000
            },
        },
    },
}