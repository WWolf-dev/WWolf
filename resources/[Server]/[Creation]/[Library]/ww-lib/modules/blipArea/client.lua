---@param blipArea table The table containing the blipArea data.

---@param coords vector3 The coords of the blipArea.
---@param width number The width of the blipArea.
---@param height number The height of the blipArea.
---@param display number The display of the blipArea.
---@param opacity number The opacity of the blipArea.
---@param rotation number The rotation of the blipArea.
---@param colour number The colour of the blipArea.
---@param range boolean The range of the blipArea.

local listBlipArea = {}

function ww.blipArea(data)
    for _, option in pairs(data.options) do
        local id = option.id or "defaultBlipID"
        local coords = option.coords or vec3(0.0, 0.0, 0.0)
        local width = option.width or 100.0
        local height = option.height or 100.0
        local display = option.display or 4
        local opacity = option.opacity or 255
        local rotation = option.rotation or 0
        local colour = option.colour or 0
        local range = option.range or true



        local blip = AddBlipForArea(coords.x, coords.y, coords.z, width, height)

        SetBlipDisplay(blip, display)
        SetBlipAlpha(blip, opacity)
        SetBlipRotation(blip, rotation)
        SetBlipColour(blip, colour)
        SetBlipAsShortRange(blip, range)
        table.insert(listBlipArea, blip)
    end
end

function ww.clearBlipArea()
    for _, blip in pairs(listBlipArea) do
        RemoveBlip(blip)
    end
end

return ww.blipArea