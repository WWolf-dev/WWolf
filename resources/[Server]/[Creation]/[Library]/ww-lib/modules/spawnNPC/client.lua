---@param spawnNPC table The table containing the spawnNPC data.

---@param id string The id of the npc.
---@param coords vector4 The coords and heading of the npc.
---@param model string The model of the npc.
---@param type number The type of the npc.
---@param network boolean is the npc networked.
---@param hosted boolean is the npc hosted.
---@param freeze boolean is the npc frozen.
---@param god boolean is the npc invincible.
---@param eventBlocked boolean is the npc event blocked.
---@param mission boolean is the npc set as mission entity.
---@param animation table The table containing the animation data.
---@param scenario table The table containing the scenario data.
---@param needed boolean is the npc model no longer needed.

local listNPC= {}

function ww.spawnNPC(data)
    for _, option in pairs(data.options) do
        local id = option.id
        local coords = option.coords
        local model = option.model
        local type = option.type or 4
        local network = option.isNetwork or false
        local hosted = option.isScriptHosted or false
        local freeze = option.isFrozen or false
        local god = option.isInvincible or false
        local eventBlocked = option.isTemporaryEventBlocked or false
        local mission = option.isSetAsMissionEntity or false

        local animation = option.animation
        local scenario = option.scenario
        local needed = option .isModelNoLongerNeeded or true


        ww.requestModel(model)

        if animation and animation.dict then
            ww.requestAnimDict(animation.dict)
        end

        local ped = CreatePed(type, model, coords.x, coords.y, coords.z, coords.w, network, hosted)
        FreezeEntityPosition(ped, freeze)
        SetEntityInvincible(ped, god)
        SetBlockingOfNonTemporaryEvents(ped, eventBlocked)
        SetEntityAsMissionEntity(ped, mission, mission)

        if animation and animation.dict and animation.name and (not scenario or not scenario.name) then
            TaskPlayAnim(ped, animation.dict, animation.name, 8.0, 8.0, -1, 1, 0, 0, 0, 0)
        elseif scenario and scenario.name and (not animation or not animation.dict or not animation.name) then
            TaskStartScenarioInPlace(ped, scenario.name, 0, true)
        elseif animation and animation.dict and animation.name and scenario and scenario.name then
            error("^1[ERROR]^7You can't have animation and scenario at the same time, please choose one or the other....")
        end

        if needed then
            SetModelAsNoLongerNeeded(model)
        end
        table.insert(listNPC, ped)
    end
end

function ww.clearNPC()
    for _, ped in pairs(listNPC) do
        if DoesEntityExist(ped) then
            DeleteEntity(ped)
        end
    end
    listNPC = {}
end

return ww.spawnNPC