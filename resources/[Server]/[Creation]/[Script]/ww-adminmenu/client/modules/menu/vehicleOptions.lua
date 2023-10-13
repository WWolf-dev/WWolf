local torqueLoop, breakLoop


local function hexToRGB(hex)
    hex = hex:gsub("#", "")
    return {
        tonumber("0x" .. hex:sub(1, 2)),
        tonumber("0x" .. hex:sub(3, 4)),
        tonumber("0x" .. hex:sub(5, 6))
    }
end

local function RepairCar()
    local coords = GetEntityCoords(cache.ped)
    local vehicle = lib.getClosestVehicle(coords, 5.0, true)
    if not vehicle or not DoesEntityExist(vehicle) then return end
    SetVehicleUndriveable(vehicle, false)
    SetVehicleFixed(vehicle)
    SetVehicleEngineOn(vehicle, true, true, false)
    SetVehicleDirtLevel(vehicle, 0.0)
    SetVehicleOnGroundProperly(vehicle)
    SetVehicleFuelLevel(vehicle, SetMaxFuel(vehicle))
end

local function DeleteCar()
    local coords = GetEntityCoords(cache.ped)
    local vehicle = lib.getClosestVehicle(coords, 5.0, true)
    if not vehicle or not DoesEntityExist(vehicle) then return end
    SetEntityAsMissionEntity(vehicle, true, true)
    DeleteEntity(vehicle)
end

local function ChangePlate()
    local coords = GetEntityCoords(cache.ped)
    local vehicle = lib.getClosestVehicle(coords, 5.0, true)
    if not vehicle or not DoesEntityExist(vehicle) then return end
    local vehiclePlate = lib.inputDialog("Modify your License Plate", {
        {
            type = 'input',
            label = "Plate..",
            placeholder = "License Plate"
        }
    })
    if not vehiclePlate then return end
    lib.setVehicleProperties(vehicle, {plate = tostring(vehiclePlate[1])})
end

local function Refuel()
    local coords = GetEntityCoords(cache.ped)
    local vehicle = lib.getClosestVehicle(coords, 5.0, true)
    if not vehicle or not DoesEntityExist(vehicle) then return end
    SetVehicleFuelLevel(vehicle, SetMaxFuel(vehicle))
end

local function GiveKeys()
    if not UsingVehicleKeys or UsingVehicleKeys == '' then return end
    local coords = GetEntityCoords(cache.ped)
    local vehicle = lib.getClosestVehicle(coords, 5.0, true)
    if not vehicle or not DoesEntityExist(vehicle) then return end
    GiveVehicleKeys(GetVehicleNumberPlateText(vehicle))
end

local function DoorStatus()
    local coords = GetEntityCoords(cache.ped)
    local vehicle = lib.getClosestVehicle(coords, 5.0, true)
    if not vehicle or not DoesEntityExist(vehicle) then return end
    lib.registerContext({
        id = "admin_menu_doorstatus",
        title = "Door Settings",
        menu = "admin_menu_vehicleoptions",
        options = {
            {
                title = "Lock Doors",
                description = "Locks all doors on the vehicle",
                icon = "fa-lock",
                onSelect = function()
                    SetVehicleDoorsLocked(vehicle, 2)
                end
            },
            {
                title = "Unlock Doors",
                description = "UnLocks all doors on the vehicle",
                icon = "fa-unlock",
                onSelect = function()
                    SetVehicleDoorsLocked(vehicle, 1)
                end
            }
        }
    })

    lib.showContext("admin_menu_doorstatus")
end

local function SetTorque()
    local torqueLoop, breakLoop
    if not IsPedInAnyVehicle(cache.ped, true) then return end
    if torqueLoop then breakLoop = true end
    local vehicle = GetVehiclePedIsIn(cache.ped, false)
    local torqueOptions = {}
    for _, power in pairs(TorqueMultiplier) do
        torqueOptions[#torqueOptions + 1] = {
            title = power.label,
            description = "Level up speed up to : " .. power.label,
            icon = "fa-bolt",
            onSelect = function()
                CreateThread(function()
                    torqueLoop = true
                    while true do
                        if breakLoop or not IsPedInAnyVehicle(cache.ped, true) then
                            torqueLoop, breakLoop = nil, nil
                            break
                        end
                        SetVehicleCheatPowerIncrease(vehicle, power.value)
                        Wait(0)
                    end
                end)
            end
        }
    end

    lib.registerContext({
        id = "admin_menu_torque",
        title = "Torque Settings",
        menu = "admin_menu_vehicleoptions",
        options = torqueOptions
    })

    lib.showContext("admin_menu_torque")
end

local function ChangeVehColor()
    local coords = GetEntityCoords(cache.ped)
    local vehicle = lib.getClosestVehicle(coords, 5.0, true)
    if not vehicle or not DoesEntityExist(vehicle) then return end
    local colorInput = lib.inputDialog("Modify your Vehicle Color", {
        {
            type = 'color',
            label = "Primary Color",
            default = '#ffffff',
        },
        {
            type = 'color',
            label = "Secondary Color",
            default = '#ffffff',
        }
    })
    if not colorInput then return end
    local primaryColor = hexToRGB(colorInput[1])
    local secondColor = hexToRGB(colorInput[2])
    lib.setVehicleProperties(vehicle, {
        color1 = {
            primaryColor[1],
            primaryColor[2],
            primaryColor[3]
        },
        color2 = {
            secondColor[1],
            secondColor[2],
            secondColor[3]
        }
    })
end

local function SpawnCar()
    local SpawnInput = lib.inputDialog(Strings.dialog_spawn_a_car, { 
        {
            type = 'input',
            label = Strings.dialog_car_model,
            placeholder = Strings.dialog_car_model_holder
        },
        {
            type = 'input',
            label = Strings.dialog_car_plate,
            placeholder = Strings.dialog_car_plate_holder
        },
        {
            type = 'color',
            label = Strings.dialog_car_color_primary,
            default = '#ffffff',
        },
        {
            type = 'color',
            label = Strings.dialog_car_color_second,
            default = '#ffffff',
        },
        {
            type = 'checkbox',
            label = Strings.dialog_car_maxed,
            checked = false
        }
    })
    if not SpawnInput then return end
    if not SpawnInput[1] then return end
    local primaryColor = hexToRGB(SpawnInput[3])
    local secondColor = hexToRGB(SpawnInput[4])
    local Ply = cache.ped
    local coords = GetEntityCoords(Ply)
    local heading = GetEntityHeading(Ply)
    lib.requestModel(SpawnInput[1], 100)
    if IsPedInAnyVehicle(Ply, false) then
        local veh = GetVehiclePedIsIn(Ply, false)
        DeleteEntity(veh)
    end
    ESX.Game.SpawnVehicle(SpawnInput[1], coords, heading, function(spawnedVehicle)
        if SpawnInput[2] then
            lib.setVehicleProperties(spawnedVehicle, {plate = tostring(SpawnInput[2])})
            print("Plate is set : ".. SpawnInput[2])
        end
        if SpawnInput[5] then
---@diagnostic disable-next-line: assign-type-mismatch
            lib.setVehicleProperties(spawnedVehicle, {modTurbo = SpawnInput[5]})
            print("Turbo is on")
        end
        lib.setVehicleProperties(spawnedVehicle, {
            color1 = {
                primaryColor[1],
                primaryColor[2],
                primaryColor[3]
            },
            print("Color 1 is set : ".. primaryColor[1] .. " " .. primaryColor[2] .. " " .. primaryColor[3]),
            color2 = {
                secondColor[1],
                secondColor[2],
                secondColor[3]
            },
            print("Color 2 is set : ".. secondColor[1] .. " " .. secondColor[2] .. " " .. secondColor[3]),
            dirtLevel = 0.0,
            print("Dirt level is set to : 0.0")
        })
        if UsingVehicleKeys and UsingVehicleKeys ~= '' then
            GiveVehicleKeys(GetVehicleNumberPlateText(spawnedVehicle), SpawnInput[1], spawnedVehicle)
        end
        TaskWarpPedIntoVehicle(cache.ped, spawnedVehicle, -1)
    end)
end

function VehicleOptions(perms)
    lib.registerContext({
        id = "admin_menu_vehicleoptions",
        title = Strings.vehicle_menu,
        menu = "admin_menu_main",
        options = {
            {
                title = Strings.spawn_car,
                description = Strings.spawn_car_desc,
                icon = "fa-car-on",
                onSelect = function()
                    SpawnCar()
                end
            },
            {
                title = Strings.repair_car,
                description = Strings.repair_car_desc,
                icon = "fa-screwdriver-wrench",
                onSelect = function()
                    RepairCar()
                end
            },
            {
                title = Strings.delete_car,
                description = Strings.delete_car_desc,
                icon = "fa-trash",
                onSelect = function()
                    DeleteCar()
                end
            },
            {
                title = Strings.number_plate,
                description = Strings.number_plate_desc,
                icon = "fa-pen",
                onSelect = function()
                    ChangePlate()
                end
            },
            {
                title = Strings.refuel,
                description = Strings.refuel_desc,
                icon = "fa-gas-pump",
                onSelect = function()
                    Refuel()
                end
            },
            {
                title = Strings.give_keys,
                description = Strings.give_keys_desc,
                icon = "fa-key",
                onSelect = function()
                    GiveKeys()
                end
            },
            {
                title = Strings.doors,
                description = Strings.doors_desc,
                icon = "fa-unlock-keyhole",
                onSelect = function()
                    DoorStatus()
                end
            },
            {
                title = Strings.boost_car,
                description = Strings.boost_car_desc,
                icon = "fa-bolt",
                onSelect = function()
                    SetTorque()
                end
            },
            {
                title = Strings.color_change,
                description = Strings.color_change_desc,
                icon = "fa-palette",
                onSelect = function()
                    ChangeVehColor()
                end
            },
        }
    })

    lib.showContext("admin_menu_vehicleoptions")
end