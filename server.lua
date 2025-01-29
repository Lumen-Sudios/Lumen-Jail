-- Jail event handler
RegisterNetEvent("Lumen:JailPlayerServer")
AddEventHandler("Lumen:JailPlayerServer", function(targetId, jailtime)
    local targetPlayer = tonumber(targetId)
    if targetPlayer and GetPlayerName(targetPlayer) then
        TriggerClientEvent("Lumen:JailPlayer", targetPlayer, jailtime)
    end
end)

-- Unjail event handler
RegisterNetEvent("Lumen:UnjailPlayerServer")
AddEventHandler("Lumen:UnjailPlayerServer", function(targetId)
    local targetPlayer = tonumber(targetId)
    if targetPlayer and GetPlayerName(targetPlayer) then
        TriggerClientEvent("Lumen:UnjailPlayer", targetPlayer)
    end
end)