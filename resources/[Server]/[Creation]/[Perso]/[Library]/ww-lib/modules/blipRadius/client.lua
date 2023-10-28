---@param blipRadius table The table containing the blipRadius data.

---@param coords vector4 The coords and the radius of the blipRadius.
---@param display number The display of the blipRadius.
---@param opacity number The opacity of the blipRadius.
---@param rotation number The rotation of the blipRadius.
---@param colour number The colour of the blipRadius.
---@param range boolean The range of the blipRadius.

local listBlipRadius = {}

function ww.blipRadius(data)
    for _,option in pairs(data.options) do
        local id = option.id or "defaultBlipID"
        local coords = option.coords or vec4(0.0, 0.0, 0.0, 0.0)
        local display = option.display or 4
        local opacity = option.opacity or 255
        local rotation = option.rotation or 0
        local colour = option.colour or 0
        local range = option.range or true



        local blip = AddBlipForRadius(coords.x, coords.y, coords.z, coords.w)

        SetBlipDisplay(blip, display)
        SetBlipAlpha(blip, opacity)
        SetBlipRotation(blip, rotation)
        SetBlipColour(blip, colour)
        SetBlipAsShortRange(blip, range)
        table.insert(listBlipRadius, blip)
    end
end

function ww.clearBlipRadius()
    for _, blip in pairs(listBlipRadius) do
        RemoveBlip(blip)
    end
end

return ww.blipRadius