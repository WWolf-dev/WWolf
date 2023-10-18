---@param blip table The table containing the blip data.

---@param coords vector3 The coords of the blip.
---@param sprite number The sprite of the blip.
---@param display number The display of the blip.
---@param scale number The scale of the blip.
---@param color number The color of the blip.
---@param range boolean The range of the blip.
---@param label string The label of the blip.

local listBlip = {}
function ww.blip(data)

    for _, option in pairs(data.options) do
        local id = option.id or "defaultBlipID"
        local coords = option.coords or vec3(0.0, 0.0, 0.0)
        local sprite = option.sprite or 1
        local display = option.display or 4
        local scale = option.scale or 1.0
        local color = option.color or 0
        local range = option.range or true
        local label = option.label or "Default Blip Label"

        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)

        SetBlipSprite(blip, sprite)
        SetBlipDisplay(blip, display)
        SetBlipScale(blip, scale)
        SetBlipColour(blip, color)
        SetBlipAsShortRange(blip, range)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(label)
        EndTextCommandSetBlipName(blip)
        table.insert(listBlip, blip)
    end
end

function ww.clearBlip()
    for _, blip in pairs(listBlip) do
        RemoveBlip(blip)
    end
end

return ww.blip