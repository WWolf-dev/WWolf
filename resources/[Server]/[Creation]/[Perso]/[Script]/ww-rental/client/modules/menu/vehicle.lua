local function hexToRGB(hex)
    hex = hex:gsub("#", "")
    return {
        tonumber("0x" .. hex:sub(1, 2)),
        tonumber("0x" .. hex:sub(3, 4)),
        tonumber("0x" .. hex:sub(5, 6))
    }
end

local function VehicleRentalLuxe(color1, color2, plate, vehicleLuxe)
    local vehicleModel = lib.RequestModel(vehicleLuxe)
    local vehicle = CreateVehicle(vehicleModel, -494.3251, -672.4961, 32.9422, 348.5219, true, true)
    lib.setVehicleProperties(vehicle, {
        color1 = color1,
        color2 = color2,
        plate = plate,
    })
    TaskWarpPedIntoVehicle(cache.ped, vehicle, -1)
end

local function VehicleRentalSport(color1, color2, vehicleSport)
    local vehicleModel = lib.RequestModel(vehicleSport)
    local vehicle = CreateVehicle(vehicleModel, -494.3251, -672.4961, 32.9422, 348.5219, true, true)
    lib.setVehicleProperties(vehicle, {
        color1 = color1,
        color2 = color2,
        plate = "RENTAL",
    })
    TaskWarpPedIntoVehicle(cache.ped, vehicle, -1)
end

function ParametersVehicleLuxe(vehicle)
    local hasEnoughMoney = lib.callback.await("ww-rental:Server:CheckMoneyLuxe", 100)
    if hasEnoughMoney then
        local parametersInput = lib.inputDialog("Config Vehicle", {
            {
                type = "color",
                label = "Primary Color",
                description = "Choose the primary color of the vehicle",
                default = '#ffffff',
                required = true,
            },
            {
                type = "color",
                label = "Secondary Color",
                description = "Choose the secondary color of the vehicle",
                default = '#ffffff',
                required = true,
            },
            {
                type = "input",
                label = "Vehicle Plate",
                description = "Choose the plate of the vehicle",
                placeholder = "RENTAL",
                icon = "fas fa-car",
                required = true,
            },
        })
        if not parametersInput then return end
        local primaryColor = hexToRGB(parametersInput[1])
        local secondaryColor = hexToRGB(parametersInput[2])
        local plate = parametersInput[3]
        VehicleRentalLuxe(primaryColor, secondaryColor, plate, vehicle)
    end
end

function ParametersVehicleSport(vehicle)
    local hasEnoughMoney = lib.callback.await("ww-rental:Server:CheckMoneySports", 100)
    if hasEnoughMoney then
        local parametersInput = lib.inputDialog("Config Vehicle", {
            {
                type = "color",
                label = "Primary Color",
                description = "Choose the primary color of the vehicle",
                default = '#ffffff',
                required = true,
            },
            {
                type = "color",
                label = "Secondary Color",
                description = "Choose the secondary color of the vehicle",
                default = '#ffffff',
                required = true,
            },
        })
        if not parametersInput then return end
        local primaryColor = hexToRGB(parametersInput[1])
        local secondaryColor = hexToRGB(parametersInput[2])
        VehicleRentalSport(primaryColor, secondaryColor, vehicle)
    end
end