local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent("qb_weedprocessing:processWeed", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player.Functions.RemoveItem("empty_weed_bag", 1) then
        -- Possible strain rewards
        local strains = {
            "weed_ak47",
            "weed_skunk",
            "weed_purple-haze",
            "weed_og-kush"
        }

        -- Give a random strain
        local reward = strains[math.random(#strains)]
        Player.Functions.AddItem(reward, 1)

        -- Notify the player
        TriggerClientEvent("QBCore:Notify", src, "You processed weed and got " .. reward .. "!", "success")
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[reward], 'add')
    else
        TriggerClientEvent("QBCore:Notify", src, "You don’t have any weed bags to process!", "error")
    end
end)
