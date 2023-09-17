RentingBlip = {
    ["Airport"] = {
        Coords = vector3(-1034.1736, -2732.9919, 20.1693),
        Sprite = 1,
        Color = 1,
        Scale = 0.8,
        Name = "Rental | Airport"
    },
    ["Subway"] = {
        Coords = vector3(-1031.2979, -2727.3701, 13.7566),
        Sprite = 1,
        Color = 1,
        Scale = 0.8,
        Name = "Rental | Subway"
    },
    ["Random"] = {
        Coords = vector3(-898.6854, -2709.5784, 20.1692),
        Sprite = 1,
        Color = 1,
        Scale = 0.8,
        Name = "Rental | Random"
    },
    ["Delnamas"] = {
        Coords = vector3(-854.5040, -2400.2678, 13.9444),
        Sprite = 1,
        Color = 1,
        Scale = 0.8,
        Name = "Delna | route"
    }
}





UseTarget = "ox_target"         -- "ox_target" or false





UseNPC = true

RentingNPC = {
    ["Airport"] = {
        Coords = vector4(-1034.0635, -2732.9458, 19.1693, 143.8428),
        Name = `IG_Pernell_Moss`,
        Scenario = "WORLD_HUMAN_MUSICIAN",

        Vehicle = {
            {
                VehicleSpawnPoint = vector3(-1028.0599, -2734.5681, 19.4311),
                VehicleHeading = 238.6420
            },
            {
                VehicleSpawnPoint = vector3(-1039.6116, -2727.9517, 19.4296),
                VehicleHeading = 241.8158
            }
        }
    },
    ["Subway"] = {
        Coords = vector4(-1031.2979, -2727.3701, 12.7502, 143.8428),
        Name = `IG_Pernell_Moss`,
        Scenario = "WORLD_HUMAN_MUSICIAN",

        Vehicle = {
            {
                VehicleSpawnPoint = vector3(-1024.6200, -2728.5181, 12.9792),
                VehicleHeading = 241.3872
            },
            {
                VehicleSpawnPoint = vector3(-1040.7206, -2719.0488, 12.9863),
                VehicleHeading = 238.8206
            }
        }
    },
    ["Random"] = {
        Coords = vector4(-898.6854, -2709.5784, 19.1629, 143.8428),
        Name = `IG_Pernell_Moss`,
        Scenario = "WORLD_HUMAN_MUSICIAN",

        Vehicle = {
            {
                VehicleSpawnPoint = vector3(-905.6852, -2716.8901, 19.4253),
                VehicleHeading = 333.5515
            },
            {
                VehicleSpawnPoint = vector3(-892.3383, -2694.7651, 19.4179),
                VehicleHeading = 324.6566
            }
        }
    },
    ["Delnamas"] = {
        Coords = vector4(-854.5040, -2400.2678, 12.9444, 4.6893),
        Name = `A_C_Pug_02`,
        Scenario = "",

        Vehicle = {
            {
                VehicleSpawnPoint = vector3(-855.4591, -2386.7100, 13.9444),
                VehicleHeading = 4.1058
            },
            {
                VehicleSpawnPoint = vector3(-862.2260, -2413.5344, 13.9030),
                VehicleHeading = 151.8074
            }
        }
    },
}

VehicleCategories = {
    ["Luxe"] = {
        IconOfCategory = "fa-solid fa-circle",
        vehicle = {
            {
                name = "coureur",
                label = "Coureuse",
                Quantity = 5,
                Price = 1000
            },
            {
                name = "stingertt",
                label = "Stingert",
                Quantity = 10,
                Price = 1500
            }
        }
    },
    ["Eco"] = {
        IconOfCategory = "fa-solid fa-circle",
        vehicle = {
            {
                name = "clique2",
                label = "Clique",
                Quantity = 15,
                Price = 500
            },
            {
                name = "brigham",
                label = "Brighame",
                Quantity = 20,
                Price = 100
            }
        }
    },
    ["S.U.V"] = {
        IconOfCategory = "fa-solid fa-circle",
        vehicle = {
            {
                name = "l35",
                label = "I355",
                Quantity = 25,
                Price = 2000
            },
            {
                name = "monstrociti",
                label = "Monstrocitii",
                Quantity = 30,
                Price = 2500
            }
        }
    },
    ["Delna"] = {
        IconOfCategory = "fa-solid fa-circle",
        vehicle = {
            {
                name = "outlaw",
                label = "Gerar",
                Quantity = 50,
                Price = 1000
            },
            {
                name = "guardian",
                label = "Michel",
                Quantity = 5,
                Price = 1500
            }
        }
    },
    -- Ajoutez ici d'autres catégories de véhicules...
}