openKey = 'F9'
UsingVehicleKeys = ""
SkinMenu = "esx_skin"
FuelSystem = ""
Inventory = "ox"
SpeedMeasurement = "kmh" -- Options: 'mph' or 'kmh'

adminPerms = { -- Different ways of defining who has permission to access and utilize the admin menu
    UserGroups = {
        enabled = true, -- Enable usergroups from framework (Esx/QBCore), example/common groups below by default.
        groups = {
            -- Customize and add more like example of 'mod'
            ['admin'] = { -- Group name
                ban = true, -- Ability to ban
                kick = true, -- Ability to kick
                teleport = true, -- Ability to bring/goto players
                zones = true, -- Ability to utilize the zones system
                money = true, -- Ability to give money
                items = true, -- Ability to give items
                vehicles = true, -- Ability to use vehicle functions
                revive = true, -- Ability to revive others and themselves
                heal = true, -- Ability to heal others and themselves
                skin = true, -- Ability to open skin menu and give it to others
                invisible = true, -- Ability to toggle invisibility
                godmode = true, -- Ability to toggle god mode
                setped = true, -- Ability to set peds in the menu
                noclip = true, -- Ability to use no clip functions
                inventory = true, -- Access / clear inventories
                spectate = true, -- Ability to spectate via player options
            },
            ['god'] = { 
                allPerms = true, -- allPerms can be defined to grant all perms at once
            },
--          ['mod'] = { 
--              ban = true,
--              kick = true,
--              teleport = true, 
--          },
        }
    },
    
----------------------------------------------
--------------- Ace Permissions  -------------
----------------------------------------------
    AcePerms = {
        enabled = true, -- Enable ace perms?
        -- Players with any of these perms will gain access to menu, but will be restricted in regards to features
        -- below, and allPerms is unrestricted.
        allPerms = 'wasabi.adminmenu.allow', -- Example in server.cfg: add_ace group.admin wasabi.adminmenu.allow allow 
        -- allPerms: Enable all permissions within admin menu
        ban = 'wasabi.adminmenu.ban', -- Example in server.cfg: add_ace group.admin wasabi.adminmenu.ban allow 
        -- ban: Enable all ban functions
        kick = 'wasabi.adminmenu.kick', -- Example in server.cfg: add_ace group.admin wasabi.adminmenu.kick allow 
        -- kick: Enable all kick functions
        teleport = 'wasabi.adminmenu.teleport', -- Example in server.cfg: add_ace group.admin wasabi.adminmenu.teleport allow 
        -- teleport: Enable goto/bring player functions
        zones = 'wasabi.adminmenu.zones', -- Example in server.cfg: add_ace group.admin wasabi.adminmenu.zones allow 
        -- zones: enable access to zones system
        money = 'wasabi.adminmenu.money', -- Example in server.cfg: add_ace group.admin wasabi.adminmenu.money allow
        -- money: Enable all money related functions
        items = 'wasabi.adminmenu.items', -- Example in server.cfg: add_ace group.admin wasabi.adminmenu.items allow 
        -- items: Ability to give items from menu
        vehicles = 'wasabi.adminmenu.vehicles', -- Example in server.cfg: add_ace group.admin wasabi.adminmenu.vehicles allow 
        -- vehicles: Enable vehicle related functions
        revive = 'wasabi.adminmenu.revive', -- Example in server.cfg: add_ace group.admin wasabi.adminmenu.revive allow 
        -- revive: Allows revive functions
        heal = 'wasabi.adminmenu.heal', -- Example in server.cfg: add_ace group.admin wasabi.adminmenu.heal allow 
        -- heal: Enable heal related functions
        skin = 'wasabi.adminmenu.skin', -- Example in server.cfg: add_ace group.admin wasabi.adminmenu.skin allow 
        -- skin: Enable skin menu related functions
        invisible = 'wasabi.adminmenu.invisible', -- Example in server.cfg: add_ace group.admin wasabi.adminmenu.invisible allow 
        -- invisible: Enable toggle being invisible
        godmode = 'wasabi.adminmenu.godmode', -- Example in server.cfg: add_ace group.admin wasabi.adminmenu.godmode allow 
        -- invisible: Enable toggle godmode
        setped = 'wasabi.adminmenu.setped', -- Example in server.cfg: add_ace group.admin wasabi.adminmenu.setped allow 
        -- setped: Enable setting ped from menu
        noclip = 'wasabi.adminmenu.noclip', -- Example in server.cfg: add_ace group.admin wasabi.adminmenu.noclip allow 
        -- noclip: Enable toggle being no clip
        inventory = 'wasabi.adminmenu.inventory', -- Example in server.cfg: add_ace group.admin wasabi.adminmenu.inventory allow 
        -- inventory: Enable inventory related functions
        spectate = 'wasabi.adminmenu.spectate', -- Example in server.cfg: add_ace group.admin wasabi.adminmenu.spectate allow 
        -- spectate: Enable spectate ability within player options

    } 
}

-- Jobs = {
--     {
--         label = 'Police',
--         name = 'police'
--     },
--     {
--         label = 'EMS',
--         name = 'ambulance'
--     },
--     {
--         label = 'Mechanic',
--         name = 'mechanic'
--     },
--     {
--         label = 'Car Dealer',
--         name = 'cardealer'
--     }
-- }

Noclip = {
    FirstPersonWhileNoclip = true,
    DefaultSpeed = 1.0,
    MaxSpeed = 12.0,
    Controls = {
        DecreaseSpeed = 14, -- Mouse wheel down
        IncreaseSpeed = 15, -- Mouse wheel up
        MoveFoward = 32, -- W
        MoveBackward = 33, -- S
        MoveLeft = 34, -- A
        MoveRight = 35, -- D
        MoveUp = 44, -- Q
        MoveDown = 46, -- E
    },
    Particle = {
        Fxname = 'core',
        Effectname = 'ent_dst_elec_fire_sp'
    }
}

Spectate = {
    Screenshot = {
        Enabled = true, -- toggle on or off
        Button = 191, -- Enter
    },
     Revive = {
        Enabled = true, -- toggle on or off
        Button = 29, -- B
     },
     Kick = {
        Enabled = false, -- toggle on or off
        Button = 47, -- G
     }
}

Ban = { -- value is ban time in hours
    {
        label = '2 Hours',
        value = 2
    },
    {
        label = '24 Hours',
        value = 24
    },
    {
        label = '1 Week',
        value = 168
    },
    {
        label = 'Permanent',
        value = 200000   -- 200000 hours is 22 years
    }
}

TorqueMultiplier = { --- https://docs.fivem.net/natives/?_0xB59E4BD37AE292DB
    {
        label = 'Off',
        value = 0.999999
    },
    {
        label = '25%',
        value = 4.0
    },
    {
        label = '50%',
        value = 8.0
    },
    {
        label = '75%',
        value = 10.0
    },
    {
        label = '100%',
        value = 100.0
    }
}