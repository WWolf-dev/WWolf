function BankAccessNPC()
    for _, access in pairs(BankNPCs) do

    end
end

function SpawnBankNPC()
    for _, npc in pairs(BankNPCs) do
        local npcModel = lib.requestModel(npc.Model)
        local ped = CreatePed(4, npcModel, npc.Coords.x, npc.Coords.y, npc.Coords.z, npc.Coords.w, false, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetEntityAsMissionEntity(ped, true, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        TaskStartScenarioInPlace(ped, npc.Scenario, 0, true)
        SetPedAsNoLongerNeeded(ped)
    end
end