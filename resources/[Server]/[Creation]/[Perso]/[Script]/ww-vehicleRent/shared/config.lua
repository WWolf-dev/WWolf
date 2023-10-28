RentingZone = {
    ["Airport"] = {
        Position = vector4(-1034.0682, -2732.3552, 19.1691, 147.4279),
        Blip = {
            Sprite = 1,
            Color = 1,
            Scale = 0.8,
            Name = "Rental |  Airport",
        },
        NPC = {
            Model = "IG_Charlie_Reed",
            Sceanrio = "WORLD_HUMAN_CAR_PARK_ATTENDANT",
        },
        Vehicles = {
            ["Luxe"] = {
                {
                    Name = "adder",
                    Label = "Adder",
                    Price = 1000,
                    Quantity = 20,
                },
                {
                    Name = "coureur",
                    Label = "Coureur",
                    Price = 2000,
                    Quantity = 15,
                }
            },
            ["SUV"] = {
                {
                    Name = "baller",
                    Label = "Baller",
                    Price = 1000,
                    Quantity = 20,
                },
                {
                    Name = "baller2",
                    Label = "Baller 2",
                    Price = 2000,
                    Quantity = 15,
                }
            }
        },
        Spawn = {
            {
                SpanPoint = vector3(0, 0, 0),
                Heading = 0.0,
            },
            {
                SpanPoint = vector3(0, 0, 0),
                Heading = 0.0,
            }
        }
    },
    ["Subway"] = {
        Position = vector4(-490.3838, -670.4308, 31.8725, 181.0472),
        Blip = {
            Sprite = 1,
            Color = 1,
            Scale = 0.8,
            Name = "Rental | Subway",
        },
        NPC = {
            Model = "IG_Charlie_Reed",
            Sceanrio = "WORLD_HUMAN_CLIPBOARD",
        },
        Vehicles = {
            ["Sport"] = {
                {
                    Name = "gauntlet6",
                    Label = "Gauntlet 6",
                    Price = 1000,
                    Quantity = 20,
                },
                {
                    Name = "stingertt",
                    Label = "Stingert T",
                    Price = 2000,
                    Quantity = 15,
                }
            },
            ["4x4"] = {
                {
                    Name = "monstrociti",
                    Label = "Monstrociti",
                    Price = 1000,
                    Quantity = 20,
                },
                {
                    Name = "l35",
                    Label = "L35",
                    Price = 2000,
                    Quantity = 15,
                }
            }
        },
        Spawn = {
            {
                SpanPoint = vector3(0, 0, 0),
                Heading = 0.0,
            },
            {
                SpanPoint = vector3(0, 0, 0),
                Heading = 0.0,
            }
        }
    },
}